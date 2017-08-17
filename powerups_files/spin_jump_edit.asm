;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Handle spin jump ability
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SpinJump:
	phx	
	ldx $19
	lda.l SpinJumpData,x
	eor !disable_spin_jump
	beq +
	sta $140D|!base2
	lda #$04
	sta $1DFC|!base2
	bra ++
+	
	lda #$00
	sta !disable_spin_jump
	
if read1($008075|!base3) = $5C
	lda #$35
	sta $1DFC|!base2
else
	inc 
	sta $1DFA|!base2
endif
++		
	plx
	rtl	