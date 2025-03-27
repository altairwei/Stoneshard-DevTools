function scr_console_respec()
{
    var STR = scr_atr("STR")
    var AGL = scr_atr("AGL")
    var PRC = scr_atr("PRC")
    var Vitality = scr_atr("Vitality")
    var WIL = scr_atr("WIL")

    var _ap_spent = STR - 10 + AGL - 10 + PRC - 10 + WIL - 10 + Vitality - 10;
    scr_atr_incr("AP", _ap_spent);

    scr_atr_set("STR", 10);
    scr_atr_set("AGL", 10);
    scr_atr_set("PRC", 10);
    scr_atr_set("Vitality", 10);
    scr_atr_set("WIL", 10);

    scr_atr_calc(o_player);
}