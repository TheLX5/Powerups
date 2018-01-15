if !better_powerdown == 0
instant_kill:
	sta $71
	lda !insta_kill_flag
	beq .no_insta_kill
	jml $00F606|!base3
.no_insta_kill
	stz $19
	jml $00F602|!base3
endif