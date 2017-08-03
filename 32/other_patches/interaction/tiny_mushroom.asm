.tiny_mushroom		
		PHB	
		PHK	
		PLB	
		LDA	!7FAB10,x
		AND	#$08
		BNE	..is_custom
		LDA	!9E,x
		TAY	
		LDA.w	..spr_tab,y
		BRA	..done_with_spr_num
..is_custom					
		LDA	!7FAB9E,x
		TAY	
		LDA.w	..cust_spr_tab,y
..done_with_spr_num	
		PLB	
		BIT	#$40
		BNE	..bounce_off
		BIT	#$10
		BNE	..default_interaction
		BIT	#$20
		BNE	.platform_fix
		JMP	.clc_rts
..default_interaction	
		JMP	.recover_code_hit
..platform_fix		
		JMP	.force_sec_rts
..bounce_off			
		PHK	
		PEA.w	..SubVertPos-1
		PEA.w	$80CA-1
		JML	$01AD42|!base3
..SubVertPos	LDA	$0E
		CMP	#$EF
		BMI	..actually_bounce
..hit_from_below	
		JMP	.recover_code_hit
..actually_bounce	
		CPY	#$00
		BEQ	..hit_from_below
		LDA	#$03
		STA	$1DF9
		JSL	$01AA33|!base3
	;	JSL	$01AB99|!base3
		JMP	.clc_rts

	incsrc tiny_mushroom_table.asm