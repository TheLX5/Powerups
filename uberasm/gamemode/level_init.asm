init:	
	lda #$FF
	sta !item_gfx_oldest
	sta !item_gfx_latest

	lda $86
	sta !slippery_flag_backup

.init_cloud_data
	lda $19
	cmp #!cloud_flower_powerup_num
	bne +

	rep #$30
	phx
	ldx #$006C
-	
	lda $94
	sta.l !collision_data_x,x
	lda $96
	sta.l !collision_data_x+2,x
	dex #4
	bpl -
	plx
	sep #$30
+	
	;jsl decompress_gfx

	rtl