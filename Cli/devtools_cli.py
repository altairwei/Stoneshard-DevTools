#!/usr/bin/env python3
"""Drive Stoneshard with Z-DevTools from the command line.

The companion of the DevTools MCP server (Codes/Mcp) for agents that develop
and test mods: launch the game, wait for the main menu, load a save, run
console commands, press keys, click GUI elements, run events of instances,
take screenshots, read the game log, stop the game. Each step is one
short-lived process talking to http://127.0.0.1:8765/mcp, so a
game restart never leaves a dead connection behind - which is why this is a
CLI and not an MCP client setup. Python standard library only, Windows only.

Exit codes: 0 success, 1 the game reported an error, 2 usage or connection
problem, 3 timeout.
"""
import argparse
import base64
import ctypes
import http.client
import json
import os
import shutil
import socket
import subprocess
import sys
import tempfile
import time
from ctypes import wintypes

GAME_EXE = "StoneShard.exe"
STEAM_APP_ID = "625960"
STATE_DIR = os.path.join(tempfile.gettempdir(), "stoneshard-devtools")
LAUNCH_FILE = os.path.join(STATE_DIR, "launch.json")
# launch --win runs a copy of the data file under this name in the game folder
RUN_COPY = "devtools_cli.win"
# seconds per game_wait call: the server allows up to 50, MCP clients give up at 60
WAIT_CHUNK = 25
EXIT_OK, EXIT_GAME_ERROR, EXIT_USAGE, EXIT_TIMEOUT = 0, 1, 2, 3


class CliError(Exception):
    def __init__(self, message, code=EXIT_USAGE):
        super().__init__(message)
        self.code = code


# ---- the game process --------------------------------------------------------

kernel32 = ctypes.WinDLL("kernel32", use_last_error=True)
user32 = ctypes.WinDLL("user32", use_last_error=True)
kernel32.OpenProcess.restype = wintypes.HANDLE
kernel32.OpenProcess.argtypes = [wintypes.DWORD, wintypes.BOOL, wintypes.DWORD]
kernel32.GetExitCodeProcess.argtypes = [wintypes.HANDLE, ctypes.POINTER(wintypes.DWORD)]
kernel32.QueryFullProcessImageNameW.argtypes = [wintypes.HANDLE, wintypes.DWORD, wintypes.LPWSTR, ctypes.POINTER(wintypes.DWORD)]
kernel32.CloseHandle.argtypes = [wintypes.HANDLE]
WNDENUMPROC = ctypes.WINFUNCTYPE(wintypes.BOOL, wintypes.HWND, wintypes.LPARAM)
user32.EnumWindows.argtypes = [WNDENUMPROC, wintypes.LPARAM]
user32.EnumChildWindows.argtypes = [wintypes.HWND, WNDENUMPROC, wintypes.LPARAM]
user32.GetWindowThreadProcessId.argtypes = [wintypes.HWND, ctypes.POINTER(wintypes.DWORD)]
user32.IsWindowVisible.argtypes = [wintypes.HWND]
user32.GetClassNameW.argtypes = [wintypes.HWND, wintypes.LPWSTR, ctypes.c_int]
user32.SendMessageTimeoutW.argtypes = [wintypes.HWND, wintypes.UINT, wintypes.WPARAM, wintypes.LPVOID,
                                       wintypes.UINT, wintypes.UINT, ctypes.POINTER(ctypes.c_size_t)]
user32.SendMessageTimeoutW.restype = ctypes.c_size_t
user32.PostMessageW.argtypes = [wintypes.HWND, wintypes.UINT, wintypes.WPARAM, wintypes.LPARAM]
user32.MapVirtualKeyW.argtypes = [wintypes.UINT, wintypes.UINT]
user32.MapVirtualKeyW.restype = wintypes.UINT


def game_alive(pid):
    """True while pid is a running StoneShard.exe."""
    handle = kernel32.OpenProcess(0x1000, False, pid)  # PROCESS_QUERY_LIMITED_INFORMATION
    if not handle:
        return False
    try:
        code = wintypes.DWORD()
        if not kernel32.GetExitCodeProcess(handle, ctypes.byref(code)) or code.value != 259:  # STILL_ACTIVE
            return False
        buf = ctypes.create_unicode_buffer(1024)
        size = wintypes.DWORD(len(buf))
        if not kernel32.QueryFullProcessImageNameW(handle, 0, buf, ctypes.byref(size)):
            return True
        return os.path.basename(buf.value).lower() == GAME_EXE.lower()
    finally:
        kernel32.CloseHandle(handle)


