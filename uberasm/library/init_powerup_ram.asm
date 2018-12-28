init_powerup_ram:
	lda #$80
	sta $0F
	ldx $19
	lda.l powerup_indexes,x
	phk
	pea.w .return-1
	pea.w $80C9
	jml read3($028012|!base3)
.return
	stz $1DFC|!addr
	stz $1DF9|!addr
	stz $9D
	stz $149B|!base2
	stz $71
	rtl

powerup_indexes:
	db $00	;small
	db $00	;mushroom
	db $03	;cape
	db $04	;fire
	db $06	;hammer
	db $07	;boomerang
	db $08	;leaf
	db $09	;tanooki
	db $0A	;frog
	db $0B	;superball
	db $0C	;rocket
	db $0D	;mini
	db $0E	;ice
	db $0F	;penguin (unused)
	db $10	;propeller
	db $11	;shell
	db $12	;bubble
	db $13	;cloud
	db $14	;cat