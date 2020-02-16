
incsrc ../../powerup_defs.asm

!wave_max		=	$28

!Angle			=	$175B|!Base2
!Dir			=	$1765|!Base2

print "MAIN ",pc
	phb
	phk
	plb
	
	lda $9D
	beq main
	jmp graphics
	
afterimage:
.x
db $04,$04,$04,$04
.y 
db $04,$04,$04,$04
.p
db $02,$42,$C2,$82
	
main:	
.no_afterimage
	lda	$176F|!Base2,x
	bne +
	lda	!extended_dir,x
	inc
	sta	!extended_dir,x
	lda	#$3C
	sta	$176F|!Base2,x
+	lda	!extended_dir,x
	cmp	#$05
	bcs	kill_sprite
	
	lda !extended_flags,x
	cmp #$03
	bcc actual_main
kill_sprite:
	lda #$01
	sta $1DF9|!Base2
	lda $171F|!Base2,x
	cmp $1A
	lda $1733|!Base2,x
	sbc $1B
	beq .continue
-	lda #$00
	bra .store_num
.continue
	lda $1715|!Base2,x
	cmp $1C
	lda $1729|!Base2,x
	sbc $1D
	bne -
	lda #$0F
	sta $176F|!Base2,x
	lda #$01
.store_num
	sta !extended_num,x
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
	
actual_main:
	jsr sprite_interaction	
	lda	!extended_flags,x
	tax
	jmp	(State,x)
	
State:
dw checks
dw pikapika
	
;<  Status #$01: Falling  >;
	
checks:
	ldx	$15E9|!Base2
	jsr	block_contact
	bcc	nope
+	
	lda #$02
	sta !extended_flags,x
	jmp	made_contact
	
nope:
	lda !extended_y_speed,x
	cmp #$20
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
	jmp	pre_gfx
	
;<  Status #$02: Bouncing  >;
	
pikapika:
	ldx	$15E9|!Base2
	
	jsr	block_contact
	bcs	+
	jmp skip_objs
+	
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

made_contact:
	lda	#$03
	
loop:
	pha
	lda	!extended_x_speed,x
	and	#$80
	asl
	ora	!Dir,x
	rol
	and #$07
	tay
	lda	angle,y
	sta	!Angle,x
	
	lda	!extended_x_low,x :	pha
	lda	!extended_x_high,x :	pha
	lda	!extended_y_low,x :	pha
	lda	!extended_y_high,x :	pha
	
	jsr	circle_update_pos
	
	jsr	block_contact
	bcc	+
	
	lda !Dir,x
	inc
	and #$03
	sta !Dir,x
	
	pla :	sta	!extended_y_high,x
	pla :	sta	!extended_y_low,x
	pla :	sta	!extended_x_high,x
	pla :	sta	!extended_x_low,x
	
	pla
	dec
	bpl	.loop
	jmp	kill_sprite
.loop
	jmp	loop
	
+	pla :	pla :	pla :	pla :	pla
	bra	pre_gfx
	
skip_objs:
	jsr	circle_update_pos
	
; /          \ ;
;|  Graphics  |;
; \          / ;
	
pre_gfx:
	lda !extended_gfx,x
	inc
	sta !extended_gfx,x

if !enable_projectile_dma == 1
	and #$0F
	lsr
	tay
	lda.w elecball_projectile,y
	jsr do_dma
endif	

graphics:
	%ExtendedGetDrawInfoSpecial()
	bcc done
	lda !extended_behind,x
	sta $04
	phx
if !enable_projectile_dma == 1
	lda.w power_dynamic_tiles-8,x
else	
	ldx $00
	lda.w elecball_tiles,x
endif	
	sta $0202|!Base2,y
	lda $01
	sta $0200|!Base2,y
	lda $02
	sta $0201|!Base2,y
	lda	#$04
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
if !elecball_run_sprites == 1
	lda $13
	lsr
	bcs .run
	rts
