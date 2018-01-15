Main:
	lda #$00
	sta !cape_settings	;this setting always gets reset before the code
	sta !extra_tile_flag
	sta !extra_tile_offset_x
	sta !extra_tile_offset_x+1
	sta !extra_tile_offset_y
	sta !extra_tile_offset_y+1
	sta !extra_tile_frame
	sta !ride_yoshi_flag
	sta !clipping_flag
	sta !collision_flag
	sta !insta_kill_flag

	lda !timer
	beq +
	dec
	sta !timer
+	

	lda $19
	cmp #!max_powerup	;return if mario is exceding the max number of powerups
	beq +
	bcs .Return
+	
	phb
	phk
	plb
	rep #$30
	and #$00FF		;prepare a jump to the code.
	asl
	tax
	lda.w PowerupCode,x
	sta $00
	sep #$30
	ldx #$00
	jsr ($0000|!base1,x)
	plb
.Return	
	jml $00D066|!base3	;rip

PowerupCode:
	dw powerup_00
	dw powerup_01
	dw powerup_02
	dw powerup_03
	dw powerup_04
	dw powerup_05
	dw powerup_06
	dw powerup_07
	dw powerup_08
	dw powerup_09
	dw powerup_0A
	dw powerup_0B
	dw powerup_0C
	dw powerup_0D
	dw powerup_0E
	dw powerup_0F
	dw powerup_10
	dw powerup_11
	dw powerup_12