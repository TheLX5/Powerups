;org $00F5F8|!base3		; x77F8; disables the item falling automatically when you get hurt
;db $EA,$EA,$EA,$EA	; 22 08 80 02

org $01C538|!base3
autoclean JML CheckItem

org $009095|!base3
autoclean JML ItemBoxFix	; execute custom code for item box graphics routine

org $028008|!base3
autoclean JML ItemBoxDrop		; execute custom code for item box item drop routine
autoclean dl ItemTilemap
dl CheckItem
if !dynamic_items != 0
dl init_powerup
endif
warnpc $028072|!base3

org $009F6F|!base3		; part of the overworld fade-in routine
autoclean JML ClearDisable	; clear the item disable flag automatically