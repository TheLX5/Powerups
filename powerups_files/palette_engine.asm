if !dynamic_z = 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Handle player palette
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Palette:
	STA	$00
		
	LDY	#$00
	LDX	$149B|!base2
	BNE	.flashing
	LDX	$1490|!base2
	BEQ	.per_powerup_handling
	TXA	
	CMP	#$1E
	BCC	.star_running_out
	BRA	.star_going_on
.flashing		
	LDA	$13
.star_running_out	
	LSR	#2
.star_going_on	
	AND	#$03
	ASL	
	STZ	$00
	STZ	$01
	INY	
	BRA	.do_normal
		
.per_powerup_handling		
	LDX	$19
	CPX	#$0B
	BNE	.do_normal
	LDA	!flags
	BEQ	.do_special
	LDA	$19
	ASL	
	ORA	$0DB3|!base2
	BRA	.do_normal
.do_special	
	LDA	$00
.do_normal		
	REP	#$20
	AND	#$00FE
		
	LSR	
	STA	$00
	ASL	#2
	CLC	
	ADC	$00
	ASL	#2

	CPY	#$00
	BNE	.Flash
	LDX	$0DB3|!base2
	BNE	.Luigi
	CLC	
	ADC.w	#MarioPalettes
	BRA	.Store
.Luigi
	CLC	
	ADC.w	#LuigiPalettes
	BRA	.Store
.Flash	
	CLC	
	ADC.w	#FlashPalettes
.Store		
	STA	$0D82|!base2
	SEP	#$20
	RTL	
endif