def game_pids():
    """Process ids of every running StoneShard.exe."""
    out = subprocess.run(["tasklist", "/FI", "IMAGENAME eq " + GAME_EXE, "/FO", "CSV", "/NH"],
                         capture_output=True).stdout.decode("mbcs", "replace")
    pids = []
    for line in out.splitlines():
        cells = line.strip().strip('"').split('","')
        if len(cells) > 1 and cells[0].lower() == GAME_EXE.lower() and cells[1].isdigit():
            pids.append(int(cells[1]))
    return pids


def load_launch():
    try:
        with open(LAUNCH_FILE, encoding="utf-8") as f:
            return json.load(f)
    except (OSError, ValueError):
        return {}


def save_launch(info):
    os.makedirs(STATE_DIR, exist_ok=True)
    with open(LAUNCH_FILE, "w", encoding="utf-8") as f:
        json.dump(info, f, indent=1)


def current_pid():
    """The game launched by this CLI while it runs, else any running game, else None."""
    pid = load_launch().get("pid")
    if pid and game_alive(pid):
        return pid
    pids = game_pids()
    return pids[0] if pids else None


def window_text(hwnd):
    # WM_GETTEXT reaches controls of other processes, GetWindowText does not
    length = ctypes.c_size_t()
    if not user32.SendMessageTimeoutW(hwnd, 0x000E, 0, None, 0x0002, 500, ctypes.byref(length)):  # WM_GETTEXTLENGTH
        return ""
    buf = ctypes.create_unicode_buffer(length.value + 1)
    if not user32.SendMessageTimeoutW(hwnd, 0x000D, length.value + 1, ctypes.cast(buf, wintypes.LPVOID),
                                      0x0002, 500, ctypes.byref(length)):  # WM_GETTEXT
        return ""
    return buf.value


def class_name(hwnd):
    buf = ctypes.create_unicode_buffer(256)
    user32.GetClassNameW(hwnd, buf, 256)
    return buf.value


def game_dialogs(pid):
    """Texts of the dialog boxes the game shows. A GML error stops the game in one."""
    found = []

    def on_window(hwnd, _):
        owner = wintypes.DWORD()
        user32.GetWindowThreadProcessId(hwnd, ctypes.byref(owner))
        if owner.value == pid and user32.IsWindowVisible(hwnd) and class_name(hwnd) == "#32770":
            parts = [window_text(hwnd)]

            def on_child(child, _):
                if class_name(child) != "Button":
                    parts.append(window_text(child))
                return True

            user32.EnumChildWindows(hwnd, WNDENUMPROC(on_child), 0)
            found.append("\n".join(p.strip() for p in parts if p.strip()))
        return True

    user32.EnumWindows(WNDENUMPROC(on_window), 0)
    return found


def wait_exit(pid, seconds):
    """True once pid is gone, False if it still runs after seconds."""
    end = time.monotonic() + seconds
    while game_alive(pid):
        if time.monotonic() >= end:
            return False
        time.sleep(0.2)
    return True


def log_lines():
    """The debug log of the game launched last, or None. Leaves out the lines the runner writes for each
    connection, which are this CLI's own requests."""
    path = load_launch().get("log")
    try:
        with open(path, "rb") as f:
            lines = f.read().decode("utf-8", "replace").splitlines()
    except (OSError, TypeError):
        return None
    return [l for l in lines if not (l.startswith("Client(") and (") Connected: " in l or ") Disconnected: " in l))]


def log_tail(count):
    """The last count lines of log_lines(), or []."""
    return (log_lines() or [])[-count:]


def log_hint():
    lines = log_tail(15)
    if not lines:
        return ""
    return "\nthe end of its log (devtools_cli.py log):\n  " + "\n  ".join(lines)


def dialog_error(pid):
    """A CliError with the dialog boxes the game shows, or None."""
    dialogs = game_dialogs(pid)
    if not dialogs:
        return None
    return CliError("the game is stopped in a dialog box - usually a GML error; end it with: devtools_cli.py stop\n\n"
                    + "\n\n".join(dialogs), EXIT_GAME_ERROR)


# ---- keys ---------------------------------------------------------------------------
# Posted WM_KEYDOWN/WM_KEYUP messages reach the game window also while it is
# minimized or in the background, and nothing else: GameMaker's keyboard state,
# thus keyboard_check and keyboard_check_pressed - not keyboard_check_direct,
# which reads the real keyboard. Posted mouse messages do nothing: the game
# reads the real cursor.

KEY_NAMES = {"esc": 0x1B, "escape": 0x1B, "enter": 0x0D, "return": 0x0D, "space": 0x20, "tab": 0x09,
             "backspace": 0x08, "shift": 0x10, "ctrl": 0x11, "control": 0x11, "pageup": 0x21, "pagedown": 0x22,
             "end": 0x23, "home": 0x24, "left": 0x25, "up": 0x26, "right": 0x27, "down": 0x28,
             "insert": 0x2D, "delete": 0x2E}
