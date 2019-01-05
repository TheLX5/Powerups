;;;;;;;;;;;;;;;;;;;
;; Penguin Suit (NSMBWii)
;;;;;;;;;;;;;;;;;;;


if !penguin_suit_ride_yoshi == 0
	lda $187A|!base2
	beq +
	ldx $18DF|!base2
	stz !C2-1,x
	stz $0DC1|!base2
	stz $187A|!base2
+	
	lda #$01
	sta !ride_yoshi_flag
endif
	lda $0100|!base2
	cmp #$14
	bne +
	stz $86
+	

	ldy $73
	lda $1493|!base2
	bne .ground
	lda $75
	beq .ground
	lda $187A|!base2
	bne .ground
	lda $148F|!base2
	bne .ground
	jsr .underwater
	ldy #$00
.ground
	phy
	jsr .slide
	ply
.shoot
	tya
	ora $74
	ora $187A|!base2
	ora $1470|!base2
	bne .Return

	bit $16
	bvs .ShootIceball
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
	lda #!penguin_suit_shoot_sfx
	sta !penguin_suit_shoot_port|!base2
	lda #!penguin_suit_pose_timer
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


.underwater
	stz $7B
	stz $7D
	ldy #$00
	lda $15
	bpl .slow_speed
	iny
.slow_speed
	lda $14
	lsr #3
	and #$03
	beq .no_dec
	dec
.no_dec	
	tax
	lda .neutral_frames,x
	sta !power_ram
.right
	lda $15
	and #$01
	beq .not_right
	lda .right_frames,x
	sta !power_ram
	lda $77
	bit #$01
	bne .not_right
	lda .right_speed,y
	sta $7B
.not_right
.left
	lda $15
	and #$02
	beq .not_left
	lda .left_frames,x
	sta !power_ram
	lda $77
	bit #$02
	bne .not_left
	lda .left_speed,y
	sta $7B
.not_left
.down	
	lda $15
	and #$04
	beq .not_down
	lda .down_frames,x
	sta !power_ram
	lda $77
	bit #$04
	bne .not_down
	lda .down_speed,y
	sta $7D
.not_down
.up	
	lda $15
	and #$08
	beq .not_up
	lda .up_frames,x
	sta !power_ram
	lda $77
	bit #$08
	bne .not_up
	lda .up_speed,y
	sta $7D
.not_up	
	lda #$01
	sta $73
	rts

.neutral_frames
	db $2E,$2F,$2E
.right_frames
	db $2C,$2D,$2F
.left_frames
	db $2C,$2D,$2F
.up_frames
	db $46,$47,$48
.down_frames
	db $2A,$2B,$30
.right_speed
	db $10,$28
.left_speed
	db $F0,$DB
.up_speed
	db $F0,$DB
.down_speed
	db $10,$28


.slide
	lda $187A|!base2
	ora $1470|!base2
	bne .reset
	lda !flags
	asl
	tax
	jmp (.ptrs,x)

.ptrs	
	dw .checks
	dw .sliding
	
.sliding
	stz $149B|!base2
	stz $18D2|!base2
	lda #$01
	sta !disable_spin_jump
	sta $73
	lda $75
	beq .no_water
	lda $77
	and #$04
	bne .no_water
	lda #$80
.no_water
	ora #$0F
	sta !mask_15
	
	lda !slippery_flag_backup
	beq +
	sta $86
	ldy $76
	lda.w .speeds,y
	sta $7B
+	
	lda $7B
	beq .reset

	lda $77
	and #$01
	beq +
	lda #$01
	sta $1DF9|!base2
	bra .reset
+	
	lda $77
	and #$02
	beq .not_in_shell
	lda #$01
	sta $1DF9|!base2
	bra .reset
.not_in_shell
	bit $15
	bvs .xy
.reset	
	lda #$00
	sta !disable_spin_jump
	sta !mask_15
	sta !flags
	sta $73
.xy	
	rts

.checks
	lda $13E4|!base2
	cmp #$64
	bcc .no_active
	cmp #$70
	bcs .no_active
	lda $73
	beq .no_active
	lda !slippery_flag_backup
	bne +
	ldy $76
	lda.w .speeds,y
	sta $7B
+	
	lda #$01
	sta !flags
	sta $73
	lda $13E3|!base2
	beq .no_active
	phb
	lda #$00
	pha
	plb
	phk
	pea .no_wall-1
	pea $84CE
	jml $00EB42|!base3
.no_wall
	plb
.no_active
	rts

.speeds
	db (!penguin_suit_base_x_speed-0)^$FF,!penguin_suit_base_x_speed+0