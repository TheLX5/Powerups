;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Shell suit
;; by LX5
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		LDA	$1891|!base2
		BNE	.Return
		LDA	!flags
		BEQ	.Return
		LDA	#%00011101
		TSB	$78
		LDA	$14
		LSR	#2
		AND	#$03
		TAX	
		LDA	$76
		BNE	.NoFlip
		TXA	
		CLC	
		ADC	#$04
		TAX	
.NoFlip		LDA.w	ShellImages,x
		STA	$13E0|!base2
.Return			
		RTS	
ShellImages:
		db $46,$47,$48,$49
		db $46,$49,$48,$47