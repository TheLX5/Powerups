org $00EB77|!base3			;Enables custom collision between Mario<->Layers.
!a	JML	custom_collision
;	LDX	#$00
;	LDA	$19
org $00EB22|!base3			;Enables custom collision in while wallrunning.
!a	JML	custom_wallrun
	NOP	
;	LDX	$19
;	TYA	
;	BEQ	$02
org $00F453|!base3			;Gets X coordinates for collision dots.
!a	JSL	x_coords
;	CLC	
;	ADC.w	$E830,x
org $00F45B|!base3			;Gets Y coordinates for collision dots.
!a	JSL	y_coords
;	CLC	
;	ADC.w	$E89C,x
org $03B688|!base3
!a	JSL	clip_height
	;LDA	$03B660|!base3,x
org $03B691|!base3
!a	JSL	clip_disp_y
	;ADC	$03B65C|!base3,x
org $03B668|!base3
!a	JSL	clip_disp_x
	;ADC	#$02
	;STA	$00
org $03B672|!base3
!a	JSL	clip_width
	;LDA	#$0C
	;STA	$02