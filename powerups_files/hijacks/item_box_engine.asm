org $01C538|!base3
	!a JML CheckItem
if !dynamic_items == 1
init_pballoon:
	jsl init_pballoon_item
	rts
endif

org $009095|!base3
autoclean JML ItemBoxFix	; execute custom code for item box graphics routine

org $028008|!base3
autoclean JML ItemBoxDrop		; execute custom code for item box item drop routine
autoclean dl ItemTilemap		;02800C
dl CheckItem				;02800F
dl init_powerups_code			;028012
dl PowerIndex				;028015
dl $FFFFFF	;reserved		;028018		;dl GFXData
dl $FFFFFF	;reserved		;02801B		;dl GFXData_compressed_flag	
dl $FFFFFF	;reserved		;02801E		;dl ExtraGFXData
dl $FFFFFF	;reserved		;028021		;dl ExtraGFXData_compressed_flag
dl $FFFFFF	;reserved		;028024		;dl gfx_decompression
dl $FFFFFF	;reserved		;028027		;dl actual_gfx_decompression
if !dynamic_items == 0
	dl powerup_tiles_powerup_tiles	;02802A
	dl $FFFFFF			;02802D
else
	dl dynamic_item_tiles		;02802A
	dl dynamic_item_tiles_box	;02802D
endif
dl SkipCheck				;028030


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