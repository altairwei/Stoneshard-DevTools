.localvar 2 arguments

:[0]
b [2]

> gml_Script_scr_console_output_list (locals=0, argc=2)
:[1]
pushi.e -15
pushi.e 0
push.v [array]self.argument
push.v self.output_list
call.i ds_list_add(argc=2)
popz.v
pushi.e -15
pushi.e 1
push.v [array]self.argument
push.v self.color_list
call.i ds_list_add(argc=2)
popz.v
exit.i

:[2]
push.i gml_Script_scr_console_output_list
conv.i.v
pushi.e -1
conv.i.v
call.i method(argc=2)
dup.v 0
pushi.e -1
pop.v.v [stacktop]self.scr_console_output_list
popz.v

:[end]