main:	
init:
	stz $13E0|!addr
	jsl init_powerup_ram
if !gfx_compression == 1
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
endif
+	
	rtl