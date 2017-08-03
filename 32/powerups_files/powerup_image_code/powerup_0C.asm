;;;;;;;;;;;;;;;;;;;;
;; Cat Mario

	lda $7B
	bpl .plus
	eor #$FF
	inc
.plus	
	rts