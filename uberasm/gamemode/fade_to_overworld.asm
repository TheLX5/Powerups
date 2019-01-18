init:
	jsl init_powerup_ram
	sep #$30
	phb
	lda #$04|!bank8
	pha
	plb
	jsl $04DAAD|!bank
	phk
	per $0006
	pea $DC68
	jml $04DD40|!bank
	plb
main:
	rtl