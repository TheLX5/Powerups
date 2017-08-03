check_climb:
	LDA	$19
	CMP	#!tanooki_suit_powerup_num
	BNE	.no_tanooki
	LDA	!flags
	CMP	#$01
	BEQ	.no_statue
.no_tanooki	
	LDA	$148F|!base2
	ORA	$187A|!base2
	BNE	.no_statue
	JML	$00CD56|!base3
.no_statue	
	JML	$00CD79|!base3