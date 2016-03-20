;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Handle spin jump ability
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SpinJump:
	PHX	
	LDX	$19
	LDA.l	SpinJumpData,x
	EOR	!disable_spin_jump
	BEQ	+
	STA	$140D|!base2
	LDA	#$04
	STA	$1DFC|!base2
	BRA	++
+		
	LDA	#$00
	STA	!disable_spin_jump
	INC	
	STA	$1DFA|!base2
++		
	PLX	
	RTL	