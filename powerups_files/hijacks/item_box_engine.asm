org $01C538|!base3
autoclean JML CheckItem

org $009095|!base3
autoclean JML ItemBoxFix	; execute custom code for item box graphics routine

org $028008|!base3
autoclean JML ItemBoxDrop		; execute custom code for item box item drop routine
autoclean dl ItemTilemap
dl CheckItem
dl init_powerups_code
dl PowerIndex
warnpc $02806F|!base3

org $02806F|!base3
if !dynamic_items != 0
dl init_powerup
endif

org $00D156|!base3
!a	jsl mushroom_animation_fix
org $00D15A|!base3
animation_fix:
	stz $71
	stz $9D
org $00D145|!base3
	bra animation_fix
org $00D16D|!base3
	bne animation_fix
org $00D18A|!base3
	beq animation_fix
org $00D270|!base3
	jmp animation_fix

org $009F6F|!base3		; part of the overworld fade-in routine
autoclean JML ClearDisable	; clear the item disable flag automatically