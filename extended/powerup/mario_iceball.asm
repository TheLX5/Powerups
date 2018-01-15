incsrc !directory

print "MAIN ",pc
	phb
	phk
	plb
	lda $9D
	beq main
	jmp graphics
main:	
	lda !extended_dir,x
	beq kill_sprite
	lda !extended_table,x
	bpl actual_main
kill_sprite:
	phx
	ldx #$09
.loop	
	lda !extended_num,x
	beq .found_slot
	dex
	cpx #$07
	bpl .loop
	lda #$00
	sta !projectile_do_dma
.found_slot
	plx
	lda #$0F
	sta $176F|!Base2,x
	lda #$01
	sta !extended_num,x
	plb 
	rtl 
	
actual_main:
	jsr sprite_interaction
	%ExtendedBlockInteraction()
	bcc no_obj_contact
checks:
	lda !extended_dir,x
	dec
	sta !extended_dir,x
	lda !extended_flags,x
	inc 
	sta !extended_flags,x
	cmp #$02
	bcs .hit_two_objects
	lda !extended_x_speed,x
	bpl .plus
	lda $0B
	eor #$FF
	inc
	sta $0B
.plus
	lda $0B
	clc
	adc #$04
	tay
	lda.w .data_029F99,y
	sta !extended_y_speed,x
	lda !extended_y_low,x
	sec
	sbc.w .data_029FA2,y
	sta !extended_y_low,x
	bcs update_pos
	dec !extended_y_high,x
	bra update_pos

.data_029F99
	db $00,$B8,$C0,$C8,$D0,$D8,$E0,$E8,$F0
.data_029FA2
	db $00,$05,$03,$02,$02,$02,$02,$02,$02

.hit_two_objects
	lda #$01
	sta $1DF9|!Base2
	jmp kill_sprite
no_obj_contact:
update_pos:
	lda !extended_y_speed,x
	cmp #$30
	bpl .enough_y
	clc
	adc #$04
	sta !extended_y_speed,x
.enough_y
	lda #$00
	sta !extended_flags,x
	tay
	lda !extended_x_speed,x
	bpl .plus_2
	dey
.plus_2 
	clc
	adc !extended_x_low,x
	sta !extended_x_low,x
	tya
	adc !extended_x_high,x
	sta !extended_x_high,x
	%SpeedY()

	lda !extended_gfx,x
	inc
	sta !extended_gfx,x

if !enable_projectile_dma == 1
	lda !extended_gfx,x
	lsr #2
	and #$03
	tay
	lda.w iceball_projectile,y
	jsr do_dma
endif	

graphics:
	%ExtendedGetDrawInfoSpecial()
	bcc done
	lda !extended_behind,x
	sta $04
	lda !extended_gfx,x
	lsr #2
	and #$03
	sta $00
	phx
if !enable_projectile_dma == 1
	lda.w power_dynamic_tiles-8,x
else	
	ldx $00
	lda.w iceball_tiles,x
endif	
	sta $0202|!Base2,y
	lda $01
	sta $0200|!Base2,y
	lda $02
	sta $0201|!Base2,y
	ldx $00
	lda.w iceball_props,x
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
if !iceball_run_sprites == 1
	lda $13	
	lsr
	bcs .run
	rts
.run	
endif	
	lda !extended_table,x
	bpl .run_code
	rts
.run_code
	lda !extended_x_low,x
	clc
	adc #$03
	sta $04
	lda !extended_x_high,x
	adc #$00
	sta $0A
	lda !extended_y_low,x
	clc
	adc #$03
	sta $05
	lda !extended_y_high,x
	adc #$00
	sta $0B
	lda #$0A
	sta $06
	sta $07
	lda.b #iceball_pointers
	sta $8A
	lda.b #iceball_pointers/$100
	sta $8B
	lda.b #iceball_pointers/$10000
	sta $8C
	%ExtendedHitSprites()
	bcs contact
	rts
contact:
	tyx
	lda !extended_table,x
	ora #$80
	sta !extended_table,x
	ldx $15E9|!Base2
	lda $0F
	and #$02
	beq .instant_froze
.puff	
	sty $15E9|!Base2
	tyx
	pla
	pla
	jmp kill_sprite

.instant_froze
	lda #$01
	sta $1DFC|!Base2
	lda !1588,x
	sta $00
	lda !164A,x
	sta $01
	lda #$53
	sta !9E,x
	jsl $07F7D2|!BankB
	lda #$09
	sta !14C8,x
	lda #$FF
	sta !1540,x
	lda $00
	sta !1588,x
	and #$04
	beq .no_floor
	lda #$01
	sta !C2,x
	bra .next
.no_floor
	lda $01
	bne .next
	lda #$80
	sta !154C,x
.next	
	lda #$22
	sta !1686,x
	lda #$A9
	sta !167A,x
	jmp .puff
.return	
	sty $15E9|!Base2
	rts

;there should be a better way to do this lol

if !enable_projectile_dma == 1
do_dma: 
	rep #$20
	xba
	and #$FF00
	lsr #3
	clc 
	adc.w #iceball_projectile_gfx
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
	lda #iceball_projectile_gfx>>16
	sta !projectile_gfx_bank-8,x
	lda #$01
	sta !projectile_do_dma
	rts 

iceball_projectile:
		db $00,$02,$04,$06
.gfx
		incbin iceball_gfx.bin
else
iceball_tiles:
		db !iceball_pro_tile_1
		db !iceball_pro_tile_2
		db !iceball_pro_tile_3
		db !iceball_pro_tile_4
endif
iceball_props:	
		db !iceball_prop,!iceball_prop,!iceball_prop+$C0,!iceball_prop+$C0

iceball_pointers:
	dw iceball_normal_sprites
	dw iceball_custom_sprites
	dw iceball_level_sprites

incsrc mario_iceball_props.asm