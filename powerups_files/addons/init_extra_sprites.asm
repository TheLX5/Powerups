init_extra_sprites:
	jsl $07F722|!base3
	lda #$00
	sta !sprite_ram,x
	sta !1510,x
	sta !sprite_shock,x
	sta !sprite_shock_flags,x
	sta !sprite_shock_14,x
	rtl	