MODIFIERS = (0x10, 0x11)
# a real keyboard flags the arrow and navigation block as extended keys
EXTENDED = (0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x2D, 0x2E)
ALT = (0x12, 0xA4, 0xA5)


def key_code(name):
    n = name.strip().lower()
    code = -1
    if n in KEY_NAMES:
        code = KEY_NAMES[n]
    elif len(n) == 1 and n.isascii() and n.isalnum():
        code = ord(n.upper())
    elif n[:1] == "f" and n[1:].isdigit() and 1 <= int(n[1:]) <= 24:
        code = 0x6F + int(n[1:])
    elif n[:6] == "numpad" and len(n) == 7 and n[6].isdigit():
        code = 0x60 + int(n[6])
    elif n[:3] == "vk:":
        try:
            code = int(n[3:], 0)
        except ValueError:
            code = -1
        if not 1 <= code <= 0xFE:
            code = -1
    if n == "alt" or code in ALT:
        raise CliError("alt is not supported: Windows handles it as a system key, and Alt+F4 would close the game")
    if code < 0:
        raise CliError("unknown key '%s' - use a letter or digit, f1-f24, numpad0-numpad9, %s, or vk:<code> - "
                       "a Windows virtual-key code such as vk:0xC0" % (name, ", ".join(sorted(KEY_NAMES))))
    return code


def key_combo(text):
    """The key codes of 'ctrl+c' and the like, modifiers first."""
    codes = [key_code(part) for part in text.split("+")]
    return sorted(codes, key=lambda code: code not in MODIFIERS)


def game_window(pid):
    """The game's own window (GameMaker's window class), visible ones first, or None."""
    found = []

    def on_window(hwnd, _):
        owner = wintypes.DWORD()
        user32.GetWindowThreadProcessId(hwnd, ctypes.byref(owner))
        if owner.value == pid and class_name(hwnd) == "YYGameMakerYY":
            found.append((not user32.IsWindowVisible(hwnd), hwnd))
        return True

    user32.EnumWindows(WNDENUMPROC(on_window), 0)
    found.sort(key=lambda f: f[0])
    return found[0][1] if found else None


def post_keys(hwnd, codes, hold):
    """Presses one key combination: down in order, up in reverse order, like fingers."""
    keys = []
    for code in codes:
        lparam = 1 | (user32.MapVirtualKeyW(code, 0) << 16)  # repeat count 1, scan code
        if code in EXTENDED:
            lparam |= 1 << 24
        keys.append((code, lparam))
    for code, lparam in keys:
        if not user32.PostMessageW(hwnd, 0x0100, code, lparam):  # WM_KEYDOWN
            raise CliError("cannot post keys to the game window: Windows error %d" % ctypes.get_last_error())
    time.sleep(hold)
    for code, lparam in reversed(keys):
        user32.PostMessageW(hwnd, 0x0101, code, lparam | (1 << 30) | (1 << 31))  # WM_KEYUP: was down, released


# ---- where the game is installed --------------------------------------------------

def steam_libraries():
    """Steam's library folders, Steam's own folder first."""
    try:
        import winreg
        with winreg.OpenKey(winreg.HKEY_CURRENT_USER, r"Software\Valve\Steam") as key:
            steam = winreg.QueryValueEx(key, "SteamPath")[0]
    except OSError:
        return []
    libs = [steam]
    try:
        with open(os.path.join(steam, "steamapps", "libraryfolders.vdf"), encoding="utf-8", errors="replace") as f:
            for line in f:
                cells = line.split('"')
                if len(cells) >= 5 and cells[1] == "path":
                    libs.append(cells[3].replace(chr(92) * 2, chr(92)))  # VDF escapes backslashes
    except OSError:
        pass
    return libs


def find_game_dir(explicit):
    """The Stoneshard folder: --game-dir, else STONESHARD_DIR, else Steam's libraries."""
    for folder in (explicit, os.environ.get("STONESHARD_DIR")):
        if folder:
            if not os.path.isfile(os.path.join(folder, GAME_EXE)):
                raise CliError("there is no %s in %s" % (GAME_EXE, folder))
            return os.path.abspath(folder)
    for lib in steam_libraries():
        manifest = os.path.join(lib, "steamapps", "appmanifest_%s.acf" % STEAM_APP_ID)
        try:
            with open(manifest, encoding="utf-8", errors="replace") as f:
                for line in f:
                    cells = line.split('"')
                    if len(cells) >= 5 and cells[1] == "installdir":
                        folder = os.path.normpath(os.path.join(lib, "steamapps", "common", cells[3]))
                        if os.path.isfile(os.path.join(folder, GAME_EXE)):
                            return folder
        except OSError:
            pass
    raise CliError("cannot find Stoneshard - pass --game-dir or set STONESHARD_DIR")


