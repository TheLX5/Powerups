	lda $73
	ora $74
	ora $187A|!base2
	ora $1470|!base2
	bne .Return

	bit $16
	bvs .ShootElecball
	lda $140D|!base2
	beq .Return
	inc $13E2|!base2
	lda $13E2|!base2
	and #$0F
	bne .Return
	tay
	lda $13E2|!base2
	and #$10
	beq +
	iny
+	
	sty $76
.ShootElecball
	ldx #$09
.find_slot
	lda !ext_sprite_num,x
	beq .found_slot
	dex
	cpx #$07
	bne .find_slot
.Return	
	rts

.found_slot
if !enable_projectile_dma == 1
	txa
	sec
	sbc #$07
	and #$03
	sta !projectile_do_dma
endif	
	lda #!elec_flower_shoot_sfx
	sta !elec_flower_shoot_port|!base2
	lda #!elec_flower_pose_timer
	sta $149C|!base2
	lda #!elecball_ext_num
	sta !ext_sprite_num,x
	lda $13F9|!base2
	sta !ext_sprite_layer,x
	stz !ext_sprite_table,x
	lda	#$00
	sta	!ext_sprite_flags,x
	sta !ext_sprite_dir,x

	lda $7B
	bpl +
	eor #$FF
	inc
+	cmp #$30
	bcc +
	lda #$2F
+	lsr #3
	asl
	adc $76
	tay
	lda.w .x_speed,y
	sta !ext_sprite_x_speed,x

	lda #!elecball_y_speed
	sta !ext_sprite_y_speed,x

if !elecball_shoot_up == 1
	lda $15
	and #$08
	beq +
	lda #-!elecball_y_speed-$14
	sta !ext_sprite_y_speed,x
	stz $1765|!base2,x
+	
endif
;	ldy $76
	lda $94
;	clc
;	adc #$04
	sta !ext_sprite_x_lo,x
	lda $95
;	adc #$00
	sta !ext_sprite_x_hi,x
	lda $96
	clc
	adc #$02
	sta !ext_sprite_y_lo,x
	lda $97
	adc #$00
	sta !ext_sprite_y_hi,x
	rts

.x_speed
	db -(!elecball_base_x_speed+0),!elecball_base_x_speed+0
	db -(!elecball_base_x_speed+0),!elecball_base_x_speed+0
	db -(!elecball_base_x_speed+1),!elecball_base_x_speed+1
	db -(!elecball_base_x_speed+1),!elecball_base_x_speed+1
	db -(!elecball_base_x_speed+1),!elecball_base_x_speed+1
	db -(!elecball_base_x_speed+1),!elecball_base_x_speed+1
	db -(!elecball_base_x_speed+2),!elecball_base_x_speed+2
	db -(!elecball_base_x_speed+2),!elecball_base_x_speed+2