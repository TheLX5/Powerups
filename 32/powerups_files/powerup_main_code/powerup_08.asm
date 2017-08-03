		LDA.b	#%00111011
		STA	!cape_settings
		LDA	#$90
		STA	!flight_timer

		BIT	$16
		BVC	.Return
			
		LDA	$73
		ORA	$74
		ORA	$187A|!base2
		ORA	$140D|!base2
		ORA	$1470|!base2
		ORA	$13E3|!base2
		BNE	.Return
	
		LDA	#$08
		STA	$14A6|!base2
		LDA	#$04
		STA	$1DFC|!base2
.Return			
		RTS	