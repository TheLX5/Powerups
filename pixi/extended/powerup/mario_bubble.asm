;incsrc !directory
incsrc ../../powerup_defs.asm

print "MAIN ",pc
mario_bubble:
	phb
	phk
	plb
	lda $9D
	beq normal_rt
	jmp graphics
normal_rt:
	lda !extended_table,x
	bpl main_rt
kill_bubble:
	ldy #$0B
-	
	lda $17F0|!Base2,y
	beq +
	dey
	bpl -
	bra ++
+	
	lda !extended_y_low,x
	clc
	adc #$00
	and #$F0
	clc
	adc #$03
	sta $17FC|!Base2,y
	lda !extended_x_low,x
	sta $1808|!Base2,y
	lda !extended_x_high,x
	sta $18EA|!Base2,y
	lda #$07
	sta $17F0|!Base2,y
	lda #$12
	sta $1850|!Base2,y
++	
	lda #$19
	sta $1DFC|!Base2
kill_dma:
	stz !extended_num,x
	txa 
	sec 
	sbc #$07
	eor #$03
	sta $00
	lda !projectile_do_dma
	and $00
	sta !projectile_do_dma
	plb
	rtl

main_rt:
	jsr sprite_interaction
	lda !extended_gfx,x
	dec
	beq kill_bubble
	sta !extended_gfx,x
	
	jsr object_interaction
	bcc kill_bubble

	lda $14
	and #$03
	bne .nope_x
	lda !ext_sprite_x_speed,x
	beq .zero
	bmi .minus
	dec
	dec
.minus	
	inc
.zero	
	sta !ext_sprite_x_speed,x
.nope_x
	ldy !ext_sprite_y_speed,x
	lda $14
	and #$03
	beq .no_dey
	dey
.no_dey
	tya
	sta !ext_sprite_y_speed,x
	
	%SpeedNoGrav()
	
if !enable_projectile_dma == 1
	lda !extended_flags,x
	lsr
	lda !extended_gfx,x
	bcc .in_air
	lsr
.in_air
	lsr #3
	and #$03
	tay
	lda.w bubble_projectile,y
	jsr do_dma
endif	
	

graphics:
	%ExtendedGetDrawInfoSpecial()
	bcc done
	lda !extended_behind,x
	sta $04
	lda !extended_flags,x
	lsr
	lda !extended_gfx,x
	bcc .in_air
	lsr
.in_air
	lsr #3
	and #$03
	sta $00
	phx
if !enable_projectile_dma == 1
	lda.w power_dynamic_tiles-8,x
else	
	ldx $00
	lda.w bubble_tiles,x
endif	
	sta $0202|!Base2,y
	lda $01
	sta $0200|!Base2,y
	lda $02
	sta $0201|!Base2,y
	lda #!bubble_pro_props
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

object_interaction:
	%ExtendedBlockInteraction()
	php
	lda !extended_flags,x
	bne .spawn_in_water
.handle_water_level
	plp
	bcc .keep_floating
.force_pop_plus
	clc
	rts
.keep_floating
	sec
	rts
.spawn_in_water
	ldy $85
	bne .handle_water_level
	plp
	bcs .force_pop_plus
	ldy $0F
	lda $008B|!Base1,y
	xba
	lda $000C|!Base1,y
	rep #$20
	and #$7FFF
	asl
	tay
	lda $06F624|!BankB
	sta $00
	lda $06F626|!BankB
	sta $02
	lda [$00],y
	cmp #$0004
	sep #$20
	bcs .force_pop_plus
	sec 
	rts 
	


sprite_interaction:
if !bubble_run_sprites == 0
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
	lda.b #bubble_pointers
	sta $8A
	lda.b #bubble_pointers/$100
	sta $8B
	lda.b #bubble_pointers/$10000
	sta $8C
	%ExtendedHitSprites()
	bcs contact
	sty $15E9|!Base2
	tyx
	rts
contact:
	lda $0F
	and #$04
	beq .no_pop
	sty $15E9|!Base2
	tyx
	pla
	pla
	jmp kill_bubble
.no_pop
	phy
	ldy.b #!SprSize-1
.loop	
	lda !14C8,y
	cmp #$08
	bcs .found
.next	
	dey
	bpl .loop
	bra .continue
.found	
	lda.w !9E,y
	cmp #$9D
	bne .next
	lda !190F,y
	bpl .next
	lda #$02
	sta !14C8,y
.continue
	ply
	lda #$9D
	sta !9E,x
	lda #$00
	sta !7FAB10,x
	jsl $07F7D2|!BankB
	lda #$08
	sta !14C8,x
	lda #$A1
	sta !1534,x
	lda #$40
	sta !154C,x
	lda !190F,x
	ora #$80
	sta !190F,x
	lda !D8,x
	sec
	sbc #$02
	sta !D8,x
	lda !14D4,x
	sbc #$00
	sta !14D4,x
	phx
	lda !ext_sprite_x_speed,y
	bmi +
	lsr 
	bra ++
+	
	eor #$FF
	inc
	lsr 
	eor #$FF
	inc
++	
	sta $00
	lda !ext_sprite_x_speed,y
	asl
	rol
	and #$01
	tax
	lda .bubble_x,x
	plx
	clc
	adc $00
	sta !B6,x
	lda #$1E
	sta $1DF9|!Base2
	tyx
	stx $15E9|!Base2
	stz !extended_num,x
	pla
	pla
	jmp kill_dma
.bubble_x
	db $04,$FC

;there should be a better way to do this lol

if !enable_projectile_dma == 1
do_dma: 
	rep #$20
	xba
	and #$FF00
	lsr #3
	clc 
	adc.w #bubble_projectile_gfx
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
	lda #bubble_projectile_gfx>>16
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


bubble_projectile:
		db $06,$04,$02,$00
bubble_projectile_gfx:
	incbin bubble_gfx.bin
else
bubble_tiles:
		db !bubble_pro_tile_4,!bubble_pro_tile_3
		db !bubble_pro_tile_2,!bubble_pro_tile_1
endif

bubble_pointers:
	dw bubble_normal_sprites
	dw bubble_custom_sprites

incsrc mario_bubble_props.asm