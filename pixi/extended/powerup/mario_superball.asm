incsrc !directory

print "MAIN ",pc
	phb
	phk
	plb
	lda $9D
	beq main
	jmp graphics
main:	
	lda !extended_timer,x
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
	bcs checks
skip_objs:
	jmp no_obj_contact
checks:
	ldy $0F
	lda $008B|!Base1,y
	xba
	lda $000C|!Base1,y
	rep #$20
	and #$3FFF
	asl
	tay
	lda $06F624|!BankB
	sta $00
	lda $06F626|!BankB
	sta $02
	lda [$00],y
	cmp #$002B
	sep #$20
	beq skip_objs
	
	lda !extended_flags,x
	inc 
	sta !extended_flags,x
	cmp #$03
	bcs kill_sprite
	lda !extended_x_speed,x
	eor #$FF
	inc
	sta !extended_x_speed,x
	lda !extended_flags,x
	cmp #$02
	bcc .no_flip_y
	lda #$03
	sta $00
	stz $01
	lda !extended_y_speed,x
	bmi .minus
	lda #$FD
	sta $00
	dec $01
.minus
	lda !extended_y_low,x
	clc
	adc $00
	sta !extended_y_low,x
	lda !extended_y_high,x
	adc $01
	sta !extended_y_high,x
	lda !extended_y_speed,x
	eor #$FF
	inc
	sta !extended_y_speed,x
.no_flip_y
	jmp no_reset_hits
no_obj_contact:
	lda #$00
	sta !extended_flags,x
no_reset_hits:
	ldy #$00
	lda !extended_x_speed,x
	bpl .plus
	dey
.plus	
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
	lda.w superball_projectile,y
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
	lda.w superball_tiles,x
endif	
	sta $0202|!Base2,y
	lda $01
	sta $0200|!Base2,y
	lda $02
	sta $0201|!Base2,y
	ldx $00
	lda.w superball_props,x
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
if !superball_run_sprites == 1
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
	lda.b #superball_pointers
	sta $8A
	lda.b #superball_pointers/$100
	sta $8B
	lda.b #superball_pointers/$10000
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

	lda #$03
	sta $1DF9|!Base2
.go_back
.return
	sty $15E9|!Base2
	tyx
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
	adc.w #superball_projectile_gfx
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
	lda #superball_projectile_gfx>>16
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

superball_projectile:
		db $00,$00,$00,$00
.gfx
		incbin superball_gfx.bin
else
superball_tiles:
		db !superball_pro_tile_1
		db !superball_pro_tile_2
		db !superball_pro_tile_3
		db !superball_pro_tile_4
endif
superball_props:	
		db !superball_pro_prop_1
		db !superball_pro_prop_2
		db !superball_pro_prop_3
		db !superball_pro_prop_4

superball_pointers:
	dw superball_normal_sprites
	dw superball_custom_sprites

incsrc mario_superball_props.asm