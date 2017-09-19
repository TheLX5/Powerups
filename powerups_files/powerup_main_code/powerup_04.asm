;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Hammer Suit (Super Mario Bros. 3)
;; 
;; Throws Hammer upwards.
;; They go further if Mario is moving.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.hammer_mario
if !hammer_shell_immunity == 1
	lda $74
	ora $187A|!base2
	ora $1470|!base2
	bne .return
	lda $73
	beq .not_ducking
	lda #$01
	sta !shell_immunity
	rts
.not_ducking
	lda #$00
	sta !shell_immunity
else	
	lda $74
	ora $73
	ora $187A|!base2
	ora $1470|!base2
	bne .return
endif	
	bit $16
	bvs .shoot_hammer
	lda $140D|!base2
	beq .return
	inc $13E2|!base2
	lda $13E2|!base2
	and #$0F
	bne .return
	tay
	lda $13E2|!base2
	and #$10
	beq .change_direction
	iny
.change_direction
	sty $76
	
.shoot_hammer
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
	lda #$01
	sta !projectile_do_dma
endif	
	
if !hammer_shoot_sfx != $00
	lda #!hammer_shoot_sfx
	sta $1DFC|!base2
endif	
	lda #!hammer_pose_timer
	sta $149C|!base2
	lda #!hammer_ext_num
	sta !ext_sprite_num,x
	lda #!hammer_y_speed
	sta !ext_sprite_y_speed,x
	stz !ext_sprite_table,x
	stz $00
	lda $76
	clc
	ror #2
	eor $7B
	bpl .moving
	lda $7B
	sta $00
.moving	
	lda #$10
	ldy $76
	bne .flip
	eor #$FF
	inc
.flip	
	clc
	adc $00
	sta !ext_sprite_x_speed,x
	
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
	lda $13F9|!base2
	sta !ext_sprite_layer,x
	lda #$00
	sta !ext_sprite_gfx,x
	rts 

.x_lo_disp
	db $00,$08,$F8,$10,$F8,$10
.x_hi_disp
	db $00,$00,$FF,$00,$FF,$00
.y_lo_disp
	db $08,$08,$0C,$0C,$14,$14