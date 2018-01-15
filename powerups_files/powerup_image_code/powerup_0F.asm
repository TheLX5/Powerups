

	lda $1891|!base2
	bne .return
	lda !flags
	beq .return
;	lda #%00011101
;	tsb $78
	lda $14
	lsr #2
	and #$03
	tax
	lda $76
	bne .no_flip
	txa
	clc
	adc #$04
	tax
.no_flip
	lda .imgs,x
	sta $13E0|!base2
.return
	rts

.imgs
	db $46,$47,$48,$49
	db $46,$49,$48,$47