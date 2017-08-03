		LDA	$74		; yoshi
		ORA	$187A|!base2
		ORA	$1470|!base2
		BNE	.return
		LDA	$73
		BEQ	.not_ducking
		LDA	#$01
		STA	!shell_immunity
		RTS	
.not_ducking		
		LDA	#$00
		STA	!shell_immunity
		BIT	$16
		BVS	.shoot_hammer
		LDA	$140D|!base2
		BEQ	.return
		INC	$13E2|!base2
		LDA	$13E2|!base2
		AND	#$0F
		BNE	.return
		TAY	
		LDA	$13E2|!base2
		AND	#$10
		BEQ	+
		INY	
+		STY	$76
.shoot_hammer		
		LDY	#$09
.find_slot		
		LDA	$170B|!base2,y
		BEQ	.found_slot
		DEY	
		CPY	#$07
		BNE	.find_slot
.return		RTS	
.found_slot		
		LDA	#$01
		STA	!projectile_do_dma
		LDA	#$06
		STA	$1DFC|!base2
		LDA	#$0A
		STA	$149C|!base2
		LDA	#!hammer_num
		STA	$170B|!base2,y
		LDA	#$C0
		STA	$173D|!base2,y
		TYX	
		LDA	#$00
		STA	!extra_extended,x
		STA	!extra_extended_2,x
		TXY	
		STZ	$00
		LDA	$76
		CLC	
		ROR 	#2
		EOR	$7B
		BPL	+
		LDA	$7B
		STA	$00
+		LDA	#$10
		LDX	$76
		BNE	+
		EOR	#$FF
		INC	A
+		CLC	
		ADC	$00
		STA	$1747|!base2,y
.shared
++		LDX	#$00
		LDA	$187A|!base2
		BEQ	.skip
		INX	#2
		LDA	$18DC|!base2
		BEQ	.skip
		INX	#2
.skip		LDA	$94
		CLC	
		ADC	$00FE96|!base3,x
		STA	$171F|!base2,y
		LDA	$95
		ADC	$00FE9C|!base3,x
		STA	$1733|!base2,y
		LDA	$96
		CLC	
		ADC	$00FEA2|!base3,x
		STA	$1715|!base2,y
		LDA	$97
		ADC	#$00
		STA	$1729|!base2,y
		LDA	$13F9|!base2
		STA	$1779|!base2,y
		RTS	