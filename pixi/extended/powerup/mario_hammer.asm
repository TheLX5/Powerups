;incsrc !directory
incsrc ../../../powerup_defs.asm

print "MAIN ",pc
	phb
	phk
	plb
	lda $9D
	bne graphics
	%Speed()
	lda !extended_table,x
	bmi graphics
	jsr sprite_interaction
	lda !extended_gfx,x
	ldy !extended_x_speed,x
	bpl going_right
	dec #2
going_right:
	inc
	sta !extended_gfx,x
	
if !enable_projectile_dma == 1
	lda !extended_gfx,x
	lsr #2
	and #$07
	tay
	lda.w hammer_projectile,y
	jsr do_dma
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

graphics:
	%ExtendedGetDrawInfoSpecial()
	bcc done
	lda !extended_behind,x
	sta $04
	lda !extended_gfx,x
	lsr #2
	and #$07
	sta $00
	phx
if !enable_projectile_dma == 1
	lda.w power_dynamic_tiles-8,x
else	
	ldx $00
	lda.w hammer_tiles,x
endif	
	sta $0202|!Base2,y
	lda $01
	sta $0200|!Base2,y
	lda $02
	sta $0201|!Base2,y
if !enable_projectile_dma == 1
	lda #!hammer_pro_props
else
	ldx $00
	lda.w hammer_props,x
endif
	ora $64
	ldx $04
	beq no_behind
	and #$CF
	ora #$10
no_behind:
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


power_dynamic_tiles:
	db !projectile_dma_tile+2,!projectile_dma_tile

sprite_interaction:
if !hammer_run_sprites == 0
	lda $13	
	lsr 
	beq .run_code
endif	
	lda !extended_table,x
	bpl .run_code
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
	lda.b #hammer_pointers
	sta $8A
	lda.b #hammer_pointers/$100
	sta $8B
	lda.b #hammer_pointers/$10000
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
	phy
	lda !extended_x_speed,y
	and #$80
	clc
	rol #2
	tay
	lda.w .kill_speed,y
	ply
	sta !B6,x
	lda #$D4
	sta !AA,x
	lda #$02
	sta !14C8,x

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

.kill_speed
	db $18,$E8


;there should be a better way to do this lol

if !enable_projectile_dma == 1
do_dma: 
	rep #$20
	xba
	and #$FF00
	lsr #3
	clc 
	adc.w #hammer_projectile_gfx
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
	lda #hammer_projectile_gfx>>16
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

hammer_projectile:
		db $00,$02,$04,$06,$08,$0A,$0C,$0E
.gfx
		incbin hammer_gfx.bin
else
hammer_tiles:
		db !hammer_pro_tile_1,!hammer_pro_tile_2
		db !hammer_pro_tile_2,!hammer_pro_tile_1
		db !hammer_pro_tile_1,!hammer_pro_tile_2
		db !hammer_pro_tile_2,!hammer_pro_tile_1
endif
hammer_props:	
		db !hammer_pro_props+$40,!hammer_pro_props+$40
		db !hammer_pro_props,!hammer_pro_props
		db !hammer_pro_props+$80,!hammer_pro_props+$80
		db !hammer_pro_props+$C0,!hammer_pro_props+$C0	

hammer_pointers:
	dw hammer_normal_sprites
	dw hammer_custom_sprites

incsrc mario_hammer_props.asm