# ---- the MCP server ---------------------------------------------------------------

class Unreachable(CliError):
    """Nothing takes connections on the MCP port."""


class NoReply(CliError):
    """The server took the request but did not answer in time."""


class Game:
    """The DevTools MCP server of the running game (stateless JSON-RPC over HTTP)."""

    def __init__(self, port):
        self.port = port

    def rpc(self, method, params, timeout):
        body = json.dumps({"jsonrpc": "2.0", "id": 1, "method": method, "params": params}).encode("utf-8")
        conn = http.client.HTTPConnection("127.0.0.1", self.port, timeout=timeout)
        try:
            conn.request("POST", "/mcp", body, {"Content-Type": "application/json",
                                                "Accept": "application/json, text/event-stream"})
            resp = conn.getresponse()
            data = resp.read()
        except socket.timeout:
            raise NoReply("no reply from the game within %g s" % timeout, EXIT_TIMEOUT)
        except (OSError, http.client.HTTPException) as e:
            raise Unreachable("cannot reach the DevTools MCP server on port %d: %s" % (self.port, e))
        finally:
            conn.close()
        if resp.status != 200:
            raise CliError("the MCP server answered HTTP %d: %s" % (resp.status, data.decode("utf-8", "replace")[:300]))
        try:
            msg = json.loads(data.decode("utf-8"))
        except ValueError:
            raise CliError("the MCP server's reply is not JSON: %r" % data[:300])
        if "error" in msg:
            raise CliError("MCP error %s: %s" % (msg["error"].get("code"), msg["error"].get("message")))
        return msg.get("result", {})

    def call(self, tool, args=None, timeout=30):
        """(text, is_error, result) of a tools/call."""
        result = self.rpc("tools/call", {"name": tool, "arguments": args or {}}, timeout)
        text = "\n".join(c.get("text", "") for c in result.get("content", []) if c.get("type") == "text")
        return text, bool(result.get("isError")), result

    def check(self, tool, args=None, timeout=30):
        """The text of a tools/call, raising its error."""
        text, is_error, _ = self.call(tool, args, timeout)
        if is_error:
            raise CliError(text, EXIT_GAME_ERROR)
        return text


def explain(err, port):
    """err's message, completed with what the game process and its windows tell."""
    pid = current_pid()
    if isinstance(err, Unreachable):
        if pid is None:
            return "Stoneshard is not running - start it with: devtools_cli.py launch"
        return ("Stoneshard runs (pid %d), but nothing answers on port %d: the DevTools MCP server starts with the main "
                "menu (devtools_cli.py wait menu), unless the console command 'mcp start <port>' moved it (--port)"
                % (pid, port))
    if isinstance(err, NoReply) and pid is not None:
        dialog = dialog_error(pid)
        if dialog is not None:
            err.code = dialog.code
            return str(dialog)
        return str(err) + " - the game is busy or frozen"
    return str(err)


# ---- waiting ----------------------------------------------------------------------

def wait_phase(game, phase, deadline):
    """The game state once the game reaches phase ('menu' or 'session'), through game_wait calls."""
    last = None
    ran = current_pid() is not None
    while True:
        left = deadline - time.monotonic()
        if left <= 0:
            if last is None:
                raise CliError("timeout: the DevTools MCP server never answered - the game did not reach the main menu"
                               + log_hint(), EXIT_TIMEOUT)
            raise CliError(last, EXIT_TIMEOUT)
        chunk = max(1, min(WAIT_CHUNK, int(left)))
        try:
            text, is_error, _ = game.call("game_wait", {"phase": phase, "timeout": chunk}, timeout=chunk + 20)
        except Unreachable:
            # splash screens or the first frames of the menu: the server is not up yet
            if current_pid() is None:
                if not ran:
                    raise CliError("Stoneshard is not running - start it with: devtools_cli.py launch")
                raise CliError("the game exited" + log_hint(), EXIT_GAME_ERROR)
            time.sleep(0.5)
            continue
        except NoReply:
            pid = current_pid()
            if pid is None:
                raise CliError("the game exited" + log_hint(), EXIT_GAME_ERROR)
            dialog = dialog_error(pid)
            if dialog is not None:
                raise dialog
            last = last or "timeout: the game stopped answering while waiting for '%s'" % phase
            continue  # loading a save freezes the game for a while: the reply may just be late
        if not is_error:
            return text
        if text.startswith("timeout:"):
            last = text
        elif text.startswith("another game_wait"):
            time.sleep(0.5)  # the one given up on by an earlier call has not been answered yet
        else:
            raise CliError(text, EXIT_GAME_ERROR)


