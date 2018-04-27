reset_flags:
	sta $71
	ldy #$1C
	lda !extra_tile_flag
	bit #$10
	beq .normal_priority
	ldy #$0C
.normal_priority
	lda #$F0
	sta $0301|!base2,y

	stz $1407|!base2
	lda $13ED|!base2
	and #$7F
	sta $13ED|!base2

	lda #$00
	sta !disable_spin_jump
	sta !mask_15
	sta !mask_17
	sta !flags
	sta !timer
	sta !misc
	sta !shell_immunity
	sta !cape_settings
	sta !extra_tile_flag
	sta !extra_tile_offset_x
	sta !extra_tile_offset_x+1
	sta !extra_tile_offset_y
	sta !extra_tile_offset_y+1
	sta !extra_tile_frame
	sta !ride_yoshi_flag
	lda !insta_kill_flag
	beq +
	jml $00F606|!base3
+	
	stz $19
	jml $00F602|!base3