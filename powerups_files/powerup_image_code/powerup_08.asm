;;;;;;;;;;;;;;;;;;;
;; Frog Suit (SMB3)
;;;;;;;;;;;;;;;;;;;

.image
	lda $75
	bne .override
	lda $77
	and #$04
	bne .in_ground
	rts
.in_ground
	lda $15
	and #$03
	bne .not_looking_up
	lda $15
	and #$08
	beq .not_looking_up
	lda #$03
	bra .end
.not_looking_up

.override
	lda !power_ram
.end
	sta $13E0
.no
	rts