def settle(game, deadline):
    """The game state once the server answers and no room change or fade runs."""
    while True:
        try:
            state = json.loads(game.check("game_state", timeout=15))
            if state.get("phase") != "loading":
                return state
        except Unreachable:
            if current_pid() is None:
                raise
        except NoReply:
            pid = current_pid()
            dialog = dialog_error(pid) if pid is not None else None
            if dialog is not None:
                raise dialog
        if time.monotonic() >= deadline:
            raise CliError("timeout: the game is still loading", EXIT_TIMEOUT)
        time.sleep(0.5)


def load_save(game, names, allow_exitsave, deadline, wait=True):
    if len(names) > 2:
        raise CliError("give at most a character and a save folder, e.g. character_1 autosave_1")
    settle(game, deadline)
    args = {}
    if names:
        args["character"] = names[0]
    if len(names) > 1:
        args["save"] = names[1]
    if allow_exitsave:
        args["allow_exitsave"] = True
    print(game.check("game_load", args))
    if wait:
        print(wait_phase(game, "session", deadline))


# ---- commands ---------------------------------------------------------------------

def cmd_launch(a, game):
    game_dir = find_game_dir(a.game_dir)
    running = game_pids()
    if running and not a.force:
        raise CliError("Stoneshard already runs (pid %s) - end it first (devtools_cli.py stop) or pass --force"
                       % ", ".join(map(str, running)))
    if a.load is not None and len(a.load) > 2:
        raise CliError("--load takes at most a character and a save folder")
    cmd = [os.path.join(game_dir, GAME_EXE)]
    win = os.path.join(game_dir, "data.win")
    copy = None
    if a.win:
        win = os.path.abspath(a.win)
        if not os.path.isfile(win):
            raise CliError("there is no file " + win)
        run = win
        if os.path.normcase(os.path.dirname(win)) != os.path.normcase(os.path.abspath(game_dir)):
            # the game looks for its audio groups and fonts next to the data file: run a copy
            # in the game folder, like UndertaleModTool's test runs
            run = copy = os.path.join(game_dir, RUN_COPY)
            try:
                shutil.copyfile(win, copy)
            except OSError as e:
                raise CliError("cannot copy the data file into the game folder: %s" % e)
        cmd += ["-game", run]
    os.makedirs(STATE_DIR, exist_ok=True)
    log = os.path.join(STATE_DIR, "game.log")
    try:
        os.remove(log)
    except OSError:
        pass
    cmd += ["-debugoutput", log]
    # Steam sets these for the games it starts; without them the game may restart itself through Steam
    env = {k: v for k, v in os.environ.items() if k.upper() not in ("STEAMAPPID", "STEAMGAMEID")}
    env["SteamAppId"] = env["SteamGameId"] = STEAM_APP_ID
    flags = 0x00000008 | 0x00000200  # DETACHED_PROCESS | CREATE_NEW_PROCESS_GROUP
    popen = dict(cwd=game_dir, env=env, stdin=subprocess.DEVNULL, stdout=subprocess.DEVNULL,
                 stderr=subprocess.DEVNULL, close_fds=True)
    try:
        # out of the caller's job, so that the game outlives a shell that kills its children
        proc = subprocess.Popen(cmd, creationflags=flags | 0x01000000, **popen)  # CREATE_BREAKAWAY_FROM_JOB
    except OSError:
        proc = subprocess.Popen(cmd, creationflags=flags, **popen)
    info = {"pid": proc.pid, "game_dir": game_dir, "win": win, "copy": copy, "log": log,
            "started": time.strftime("%Y-%m-%d %H:%M:%S")}
    save_launch(info)
    print("launched Stoneshard, pid %d\n  data: %s%s\n  log:  %s"
          % (proc.pid, win, "\n  runs: " + copy if copy else "", log))
    end = time.monotonic() + 3
    while proc.poll() is None and time.monotonic() < end:
        time.sleep(0.25)
    if proc.poll() is not None:
        # gone within seconds: it crashed, or restarts itself through Steam - without -game and -debugoutput
        time.sleep(5)
        others = game_pids()
        if not others:
            raise CliError("the game exited right away (exit code %s)%s" % (proc.returncode, log_hint()),
                           EXIT_GAME_ERROR)
        info.update(pid=others[0], win=os.path.join(game_dir, "data.win"), copy=None, relaunched=True)
        save_launch(info)
        print("warning: the game restarted itself through Steam as pid %d - it runs the game folder's data.win, "
              "and writes no log" % others[0], file=sys.stderr)
    deadline = time.monotonic() + a.timeout
    if a.load is not None:
        print(wait_phase(game, "menu", deadline))
        load_save(game, a.load, a.allow_exitsave, deadline)
    elif a.wait:
        print(wait_phase(game, a.wait, deadline))


