if !better_powerdown == 0
instant_kill:
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