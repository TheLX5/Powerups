		LDA	!flags
		ASL	
		TAX	
		JSR	(.Ptrs,x)

		BIT	$16
		BVC	.NoCapeSpin

		LDA	$73
		ORA	$74
		ORA	$187A|!base2
		ORA	$140D|!base2
		ORA	$1470|!base2
		ORA	$13E3|!base2
		BNE	.NoCapeSpin

		LDA	#$08
		STA	$14A6|!base2
		LDA	#$04
		STA	$1DFC|!base2
.NoCapeSpin
		RTS	

.Ptrs		dw	.Init
		dw	.Statue
		dw	.Reset

.Init		
		LDA	$74
	;	ORA	$74
		ORA	$187A|!base2
	;	ORA	$140D|!base2
		ORA	$148F|!base2
		ORA	$13ED|!base2
		ORA	$13E3|!base2
		BNE	.NoCapeSpin
		LDA	!wait_timer
		BNE	.NoCapeSpin
		LDA	$15
		AND	#$04
		BEQ	.NoCapeSpin
		LDA	$16
		AND	#$40
		BEQ	.NoCapeSpin
		LDA	#$01
		STA	!flags
		LDA	#$FF
		STA	!mask_17
		LDA	#$BB
		STA	!mask_15
		STZ	$7D
		STZ	$7B
		LDA	#$FF
		STA	!wait_timer
		LDA	#$04
		STA	!timer
		STA	$18BD|!base2
		LDA	#$10
		STA	$1DF9|!base2
		STZ	$1DFC|!base2
		JSL	$01C5AE|!base3
		STZ	$140D|!base2
		RTS	
.Statue	
		LDA	!wait_timer
		BEQ	.CancelStatue
		LDA	#$FF
		STA	!mask_17
		LDA	#$FB	;BB
		STA	!mask_15
		STZ	$7B		
		STZ	$140D|!base2
		STZ	$14A6|!base2
		LDA	$15
		AND	#$04
		STA	$15
		BEQ	.CancelStatue
		RTS	
.CancelStatue	
		LDA	#$02
		STA	!flags
		LDA	#$04
		STA	!timer
		STA	$18BD|!base2
		LDA	#$10
		STA	$1DF9|!base2
		JSL	$01C5AE|!base3
		LDA	#$FF
		STA	$78
		RTS	
.Reset		
		LDA.l	!timer
		BEQ	.force_reset
		DEC	A
		STA.l	!timer
		STZ	$140D|!base2
		STZ	$14A6|!base2
		LDA	#$FF
		STA	!mask_17
		LDA	#$FB
		STA	!mask_15
		RTS	
.force_reset		
		LDA	#$00
		STA	!flags
		LDA	#$04
		STA	!wait_timer
		RTS	

pushpc
org $00CD4E|!base3
	JML check_climb
pullpc
check_climb:
	LDA	$19
	CMP	#$09
	BNE	+
	LDA	!flags
	CMP	#$01
	BEQ	++
+		
	LDA	$148F|!base2
	ORA	$187A|!base2
	BNE	++		
	JML	$00CD56|!base3
++	
	JML	$00CD79|!base3