def cmd_load(a, game):
    load_save(game, a.names, a.allow_exitsave, time.monotonic() + a.timeout, not a.no_wait)


def cmd_wait(a, game):
    print(wait_phase(game, a.phase, time.monotonic() + a.timeout))


def cmd_state(a, game):
    print(game.check("game_state"))


def cmd_saves(a, game):
    text = game.check("game_saves")
    if a.json:
        print(text)
        return
    data = json.loads(text)
    last = data.get("last_save") or {}
    print("Continue loads: %s/%s" % (last.get("character"), last.get("save")))
    for ch in data.get("characters", []):
        head = ch.get("character", "?")
        if ch.get("name"):
            head += "  " + ch["name"]
        if ch.get("permadeath"):
            head += "  (permadeath)"
        print(head)
        for sv in ch.get("saves", []):
            print("  %-12s %-9s %-22s %s" % (sv.get("save", "?"), sv.get("type", "?"), sv.get("date", ""),
                                            sv.get("location", "")))
            if not sv.get("loadable"):
                print("      cannot load: " + sv.get("problem", "?"))
            elif sv.get("type") == "exitsave":
                print("      exit save: the game deletes it once loaded (--allow-exitsave)")


def cmd_exec(a, game):
    command = " ".join(a.command).strip()
    if not command:
        raise CliError("give a console command, e.g. devtools_cli.py exec help")
    text, is_error, _ = game.call("console_execute", {"command": command}, timeout=a.timeout)
    print(text)
    return EXIT_GAME_ERROR if is_error else EXIT_OK


def cmd_read(a, game):
    print(game.check("console_read", {"lines": a.lines}))


def cmd_shot(a, game):
    args = {} if a.max_width is None else {"max_width": a.max_width}
    text, is_error, result = game.call("screenshot", args, timeout=30)
    if is_error:
        raise CliError(text, EXIT_GAME_ERROR)
    images = [c for c in result.get("content", []) if c.get("type") == "image"]
    if not images:
        raise CliError("the reply holds no image: " + text, EXIT_GAME_ERROR)
    out = os.path.abspath(a.out or os.path.join(STATE_DIR, time.strftime("shot-%Y%m%d-%H%M%S.png")))
    os.makedirs(os.path.dirname(out), exist_ok=True)
    with open(out, "wb") as f:
        f.write(base64.b64decode(images[0]["data"]))
    print(out)
    print(text.split(". PNG saved")[0])


def cmd_key(a, game):
    pid = current_pid()
    if pid is None:
        raise CliError("Stoneshard is not running - start it with: devtools_cli.py launch")
    dialog = dialog_error(pid)
    if dialog is not None:
        raise dialog
    hwnd = game_window(pid)
    if not hwnd:
        raise CliError("Stoneshard (pid %d) has no game window yet" % pid)
    combos = [key_combo(k) for k in a.keys]  # a typo anywhere sends no key at all
    for i, codes in enumerate(combos):
        if i:
            time.sleep(a.gap)
        post_keys(hwnd, codes, a.hold)
    time.sleep(a.gap)  # the game's steps handle the keys before the next command looks
    print("pressed %s in Stoneshard (pid %d)" % (" ".join(a.keys), pid))


def cmd_event(a, game):
    args = {"target": a.target, "event": a.event}
    if a.all:
        args["all"] = True
    print(game.check("game_event", args, timeout=a.timeout))


def cmd_click(a, game):
    args = {"target": a.target}
    if a.right:
        args["button"] = "right"
    print(game.check("game_click", args, timeout=a.timeout))


def cmd_tools(a, game):
    tools = game.rpc("tools/list", {}, 15).get("tools", [])
    if a.json:
        print(json.dumps(tools, indent=1, ensure_ascii=False))
        return
    for t in tools:
        print("%-16s %s" % (t.get("name"), t.get("description", "")))


def cmd_call(a, game):
    try:
        args = json.loads(a.arguments)
    except ValueError as e:
        raise CliError("the arguments are not JSON: %s" % e)
    result = game.rpc("tools/call", {"name": a.tool, "arguments": args}, a.timeout)
    for c in result.get("content", []):
        if c.get("type") == "image" and isinstance(c.get("data"), str):
            c["data"] = "<%d base64 characters>" % len(c["data"])
    print(json.dumps(result, indent=1, ensure_ascii=False))
    return EXIT_GAME_ERROR if result.get("isError") else EXIT_OK


