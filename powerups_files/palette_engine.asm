;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Handle player palette
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Palette:
	sta $00
		
	ldy #$00
	ldx $149B|!base2
	bne .flashing
	ldx $1490|!base2
	beq .per_powerup_handling
	cpx #$1E
	bcc .star_running_out
	bra .star_going_on
.flashing		
	lda $13
.star_running_out	
	lsr #2
.star_going_on	
	and #$03
	asl
	stz $00
	stz $01
	iny 	
	bra .do_normal
		
.per_powerup_handling
.do_special	
	lda $00
.do_normal		
	rep #$20
	and #$00FE
		
	lsr
	sta $00
	asl #2
	clc
	adc $00
	asl #2

	cpy #$00
	bne .Flash

	pha
	lda !player_num
	and #$00FF
	asl
	tax
	pla
	clc
	adc PalettePointers,x
	bra .store

.Flash	
	clc
	adc.w #FlashPalettes
.store		
	sta $0D82|!base2
	sep #$20
	rtl