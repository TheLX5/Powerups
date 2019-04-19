if !better_powerdown == 0
instant_kill:
	lda #$10
	tsb $78
	ldy #$1C
	lda !extra_tile_flag
	bit #$10
	beq .normal_priority
	ldy #$0C
.normal_priority
	lda #$F0
	sta $0301|!base2,y

	lda !slippery_flag_backup
	beq +
	sta $86
+	
	lda #$00
	sta !slippery_flag_backup
	sta !extra_tile_flag
	sta !cape_settings

	lda !insta_kill_flag
	beq .no_insta_kill
	pla
	pla
	pla
	jml $00F606|!base3
.no_insta_kill
if !disable_drop_item == 0
	jsl $028008|!base3
endif
	rtl
endif