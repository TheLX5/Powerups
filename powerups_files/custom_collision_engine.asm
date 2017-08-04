;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Custom collision between Mario<->Layers.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

custom_collision:
	lda !collision_flag			;Is the flag set?
	bne +
	ldx #$00
	lda $19				;Recover code.
	jml $00EB7B|!base3
+	
	lda !collision_index		;Are we using the built in routine?
	tax 
	cmp #$FF				;if not, just get the index.
	bne .return
	inx
	lda $73				;if crouching...
	beq +
	txa 
	clc
	adc #$18				;add $18 to the index.
	tax	
+		
	jml $00EB83|!base3			;Return to the original routine.
.return	
	jml $00EBAF|!base3

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Custom collision between Mario<->Layers while wallrunning.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		
custom_wallrun:
	lda !collision_flag			;Is the flag set?
	bne .custom
.original_code	
	ldx #$60
	tya					;Recover original code
	beq .return
	ldx #$66
.return	
	jml $00EB29|!base3
.custom	
	lda !collision_index		;Get new index.
	tax 
	cmp #$FF				;Check if we are using the built in routine
	bne .return
	bra .original_code

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Get collision data for the X coordinates
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		
x_coords:	
	pha
	lda !collision_flag			;Are we using a custom collision?
	and #$00FF
	bne .handle_custom
	pla 				;Recover original code.
	clc
	adc.w $E830,x
	rtl
.handle_custom	
	cmp #$00FF
	beq .handle_indirect		;Are we using indirect loading?
	pla 
	clc
	adc.l !collision_data_x-2,x	;Handle RAM tables.
	rtl 
.handle_indirect
	sty $03
	lda !collision_loc_x
	sta $00
	lda !collision_loc_x+1
	sta $01
	txy 
	pla
	clc 
	adc [$00],y
	ldy $03
	rtl

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Get collision data for the Y coordinates
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		
y_coords:
	pha	
	lda !collision_flag			;Are we using a custom collision?
	and #$00FF
	bne .handle_custom
	pla 
	clc	
	adc.w $E89C,x
	rtl
.handle_custom	
	cmp #$00FF
	beq .handle_indirect		;Are we using indirect loading?
	pla
	clc
	adc.l !collision_data_y-2,x	;Handle RAM tables.
	rtl
.handle_indirect
	sty $03
	lda !collision_loc_y
	sta $00
	lda !collision_loc_y+1
	sta $01
	txy
	pla 
	clc 
	adc [$00],y
	ldy $03
	rtl

clip_width:	
	lda !clipping_flag
	beq +
	lda !clipping_width
	bra ++
+		
	lda #$0C
++	
	sta $02
	rtl 	
clip_height:
	lda !clipping_flag
	beq +
	lda.l !clipping_height
	rtl 
+	
	lda.l $03B660|!base3,x
	rtl 
	

clip_disp_x:	
	pha 	
	lda !clipping_flag
	beq +
	pla 
	clc
	adc.l !clipping_disp_x
	bra ++
+	
	pla
	clc
	adc #$02
++	
	sta $00
	rtl
clip_disp_y:
	pha	
	lda !clipping_flag
	beq +
	pla	
	clc	
	adc.l !clipping_disp_y
	rtl 
+	
	pla
	clc
	adc.l $03B65C|!base3,x
	rtl  