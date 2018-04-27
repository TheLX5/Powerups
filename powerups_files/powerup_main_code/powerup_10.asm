	lda $73
	ora $74
	ora $187A|!base2
	ora $1470|!base2
	bne .return

	bit $16
	bvs .shoot_bubble
	lda $140D|!base2
	beq .return
	inc $13E2|!base2
	lda $13E2|!base2
	and #$0F
	bne .return
	tay
	lda $13E2|!base2
	and #$10
	beq +
	iny
+	
	sty $76
.shoot_bubble
	ldx #$09
.find_slot
	lda !ext_sprite_num,x
	beq .found_slot
	dex
	cpx #$07
	bne .find_slot
.return	
	rts

.found_slot
if !enable_projectile_dma == 1
	txa
	sec
	sbc #$07
	and #$03
	sta !projectile_do_dma
endif	
	lda #!bubble_flower_shoot_sfx
	sta !bubble_flower_shoot_port|!base2
	lda #!bubble_flower_pose_timer
	sta $149C|!base2
	lda #!bubble_ext_num
	sta !ext_sprite_num,x
	
	lda $13F9|!base2
	sta !ext_sprite_layer,x
	stz !ext_sprite_table,x
	stz $01
	ldy #$1E
	lda $75
	ora $85
	sta !ext_sprite_flags,x
	beq .no_water
	ldy #$3C
	lda #$22
	sta $01
	bra .duration
.no_water
	lda #$16
	sta $01
.duration
	tya
	sta !ext_sprite_gfx,x
	
	stz $00
	lda $76
	clc
	ror #2
	eor $7B
	bpl +
	lda $7B
	sta $00
+	
	lda $01
	ldy $76
	bne +
	eor #$FF
	inc
+	
	clc
	adc $00
	sta !ext_sprite_x_speed,x
	lda #$0A
	sta !ext_sprite_y_speed,x

	ldy $76
	lda $94
	clc
	adc .x_disp,y
	sta !ext_sprite_x_lo,x
	lda $95
	adc #$00
	sta !ext_sprite_x_hi,x
	lda $96
	clc
	adc #$08
	sta !ext_sprite_y_lo,x
	lda $97
	adc #$00
	sta !ext_sprite_y_hi,x
	rts

.x_disp
	db $00,$08