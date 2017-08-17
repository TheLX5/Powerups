reset_flags:
	sta $71
	lda #$00
	sta !cape_settings
	sta !clipping_flag
	sta !collision_flag
	lda !insta_kill_flag
	beq +
	jml $00F606|!base3
+	
	stz $19
	jml $00F602|!base3