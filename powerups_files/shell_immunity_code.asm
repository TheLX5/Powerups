;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Shell immunity stuff
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

shell_immunity:
	LDA	$187A|!base2
	BEQ	.check_flag
	JML	$02A473|!base3
		
.check_flag	
	LDA	$170B|!base2,x
	CMP	#$0B
	BEQ	.try_protect
	CMP	#$0C
	BNE	.hurt
.try_protect	
	LDA	!shell_immunity
	BNE	.protect
.hurt		
	JML	$02A4AE|!base3	; hurt
		
.protect	
	LDA	#$01		; sfx
	STA	$1DF9|!base2
	LDA	#$0F		; hit counter
	STA	$176F|!base2,x		
	LDA	#$01		; puff of smoke
	STA	$170B|!base2,x
	JML	$02A4B2|!base3