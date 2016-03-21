if !dynamic_z = 1
dynamic_z_code:
		LDA	$0D9B|!base2
		CMP	#$02
		BEQ	+
		REP	#$20
	if !enable_projectile_dma == 1
		incsrc projectile_dma_engine.asm
	endif		
		SEP	#$20
+			
		JML	$00A308|!base3
endif