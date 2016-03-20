;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Custom collision between Mario<->Layers.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

custom_collision:
	LDA	!collision_flag			;Is the flag set?
	BNE	+
	LDX	#$00
	LDA	$19				;Recover code.
	JML	$00EB7B|!base3
+		
	LDA	!collision_index		;Are we using the built in routine?
	TAX	
	CMP	#$FF				;if not, just get the index.
	BNE	.return
	INX	
	LDA	$73				;if crouching...
	BEQ	+
	TXA	
	CLC	
	ADC	#$18				;add $18 to the index.
	TAX	
+		
	JML	$00EB83|!base3			;Return to the original routine.
.return		
	JML	$00EBAF|!base3

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Custom collision between Mario<->Layers while wallrunning.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		
custom_wallrun:
	LDA	!collision_flag			;Is the flag set?
	BNE	.custom
.original_code	
	LDX	#$60
	TYA					;Recover original code
	BEQ	.return
	LDX	#$66
.return		
	JML	$00EB29|!base3
.custom		
	LDA	!collision_index		;Get new index.
	TAX	
	CMP	#$FF				;Check if we are using the built in routine
	BNE	.return
	BRA	.original_code

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Get collision data for the X coordinates
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		
x_coords:	
	PHA	
	LDA	!collision_flag			;Are we using a custom collision?
	AND	#$00FF
	BNE	.handle_custom
	PLA					;Recover original code.
	CLC	
	ADC.w	$E830,x
	RTL	
.handle_custom	
	CMP	#$00FF
	BEQ	.handle_indirect		;Are we using indirect loading?
	PLA	
	CLC	
	ADC.l	!collision_data_x-2,x	;Handle RAM tables.
	RTL	
.handle_indirect
	STY	$03
	LDA	!collision_loc_x
	STA	$00
	LDA	!collision_loc_x+1
	STA	$01
	TXY	
	PLA	
	CLC	
	ADC	[$00],y
	LDY	$03
	RTL	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Get collision data for the Y coordinates
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		
y_coords:
	PHA		
	LDA	!collision_flag			;Are we using a custom collision?
	AND	#$00FF
	BNE	.handle_custom
	PLA	
	CLC	
	ADC.w	$E89C,x
	RTL	
.handle_custom	
	CMP	#$00FF
	BEQ	.handle_indirect		;Are we using indirect loading?
	PLA	
	CLC	
	ADC.l	!collision_data_y-2,x	;Handle RAM tables.
	RTL	
.handle_indirect
	STY	$03
	LDA	!collision_loc_y
	STA	$00
	LDA	!collision_loc_y+1
	STA	$01
	TXY	
	PLA	
	CLC	
	ADC	[$00],y
	LDY	$03
	RTL	

clip_width:	
	LDA	!clipping_flag
	BEQ	+
	LDA	!clipping_width
	BRA	++
+		
	LDA	#$0C
++		
	STA	$02
	RTL	
clip_height:	
	LDA	!clipping_flag
	BEQ	+
	LDA.l	!clipping_height
	RTL	
+		
	LDA.l	$03B660|!base3,x
	RTL	
	

clip_disp_x:	
	PHA	
	LDA	!clipping_flag
	BEQ	+
	PLA	
	CLC	
	ADC.l	!clipping_disp_x
	BRA	++
+		
	PLA	
	CLC	
	ADC	#$02
++		
	STA	$00
	RTL	
clip_disp_y:
	PHA	
	LDA	!clipping_flag
	BEQ	+
	PLA	
	CLC	
	ADC.l	!clipping_disp_y
	RTL	
+		
	PLA	
	CLC	
	ADC.l	$03B65C|!base3,x
	RTL	 