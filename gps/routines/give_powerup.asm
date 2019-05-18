	phy
	phx
	lda $15E9|!addr
	pha
	ldx #$00
	stx $15E9|!addr
	lda !9E
	pha
	lda !7FAB9E
	pha
	lda !190F
	pha
	lda $00
	sta !9E
	sta !7FAB9E
	lda $01
	sta !190F
	lda $028030|!bank
	sta $00
	lda $028031|!bank
	sta $01
	lda $028032|!bank
	sta $02
	phk
	pea.w .grab_item-1
	pea.w $80C9
	jml [!dp]
.grab_item
	pla
	sta !190F
	pla
	sta !7FAB9E
	pla
	sta !9E
	pla
	sta $15E9|!addr
	plx
	ply
	rtl