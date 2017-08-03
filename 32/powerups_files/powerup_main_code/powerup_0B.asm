;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Shell suit
;; by LX5
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		LDA	$187A|!base2
		ORA	$1470|!base2
		BNE	.reset
		LDA	!flags
		ASL	
		TAX	
		JMP	(.PowerBPtrs,x)
		RTS	
.PowerBPtrs	
		dw	.CheckDownAndRun
		dw	.Sliding
			
.Sliding	
		STZ	$149B|!base2
		STZ	$18D2|!base2
		LDA	#$01
		STA	!disable_spin_jump
		STA	$73
		LDA	$75
		BEQ	.no_water
		LDA	$77
		AND	#$04
		BNE	.no_water
		LDA	#$80
.no_water	
		ORA	#$0F
		STA	!mask_15
		LDY	$76
		LDA.w	.InShellSpeed,y
		STA	$7B
		LDA	$77
		BIT	#$01
		BEQ	+
		STZ	$76
		LDA	#$01
		STA	$1DF9|!base2
		JSR	.CapeSpin
+		BIT	#$02
		BEQ	.NotInShell
		LDA	#$01
		STA	$76
		LDA	#$01
		STA	$1DF9|!base2
		JSR	.CapeSpin
.NotInShell
		BIT	$15
		BVS	.HoldXY
.reset
		LDA	#$00
		STA	!disable_spin_jump
		STA	!mask_15
		STA	!flags
		STA	$73
.HoldXY
		RTS	

.CapeSpin	;LDA	$19
		;ASL	
		;TAX	
		LDY	$76
		REP	#$20
		LDA	$94
		STA	$13E9|!base2
		LDA	$96
		CLC	
		ADC	#$0014
		STA	$13EB|!base2
		SEP	#$20
		LDA	#$04
		STA	$13E8|!base2
		RTS	

.CheckDownAndRun
.more_checks		
		LDA	$13E4|!base2
		CMP	#$64
		BCC	.no_active
		CMP	#$70
		BCS	.no_active
		LDA	$73
		BEQ	.no_active
		LDA	#$01
		STA	!flags
		STA	$73
		LDA	$13E3|!base2
		BEQ	.no_active
		PHB	
		LDA	#$80
		PHA	
		PLB	
		PHK	
		PEA.w	.no_wall-1	;stop wall-walking
		PEA.w	$84CF-1
		JML	$00EB42|!base3
.no_wall	PLB	
.no_active		
		RTS	

.InShellSpeed
		db $D0,$30