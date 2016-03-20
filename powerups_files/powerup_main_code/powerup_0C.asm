	LDA	#$01
	STA	!clipping_flag
	LDA	#$08
	STA	!clipping_width
	LDA	#$09
	LDX	$187A|!base2
	BEQ	+
	LDA	#$19
+		
	STA	!clipping_height
	LDA	#$04
	STA	!clipping_disp_x
	LDA	#$17
	STA	!clipping_disp_y

	LDA	$73
	BEQ	.no_crouching
	LDA	#$80
	TRB	$15
	TRB	$16
	TRB	$17
	TRB	$18
	BRA	+
.no_crouching	
	LDA	#$00
+		
	STA	!mask_15
	STA	!mask_17
	LDA	$1470|!base2
	ORA	$148F|!base2
	BEQ	+
	LDA	$77
	AND	#$04
	BEQ	.no_jump
	STZ	$7D
	BRA	.no_jump
+		
	BRA	.no_jump
	LDA	$74
	BNE	+
	LDA	$77
	AND	#$04
	BEQ	.no_jump
+		
	LDA	$16
	BPL	.no_jump
	LDA	#$B8
	STA	$7D
.no_jump	
	LDA	$75
	ORA	$1406
	BNE	+
	LDA	$7D
	BEQ	+
	DEC	$7D
+		
	RTS	

	if read1($00F5F8) == $6B
pushpc
org $00F5FE|!base3
	JML reset_flags
pullpc

reset_flags:
	STA	$71
	LDA	$19
	CMP	#$0C
	BNE	+
	LDA	#$00
	STA	!clipping_flag
	STA	!collision_flag
	JML	$00F606
+	
	STZ	$19
	JML	$00F602
	endif

pushpc
org $00FDC5
	JSL	fix_water_splash
pullpc

fix_water_splash:
	PHY	
	LDY	$19
	CPY	#$0C
	BNE	+
	LDX	#$00
+		
	CLC	
	ADC.l	$00FD9D,x
	PLY	
	RTL	