def cmd_status(a, game):
    info = load_launch()
    pid = current_pid()
    if pid is None:
        print("Stoneshard: not running")
    else:
        mine = info.get("pid") == pid
        print("Stoneshard: running, pid %d%s" % (pid, "" if mine else " - not started by devtools_cli.py"))
        if mine:
            print("  data: %s" % info.get("win"))
            if info.get("copy"):
                print("  runs: %s" % info["copy"])
            print("  log:  %s\n  started %s" % (info.get("log"), info.get("started")))
        dialog = dialog_error(pid)
        if dialog is not None:
            print(str(dialog))
    try:
        print("MCP server, port %d: %s" % (game.port, game.check("game_state", timeout=5)))
        return EXIT_OK
    except CliError as e:
        print("MCP server, port %d: %s" % (game.port, e))
        return EXIT_USAGE


def cmd_stop(a, game):
    pid = current_pid()
    if pid is None:
        print("Stoneshard is not running")
        remove_copy()  # it may have exited on its own: crashed, or closed by hand
        return
    if not a.kill and dialog_error(pid) is None:
        # the console's exit command: game_end, whose events save nothing
        asked = True
        try:
            game.call("console_execute", {"command": "exit"}, timeout=5)
        except Unreachable:
            asked = False
        except CliError:
            pass  # sent; the reply got lost
        if asked and wait_exit(pid, 10):
            print("Stoneshard (pid %d) exited" % pid)
            remove_copy()
            return
    subprocess.run(["taskkill", "/PID", str(pid), "/T", "/F"], capture_output=True)
    if not wait_exit(pid, 10):
        raise CliError("cannot end Stoneshard (pid %d)" % pid, EXIT_GAME_ERROR)
    print("Stoneshard (pid %d) killed" % pid)
    remove_copy()


def remove_copy():
    """Delete the copy of a data file that launch --win put in the game folder, unless a game still runs."""
    path = load_launch().get("copy")
    if not path or not os.path.exists(path):
        return
    # the file stays locked for a moment after the game exited
    end = time.monotonic() + 10
    while True:
        if not game_pids():
            try:
                os.remove(path)
                return
            except OSError:
                pass
        if time.monotonic() >= end:
            print("note: cannot delete %s yet - the next launch --win replaces it" % path, file=sys.stderr)
            return
        time.sleep(0.5)


def cmd_log(a, game):
    lines = log_lines()
    if lines is None:
        raise CliError("no game log: only a game started by devtools_cli.py launch writes one")
    if a.grep:
        lines = [line for line in lines if a.grep.lower() in line.lower()]
    for line in lines[-a.lines:] if a.lines > 0 else lines:
        print(line)


# ---- command line -----------------------------------------------------------------

