;;;;;;;;;;;;;;;
;; Cape powerup
;;;;;;;;;;;;;;;

	lda.b #%00010111
	sta !cape_settings
		
	bit $16
	bvc .Return
		
	lda $73
	ora $74
	ora $187A|!base2
	ora $140D|!base2
	ora $1470|!base2
	ora $13E3|!base2
	bne .Return
	
	lda #$12
	sta $14A6|!base2
	lda #$04
	sta $1DFC|!base2
.Return		
	rts
