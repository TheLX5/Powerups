Main:
	LDA	$19
	CMP	#!max_powerup
	BEQ	+
	BCS	.Return
+	
	PHA		
	LDA	!wait_timer
	BEQ	.zero
	DEC	A
	STA	!wait_timer
.zero		
	PLA	
	PHB	
	PHK	
	PLB	
	REP	#$30
	AND	#$00FF
	ASL	
	TAX	
	LDA.w	PowerupCode,x
	STA	$00
	SEP	#$30
	LDX	#$00
	JSR	($0000|!base1,x)
	PLB	
.Return		
	JML	$00D066|!base3

PowerupCode:
	dw powerup_00
	dw powerup_01
	dw powerup_02
	dw powerup_03
	dw powerup_04
	dw powerup_05
	dw powerup_06
	dw powerup_07
	dw powerup_08
	dw powerup_09
	dw powerup_0A
	dw powerup_0B
	dw powerup_0C
	dw powerup_0D
	dw powerup_0E
	dw powerup_0F