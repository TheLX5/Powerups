;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Handle player palette
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Palette:
	STA	$00
	LDX	$19
	CPX	#$0B
	BNE	++
	LDA	!flags
	BEQ	+
	LDA	$19
	ASL	
	ORA	$0DB3|!base2
	BRA	++
+		
	LDA	$00
++		
	REP	#$20
	AND	#$00FE
		
	LSR	
	STA	$00
	ASL	#2
	CLC	
	ADC	$00
	ASL	#2

	LDX	$0DB3|!base2
	BNE	.Luigi
	CLC	
	ADC.w	#MarioPalettes
	BRA	+
	
.Luigi
	CLC	
	ADC.w	#LuigiPalettes
	
+	STA	$0D82|!base2
	SEP	#$20
	RTL	