def build_parser():
    p = argparse.ArgumentParser(prog="devtools_cli.py", description=__doc__.split("\n\n")[0],
                                epilog="Typical run: launch --win <built .win> --load, then exec / shot / "
                                       "log as needed, then stop.")
    p.add_argument("--port", type=int, default=int(os.environ.get("STONESHARD_MCP_PORT", "8765")),
                   help="the MCP server's port (default: STONESHARD_MCP_PORT, else 8765)")
    sub = p.add_subparsers(dest="command_name", metavar="COMMAND")
    sub.required = True

    s = sub.add_parser("launch", help="start the game detached; optionally wait for a phase or load a save")
    s.add_argument("--win", help="data file to run instead of the game folder's data.win, e.g. a build's out.win; "
                   "a file from elsewhere runs as a copy in the game folder (%s), which stop deletes" % RUN_COPY)
    s.add_argument("--game-dir", help="the Stoneshard folder (default: STONESHARD_DIR, else found through Steam)")
    s.add_argument("--wait", choices=["menu", "session"], help="return once the game reaches this phase")
    s.add_argument("--load", nargs="*", metavar="NAME",
                   help="then load [CHARACTER [SAVE]] and wait for the session; no names: the save Continue loads")
    s.add_argument("--allow-exitsave", action="store_true", help="let --load load an exit save, which the game deletes")
    s.add_argument("--timeout", type=float, default=180, help="seconds to wait in all (default 180)")
    s.add_argument("--force", action="store_true", help="launch even though Stoneshard already runs")
    s.set_defaults(func=cmd_launch)

    s = sub.add_parser("status", help="is the game running, does its MCP server answer, does it show a dialog box")
    s.set_defaults(func=cmd_status)

    s = sub.add_parser("state", help="where the game is: phase, room, last save")
    s.set_defaults(func=cmd_state)

    s = sub.add_parser("wait", help="wait until the game reaches a phase and print its state")
    s.add_argument("phase", choices=["menu", "session"])
    s.add_argument("--timeout", type=float, default=120, help="seconds (default 120)")
    s.set_defaults(func=cmd_wait)

    s = sub.add_parser("saves", help="list the characters and their saves, newest first")
    s.add_argument("--json", action="store_true", help="print game_saves' JSON")
    s.set_defaults(func=cmd_saves)

    s = sub.add_parser("load", help="load a save - a running session is dropped unsaved - and wait for the session")
    s.add_argument("names", nargs="*", metavar="NAME",
                   help="CHARACTER [SAVE] folders from 'saves'; none: the save Continue loads; no SAVE: the newest")
    s.add_argument("--allow-exitsave", action="store_true", help="load an exit save, which the game then deletes")
    s.add_argument("--no-wait", action="store_true", help="return once loading has started")
    s.add_argument("--timeout", type=float, default=180, help="seconds (default 180)")
    s.set_defaults(func=cmd_load)

    s = sub.add_parser("exec", help="run a console command and print what it printed")
    s.add_argument("--timeout", type=float, default=60, help="seconds (default 60)")
    s.add_argument("command", nargs=argparse.REMAINDER, help="the command line, e.g. gold 500")
    s.set_defaults(func=cmd_exec)

    s = sub.add_parser("read", help="print the newest lines of the console output")
    s.add_argument("lines", nargs="?", type=int, default=50)
    s.set_defaults(func=cmd_read)

    s = sub.add_parser("shot", help="save a screenshot as PNG and print its path")
    s.add_argument("--out", help="the PNG to write (default: a new file in %s)" % STATE_DIR)
    s.add_argument("--max-width", type=int, help="downscale to at most this width; 0: full size (default 1280)")
    s.set_defaults(func=cmd_shot)

    s = sub.add_parser("key", help="press keys in the game window, also while it is minimized or in the background; "
                                   "reaches keyboard_check and keyboard_check_pressed, not keyboard_check_direct")
    s.add_argument("keys", nargs="+", metavar="KEY",
                   help="a letter or digit, esc, enter, space, tab, backspace, shift, ctrl, left, up, right, down, "
                        "home, end, pageup, pagedown, insert, delete, f1-f24, numpad0-numpad9 or vk:<code>, or a "
                        "combination such as ctrl+c; several keys are pressed in turn")
    s.add_argument("--hold", type=float, default=0.15, help="seconds each key stays down (default 0.15)")
    s.add_argument("--gap", type=float, default=0.4, help="seconds after each key (default 0.4)")
    s.set_defaults(func=cmd_key)

    s = sub.add_parser("event", help="run one event of an instance with event_perform, as the game's own code does")
    s.add_argument("target", help="an object name, or an instance id such as 100234 (exec getinstances <object>)")
    s.add_argument("event", help="as in the decompiled file names - Other_10 (user event 0), Mouse_4, KeyPress_27, "
                                 "Alarm_0 - or user_N for user event N")
    s.add_argument("--all", action="store_true", help="run it on every instance of the object")
    s.add_argument("--timeout", type=float, default=20, help="seconds (default 20)")
    s.set_defaults(func=cmd_event)

    s = sub.add_parser("click", help="click an instance without the real cursor - GUI buttons react as to a player")
    s.add_argument("target", help="an object name, or an instance id such as 100234; for an object with several "
                                  "instances the error lists them")
    s.add_argument("--right", action="store_true", help="the right mouse button")
    s.add_argument("--timeout", type=float, default=20, help="seconds (default 20)")
    s.set_defaults(func=cmd_click)

    s = sub.add_parser("tools", help="list the MCP server's tools")
    s.add_argument("--json", action="store_true", help="print the tools with their input schemas")
    s.set_defaults(func=cmd_tools)

    s = sub.add_parser("call", help="call any MCP tool and print the raw result")
    s.add_argument("tool")
    s.add_argument("arguments", nargs="?", default="{}", help="JSON object (default {})")
    s.add_argument("--timeout", type=float, default=60, help="seconds (default 60)")
    s.set_defaults(func=cmd_call)

    s = sub.add_parser("stop", help="end the game - the console's exit, else kill it; nothing is saved")
    s.add_argument("--kill", action="store_true", help="kill it right away")
    s.set_defaults(func=cmd_stop)

    s = sub.add_parser("log", help="print the end of the debug log of the game launched last, "
                                   "without the lines for this CLI's connections")
    s.add_argument("lines", nargs="?", type=int, default=40, help="how many lines; 0: all (default 40)")
    s.add_argument("--grep", help="only lines holding this text, any case")
    s.set_defaults(func=cmd_log)
    return p


def main(argv=None):
    # agents read the output through pipes: UTF-8 there, whatever the console code page
    for stream in (sys.stdout, sys.stderr):
        if not stream.isatty():
            stream.reconfigure(encoding="utf-8", errors="replace")
    a = build_parser().parse_args(argv)
    game = Game(a.port)
    try:
        return a.func(a, game) or EXIT_OK
    except CliError as e:
        message = explain(e, a.port)
        print(message, file=sys.stderr)
        return e.code
    except KeyboardInterrupt:
        return 130


if __name__ == "__main__":
    sys.exit(main())
