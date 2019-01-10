reset_flags:
	lda $19
	cmp #$02
	beq .cape_image

	ldy #$1C
	lda !extra_tile_flag
	bit #$10
	beq .hide
	ldy #$0C
	bra .hide	
.cape_image
	ldy #$08
	lda $13F9|!base2
	cmp #$01
	bne .hide
	ldy #$CC
.hide
	lda #$F0
	sta $0301|!base2,y
	lda #$10
	tsb $78

	stz $1407|!base2
	lda $13ED|!base2
	and #$7F
	sta $13ED|!base2

	lda !slippery_flag_backup
	beq +
	sta $86
+	
	lda #$00
	sta !slippery_flag_backup
	sta !disable_spin_jump
	sta !mask_15
	sta !mask_17
	sta !flags
	sta !timer
	sta !ride_yoshi_flag
	sta !ducking_flag
	sta !slide_flag
	sta !collision_flag
	sta !clipping_flag
	sta !misc
	sta !misc+1
	sta !flight_timer
	sta !shell_immunity
	sta !cape_settings
	sta !extra_tile_flag
	sta !extra_tile_offset_x
	sta !extra_tile_offset_x+1
	sta !extra_tile_offset_y
	sta !extra_tile_offset_y+1
	sta !extra_tile_frame
	sta !power_ram+0
	sta !power_ram+1
	sta !power_ram+2
	sta !power_ram+3
	sta !power_ram+4
	sta !power_ram+5
	sta !power_ram+6
	sta !power_ram+7
	sta !power_ram+8
	sta !power_ram+9
	sta !power_ram+10
	sta !power_ram+11
	sta !power_ram+12
	sta !power_ram+13
	sta !power_ram+14
	sta !power_ram+15

	lda !insta_kill_flag
	bne .insta_kill
	
	lda $19
	beq .insta_kill

	jml $00F5D9|!base3

.insta_kill
	lda #$00
	sta !insta_kill_flag
	jml $00F606|!base3