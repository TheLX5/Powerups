;;;;;;;;;;;;;;;;;;;
;; Penguin Suit (NSMBWii)
;;;;;;;;;;;;;;;;;;;

.image
	lda $75
	beq .no_water
	lda !flags
	bne .sliding
.return
	lda $71
	ora $13ED|!base2
	ora $1493|!base2
	ora $148F|!base2
	bne .no_water
	lda $149C|!base2
	beq .override
	lda $75
	bne +
	lda #$17
	bra .write
+	
	lda #$2C
	bra .write
.override
	lda !power_ram
.write
	sta $13E0|!base2

.no_water
	rts

.sliding
	lda $1891|!base2
	bne .return
	lda #$16
	bra .write