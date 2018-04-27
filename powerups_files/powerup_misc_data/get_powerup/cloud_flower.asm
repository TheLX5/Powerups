give_cloud_flower:
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
	%flower_item(!cloud_flower_powerup_num,$0A,$1DF9)