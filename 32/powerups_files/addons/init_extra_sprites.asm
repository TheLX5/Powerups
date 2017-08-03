init_extra_sprites:
	jsl	$07F722|!base3
	lda	#$00
	sta	!extra_sprites,x
	rtl	