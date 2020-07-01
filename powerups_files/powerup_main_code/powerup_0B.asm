;;;;;;;;;;;;;;;;;;;
;; Mini Mushroom (NSMBWii)
;;;;;;;;;;;;;;;;;;;

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

if !mini_mushroom_crouch == 1
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
endif
	
if !mini_mushroom_carry == 1
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
endif
	lda $75
	bne +
	lda $7D
	beq +
	cmp #$80
	beq +
	cmp #$81
	beq +
	dec $7D
+	
	rts