.run	
endif	
{
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
	lda.b #elecball_pointers
	sta $8A
	lda.b #elecball_pointers/$100
	sta $8B
	lda.b #elecball_pointers/$10000
	sta $8C
	%ExtendedHitSprites()
	bcs contact
	jmp	contact_return
contact:
	tyx
	
	lda	$176F|!Base2,x
	sec :	sbc	#$1E
	bpl	+
	pha
	lda	!extended_dir,x
	inc
	sta	!extended_dir,x
	pla
	clc :	adc	#$3C
+	sta	$176F|!Base2,x

	ldx $15E9|!Base2
	lda	!sprite_shock,x
	bne	+
	lda	$14						;\
	sta	!sprite_shock_14,x		;/	Store frame counter's value.
+	lda	$0F						;\
	sta	!sprite_shock_flags,x	;/	Store flags to sprite table.
	and	#$20					;\
	beq	+						;/	Branch if it can be pierced.
	phx							;\
	tyx							; |
	lda	#$05					; |	If not, then set elecball's timer to maximum.
	sta	!extended_dir,x			; |
	plx							;/
+
	lda	$0F					;\
	and	#$0F				; |
	cmp	#$0F				; |	If set to make sprite disappear, branch.
	beq	.make_puff			;/
	
	lda	#$3C*3
	bit	$0F
	bvc	+
	bmi	+
	inc	!1FD6,x
	lda	#$00
+	sta	!sprite_shock,x	
	bra	.sfx
	
.make_puff
	lda	#$04
	sta	!14C8,x
	lda	#$1F
	sta	!1540,x
	lda	#$3C*2
	sta	!sprite_shock,x

.sfx
	lda	!14C8,x
	cmp	#$0A
	bne	+
	lda	#$09
	sta	!14C8,x
	stz	!B6,x
	stz	!1626,x
+
	lda	!sprite_shock,x	;\
	beq	+					;/	If sprite wasn't paralyzed, skip playing SFX.
	lda	#$03				;\
	sta	$1DF9|!base2		;/	Play "kicked" sound effect.
+	
.go_back
.return
	sty $15E9|!Base2
	tyx
	rts

.kill_speed
	db $18,$E8
}
;there should be a better way to do this lol

if !enable_projectile_dma == 1
do_dma: 
	rep #$20
	xba
	and #$FF00
	lsr
	clc 
	adc.w #elecball_projectile_gfx
	pha 
	txa 
	asl 
	tax 
	pla 
	sta !projectile_gfx_index-16,x
	clc 
	adc #$0040
	sta !projectile_gfx_index-12,x
	sep #$20
	ldx $15E9|!Base2
	lda #elecball_projectile_gfx>>16
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

elecball_projectile:
		db $00,$01,$02,$00,$03,$00,$04,$05
.gfx
		incbin elecball_gfx.bin
else
elecball_tiles:
		db !elecball_pro_tile_1
		db !elecball_pro_tile_2
		db !elecball_pro_tile_3
		db !elecball_pro_tile_4
endif

elecball_pointers:
	dw elecball_normal_sprites
	dw elecball_custom_sprites

incsrc mario_elecball_props.asm

block_contact:
	lda	!extended_x_low,x :	pha
	sec :	sbc #$02
	sta	!extended_x_low,x
	lda	!extended_x_high,x :	pha
	sbc	#$00
	sta	!extended_x_high,x
	%ExtendedBlockInteraction()
	pla :	sta	!extended_x_high,x
	pla :	sta	!extended_x_low,x
	rts
	
circle_update_pos:
	lda	!extended_x_speed,x
	rol #2
	and #$01
	tay
	lda	!Angle,x
	clc :	adc	angle_move,y
	sta	!Angle,x
	rep	#$20
	asl
	and	#$01FF
	sta	$04
	sep #$20
	lda #$04
	sta $06
	%CircleX() :	%CircleY()
	
	lda	!extended_x_low,x
	clc :	adc	$07
	sta	!extended_x_low,x
	lda	!extended_x_high,x
	adc	$08
	sta	!extended_x_high,x
	lda	!extended_y_low,x
	clc :	adc	$09
	sta	!extended_y_low,x
	lda	!extended_y_high,x
	adc	$0A
	sta	!extended_y_high,x
	
	rts
	
angle:
db $C0+$C0,$C0-$C0
db $C0+$00,$C0-$00
db $C0+$40,$C0-$40
db $C0+$80,$C0-$80

.move
db $08,-$08