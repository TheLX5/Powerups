;incsrc !directory
incsrc ../../../powerup_defs.asm

print "MAIN ", pc
mario_boomerang:
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
	plb
	rtl
done:	
	lda !extended_index,x
	bmi +
	tax
	stz !14C8,x
	ldx $15E9|!Base2
+	
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

;	lda !extended_table,x
;	and #$20
;	beq .skip_sync
;.sync_item
;	lda !extended_index,x
;	bmi .skip_sync
;	tay
;	lda !extended_x_low,x
;	sta.w !E4,y
;	lda !extended_x_high,x
;	sta !14E0,y
;	lda !extended_y_low,x
;	sta.w !D8,y
;	lda !extended_y_high,x
;	sta !14D4,y
;	lda !1686,y
;	ora #$80
;	sta !1686,y
;	stz !AA,x
;	stz !B6,x
;.skip_sync

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
;	lda !extended_table,x
;	and #$DF
;	sta !extended_table,x
;	lda !extended_flags,x
;	tay
;	lda !extended_index,x
;	bmi +
;	phx
;	tax
;	tya
;	sta !1686,x
;	lda #$00
;	sta !sprite_ram,x


	txa 
	sec 
	sbc #$07
	eor #$03
	sta $00
	lda !projectile_do_dma
	and $00
	sta !projectile_do_dma
+	
	rts

.skip_to_sprites
.rerun
	lda.b #boomerang_pointers
	sta $8A
	lda.b #boomerang_pointers/$100
	sta $8B
	lda.b #boomerang_pointers/$10000
	sta $8C
	%ExtendedHitSprites()
	bcs contact
	rts
contact:
	tyx
;	lda $0F
;	bmi .items
;	jmp .normal_hit
;.end
;	sty $15E9|!Base2
;	rts
;.items
;	lda !extended_table,x
;	and #$20
;	bne .end
;	lda !extended_timer,x
;	bne .end
;	ldx $0E
;	lda !sprite_ram,x
;	bne .end
;.get_item
;	lda !ext_sprite_x_lo,y
;	sta !E4,x
;	lda !ext_sprite_x_hi,y
;	sta !14E0,x
;	lda !ext_sprite_y_lo,y
;	sta !D8,x
;	lda !ext_sprite_y_hi,y
;	sta !14D4,x
;	stz !AA,x
;	stz !B6,x
;	lda #$01
;	sta !sprite_ram,x
;	lda !1686,x
;	sta $00
;	ora #$80
;	sta !1686,x
;	txa
;	tyx
;	sta !extended_index,x
;	lda $00
;	sta !extended_flags,x
;	lda !extended_table,x
;	ora #$20
;	sta !extended_table,x
;	stx $15E9|!Base2
;	rts

.normal_hit
	lda !extended_table,x
	ora #$80
	sta !extended_table,x
.going_down
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
if !SA1 == 1
	rep #$20
	txa
	and #$00FF
	clc
	adc.w #!sprite_num
	sta $B4
	adc #$0016
	sta $CC
	adc #$0016
	sta $EE
	sep #$20
	lda ($B4)
	sta $87
endif
	lda #$06
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
;	tya
;	cmp !extended_prev,x
;	beq no_upload
;	sta !extended_prev,x
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

incsrc mario_boomerang_props.asm