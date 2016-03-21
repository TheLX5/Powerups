if !dynamic_z = 0
player_tiles_1:
	PHA	
	PHX	
	SEP	#$20
	LDA	!gfx_bypass_flag
	BEQ	.no_bypass_everything
	REP	#$20
	LDA	!gfx_bypass_num
	BRA	.bypass_everything
.no_bypass_everything
	LDA	#$00
	LDX	$0DB3|!base2
	BEQ	.not_luigi
	LDA	#!max_powerup+$01
.not_luigi	
	CLC	
	ADC	$19
	TAX	
	REP	#$20
	LDA.l	GFXData,x			; moved from player_DMA
.bypass_everything
	REP	#$10
	AND	#$00FF
	STA	$00
	ASL	
	CLC	
	ADC	$00
	TAX	
	LDA.l	PowerupGFX,x
	STA	!gfx_pointer
	SEP	#$20
	LDA.l	PowerupGFX+2,x
	STA	!gfx_pointer+2
	SEP	#$10
	REP	#$20
	PLX	
	PLA	
	LSR	
	ADC	!gfx_pointer
	JML	$00F64C|!base3

player_tiles_2:
	LSR	
	ADC	!gfx_pointer
	JML	$00F66A|!base3
	
player_tiles_3:
	LSR	
	ADC	!gfx_pointer
	JML	$00F67F|!base3
endif