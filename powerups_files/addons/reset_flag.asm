reset_flag:		
		LDA	#$00
		STA	!disable_spin_jump
		STA	!mask_15
		STA	!flags
		STA	$73
		STA	$7B
		STA	$7D
		LDA	#$FF	
		STA	$1891|!base2
		JML	$01C309|!base3