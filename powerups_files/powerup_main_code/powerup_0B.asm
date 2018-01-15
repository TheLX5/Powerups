	lda #$01
	sta !clipping_flag
	sta !insta_kill_flag
	sta !collision_flag
	lda #$08
	sta !clipping_width
	lda #$07
	ldx $187A|!base2
	beq +
	lda #$17
+	
	sta !clipping_height
	lda #$08
	sta !clipping_disp_x
	lda #$19
	sta !clipping_disp_y

	lda $73
	beq .no_crouch
	lda #$80
	trb $15
	trb $16
	trb $17
	trb $18
	bra +
.no_crouch
	lda #$00
+	
	sta !mask_15
	sta !mask_17
	
	lda $1470|!base2
	ora $148F|!base2
	beq .no_jump
	lda #$08
	trb $15
	trb $16
	trb $17
	trb $18
	ora !mask_15
	sta !mask_15
	lda $77
	and #$04
	beq .end
	stz $7D
	bra .end
.no_jump
	lda !mask_15
	and #%11110111
	sta !mask_15
.end	
	lda $75
	ora $1406|!base2
	bne +
	lda $7D
	beq +
	dec $7D
+	
	rts
	