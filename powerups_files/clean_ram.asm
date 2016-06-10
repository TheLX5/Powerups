reset_flags:
	STA	$71
	LDA	#$00
	STA	!cape_settings
	if !tiny_mushroom_inserted = 1
		LDA	$19
		CMP	#!tiny_mushroom_powerup_num
		BNE	+	
		LDA	#$00
		STA	!clipping_flag
		STA	!collision_flag
		JML	$00F606
	endif
+	
	STZ	$19
	JML	$00F602