;;;;;;;;;;;;;;;;;;;
;; Superball Flower (SML)
;;;;;;;;;;;;;;;;;;;

.main
	lda $74
	ora $73
	ora $187A|!base2
	ora $1470|!base2
	bne .return
	bit $16
	bvs .shoot_superball
	lda $140D|!base2
	beq .return
	inc $13E2|!base2
	lda $13E2|!base2
	and #$0F
	bne .return
	tay
	lda $13E2|!base2
	and #$10
	beq .change_dir
	iny
.change_dir
	sty $76

.shoot_superball
	ldx #$09
.find_slot
	lda !ext_sprite_num,x
	beq .found_slot
	dex
	cpx #$07+!superball_shoot_one
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
	
if !superball_shoot_sfx != $00
	lda #!superball_shoot_sfx
	sta !superball_shoot_port|!base2
endif	
	lda #!superball_pose_timer
	sta $149C|!base2
	lda #!superball_ext_num
	sta !ext_sprite_num,x
	lda #!superball_time
	sta !ext_sprite_timer,x
	lda #!superball_y_speed
	sta !ext_sprite_y_speed,x
	lda #!superball_x_speed
	ldy $76
	bne +
	eor #$FF
	inc
+	
	sta !ext_sprite_x_speed,x
	lda $13F9|!base2
	sta !ext_sprite_layer,x
	lda #$00
	sta !ext_sprite_gfx,x
	stz !ext_sprite_table,x
	
	ldy #$00
	lda $187A|!base2
	beq .no_yoshi
	iny #2
	lda $18DC|!base2
	beq .no_yoshi
	iny #2
.no_yoshi
	lda $94
	clc
	adc.w .x_lo_disp,y
	sta !ext_sprite_x_lo,x
	lda $95
	adc.w .x_hi_disp,y
	sta !ext_sprite_x_hi,x
	lda $96
	clc
	adc.w .y_lo_disp,y
	sta !ext_sprite_y_lo,x
	lda $97
	adc #$00
	sta !ext_sprite_y_hi,x
if !superball_shoot_up == 1
	lda $15
	and #$08
	beq +
	lda !ext_sprite_y_speed,x
	eor #$FF
	inc 
	sta !ext_sprite_y_speed,x
+	
endif
	rts 

.x_lo_disp
	db $00,$08,$F8,$10,$F8,$10
.x_hi_disp
	db $00,$00,$FF,$00,$FF,$00
.y_lo_disp
	db $08,$08,$0C,$0C,$14,$14