incsrc !directory

print "MAIN ", pc
	phb
	phk
	plb
	lda $9D
	bne graphics
	lda !extended_table,x
	bpl process
	%Speed()
	bra graphics 

process:
	jsr movement
	jsr sprite_interaction

	lda !extended_gfx,x
	inc
	sta !extended_gfx,x

if !enable_projectile_dma == 1
	lda !extended_gfx,x
	lsr #2
	and #$03
	tay
	lda.w boomerang_projectile,y
	jsr do_dma
endif	

if !boomerang_run_blocks == 0
	lda $13
	lsr
	bcc dont_execute_blocks
endif	
	lda !extended_y_low,x
	pha
	lda !extended_y_high,x
	pha
	%ExtendedBlockInteraction()
	pla
	sta !extended_y_high,x
	pla
	sta !extended_y_low,x

dont_execute_blocks:

graphics:
	%ExtendedGetDrawInfoSpecial()
	bcc done
	lda !extended_behind,x
	sta $04
	lda !extended_x_speed,x
	sta $06
	lda !extended_gfx,x
	lsr #2
	and #$03
	sta $00
	phx
if !enable_projectile_dma == 1
	lda.w power_dynamic_tiles-8,x
else	
	ldx $00
	lda.w boomerang_tiles,x
endif	
	sta $0202|!Base2,y
	lda $01
	sta $0200|!Base2,y
	lda $02
	sta $0201|!Base2,y
	ldx $00
	lda #!boomerang_ext_prop
	phy
	txy
	ldx $06
	bpl flip_dir
	iny #4
flip_dir:
	ora prop,y
	ora $64
	ldy $04
	beq behind
	and #$CF
	ora #$10
behind:
	ply
	sta $0203|!Base2,y
	tya
	lsr #2
	tay
	lda #$02
	ora $03
	sta $0420|!Base2,y
	plx
done:
	plb
	rtl

prop:
	db $40,$40,$80,$80
	db $00,$00,$C0,$C0
power_dynamic_tiles:
	db !projectile_dma_tile+2,!projectile_dma_tile

movement:	
	ldy #$01
	lda $14
	and #$02
	beq $01 
	iny 
	sty $00
	ldy !extended_x_speed,x
	lda !extended_dir,x
	bne .left
.right	
	tya
	clc
	adc $00
	bmi .keep_going
	cmp #$50		;max speed
	bcc .keep_going
	lda #$50
	bra .keep_going
.left	
	tya
	sec
	sbc $00
	bpl .keep_going
	cmp #$B0
	bcs .keep_going
	lda #$B0
.keep_going
	sta !extended_x_speed,x
	
	lda !extended_table,x
	and #$01
	bne .go_up
	
	lda !extended_y_speed,x
	inc
	bmi .finish_y_speed
	cmp #$10
	bcc .finish_y_speed
	
	lda !extended_table,x
	ora #$01
	sta !extended_table,x
	
.max_y_down_speed
	lda #$10
.finish_y_speed
	sta !extended_y_speed,x
.update_gravity
	%SpeedNoGrav()
	rts

.go_up
	lda $14
	and #$03
	beq .update_gravity
	lda !extended_y_speed,x
	dec
	bpl .finish_y_speed
	lda #$00
	bra .finish_y_speed


sprite_interaction:
if !boomerang_run_sprites == 0
	lda $13	
	lsr 
	beq .return
endif	
	lda !extended_table,x
	bpl .run_code
.return
	rts
.run_code
	lda !extended_x_low,x
	clc
	adc #$01
	sta $04
	lda !extended_x_high,x
	adc #$00
	sta $0A
	lda !extended_y_low,x
	clc
	adc #$01
	sta $05
	lda !extended_y_high,x
	adc #$00
	sta $0B
	lda #$0E
	sta $06
	sta $07
	lda !extended_timer,x
	bne .skip_to_sprites
	jsl $03B664|!BankB
	jsl $03B72B|!BankB
	bcc .skip_to_sprites
	stz !extended_num,x
	rts
.skip_to_sprites
	lda.b #boomerang_pointers
	sta $8A
	lda.b #boomerang_pointers/$100
	sta $8B
	lda.b #boomerang_pointers/$10000
	sta $8C
	%ExtendedHitSprites()
	bcc contact_return
contact:
	tyx
	lda !extended_table,x
	ora #$80
	sta !extended_table,x
	ldx $15E9|!Base2
	lda $0F
	lsr
	bcs .go_back
	lda !extended_x_speed,y
	and #$80
	clc
	rol #2
	phy
	tay
	lda.w .kill_spd,y
	ply
	sta !sprite_speed_x,x
	lda #$D4
	sta !sprite_speed_y,x
	lda #$02
	sta !sprite_status,x
	lda #$08
	jsl $02ACEF|!BankB
.go_back
	lda #$10
	ldx !extended_x_speed,y
	bmi .left
	lda #$F0
.left	
	sta !extended_x_speed,y
	lda #$03
	sta $1DF9|!Base2
.return
	sty $15E9|!Base2
	rts

.kill_spd
	db $18,$E8

if !enable_projectile_dma == 1

do_dma:
	rep #$20
	xba
	and #$FF00
	lsr #3
	clc 
	adc.w #boomerang_projectile_gfx
	pha 
	txa 
	asl 
	tax 
	pla 
	sta !projectile_gfx_index-16,x
	clc 
	adc #$0200
	sta !projectile_gfx_index-12,x
	sep #$20
	ldx $15E9|!Base2
	lda #boomerang_projectile_gfx>>16
	sta !projectile_gfx_bank-8,x
	tya
	cmp !extended_prev,x
	beq no_upload
	sta !extended_prev,x
	txa 
	sec 
	sbc #$07
	and #$03
	ora !projectile_do_dma
	sta !projectile_do_dma
no_upload:
	rts 

boomerang_projectile:
		db $00,$02,$00,$02
boomerang_projectile_gfx:
		incbin boomerang_gfx.bin
else
boomerang_tiles:
		db !boomerang_pro_tile_1,!boomerang_pro_tile_2
		db !boomerang_pro_tile_1,!boomerang_pro_tile_2
endif

boomerang_pointers:
	dw boomerang_normal_sprites
	dw boomerang_custom_sprites
	dw boomerang_level_sprites

incsrc mario_boomerang_props.asm