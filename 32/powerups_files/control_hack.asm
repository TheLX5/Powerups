;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Disable certain controls as per the mask.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Controls:
	LDA	$0DA8|!base2,x
	STA	$18
	LDA	!mask_15
	TRB	$15
	TRB	$16
	LDA	!mask_17
	TRB	$17
	TRB	$18
	LDA	#$00
	STA	!mask_15
	STA	!mask_17
	RTL	