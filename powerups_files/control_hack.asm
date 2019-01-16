;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Disable certain controls as per the mask.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Controls:
	lda $0DA8|!base2,x
	sta $18
	lda !mask_15
	trb $15
	trb $16
	lda !mask_17
	trb $17
	trb $18
	lda #$00
	sta !mask_15
	sta !mask_17
	rtl	