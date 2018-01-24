
	LDA $73
	ORA $74
	ORA $187A|!base2
	ORA $1470|!base2
	BNE .Return

	BIT $16
	BVS .ShootIceball
	LDA $140D|!base2
	BEQ .Return
	INC $13E2|!base2
	LDA $13E2|!base2
	AND #$0F
	BNE .Return
	TAY
	LDA $13E2|!base2
	AND #$10
	BEQ +
	INY
+
	STY $76
.ShootIceball
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
	lda #!ice_flower_shoot_sfx
	sta !ice_flower_shoot_port|!base2
	lda #!ice_flower_pose_timer
	sta $149C|!base2
	lda #!iceball_ext_num
	sta !ext_sprite_num,x
	lda $13F9|!base2
	sta !ext_sprite_layer,x
	lda #$02
	sta !ext_sprite_dir,x
	stz !ext_sprite_table,x
	lda $7B
	bpl +
	eor #$FF
	inc
+	
	cmp #$30
	bcc +
	lda #$2F
+	
	lsr #3
	asl
	adc $76
	tay
	lda.w .x_speed,y
	sta !ext_sprite_x_speed,x
	lda #!iceball_y_speed
	sta !ext_sprite_y_speed,x

if !iceball_shoot_up == 1
	lda $15
	and #$08
	beq +
	lda !ext_sprite_y_speed,x
	eor #$FF
	inc 
	sta !ext_sprite_y_speed,x
+	
endif
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
.x_speed
	db (!iceball_base_x_speed+0)^$FF+1,!iceball_base_x_speed+0
	db (!iceball_base_x_speed+1)^$FF+1,!iceball_base_x_speed+1
	db (!iceball_base_x_speed+1)^$FF+1,!iceball_base_x_speed+1
	db (!iceball_base_x_speed+1)^$FF+1,!iceball_base_x_speed+1
	db (!iceball_base_x_speed+2)^$FF+1,!iceball_base_x_speed+2
	db (!iceball_base_x_speed+2)^$FF+1,!iceball_base_x_speed+2
	db (!iceball_base_x_speed+3)^$FF+1,!iceball_base_x_speed+3
	db (!iceball_base_x_speed+3)^$FF+1,!iceball_base_x_speed+3