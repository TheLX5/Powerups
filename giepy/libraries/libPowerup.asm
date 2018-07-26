;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Powerup library.
;; Created by LX5
;;
;; ----------------------------------------------------------------------
;; 
;; ExtendedGetDrawInfoSpecial
;; 	Prepares some information to draw an extended sprite on screen.
;;	This one has a natural despawn for offscreen sprites at the cost
;;	of some extra cycles.
;;	It also clears projectiles DMA if they're offscreen.
;;
;; Input:
;;	X = Extended sprite index
;;  
;; Output:
;; 	Y = OAM index
;;	Carry set: Sprite is alive.
;;	Carry clear: Sprite was erased.
;;	$01 = X position of the sprite on screen.
;;	$02 = Y position of the sprite on screen.
;;	$03 = X position, high bit.
;;	$04 = Extended sprite behind layers information ($7E1779).
;;	
;; ----------------------------------------------------------------------
;;
;; ExtendedHitSprites
;; 	Checks contact between the extended sprite projectile and a enemy.
;;	Shouldn't be used in normal extended sprites, as in it's made
;;	especifically for the powerups patch.
;;
;; Input:
;;	X = Extended sprite index.
;;
;; Output:
;;	Carry set = Collision was found.
;;	Carry clear = Collision wasn't found.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

incsrc ../powerup_defs.asm

ExtendedGetDrawInfoSpecial:
	lda !extended_num,x
	beq .erased_spr
	lda.l .oam_slots-8,x
	tay
	stz $03
	lda !extended_x_high,x
	xba 
	lda !extended_x_low,x
	rep #$20
	sec
	sbc $1A
	clc
	adc #$0040
	cmp #$0180
	sep #$20
	bcs .erase_spr
	lda !extended_y_low,x
	clc
	adc #$10
	php
	cmp $1C
	rol $00
	plp
	lda !extended_y_high,x
	adc #$00
	lsr $00
	sbc $1D
	bne .erase_spr
	lda !extended_x_low,x
	sec
	sbc $1A
	sta $01
	lda !extended_x_high,x
	sbc $1B
	beq .no_high_bit
	lda #$01
	sta $03
.no_high_bit
	lda !extended_y_low,x
	sec
	sbc $1C
	sta $02
	lda !extended_behind,x
	sta $04
	sec
	rtl

.erase_spr
	stz !extended_num,x
.erased_spr
	lda #$01
	sta $03
	txa 
	sec 
	sbc #$07
	eor #$03
	sta $00
	lda !projectile_do_dma
	and $00
	sta !projectile_do_dma
	clc
	rtl

.oam_slots
	db $F8,$FC

;--------------------------------------------

ExtendedHitSprites:
	txy
	sty $185E|!Base2
	ldx.b #!SprSize-1
.loop	
	stx $15E9|!Base2
	lda !14C8,x
	cmp #$08
	bcc .ignore
;	lda !167A,x
;	and #$02
	lda !15D0,x
	ora !1632,x
	eor !extended_behind,y
	bne .ignore
	jsl $03B6E5|!BankB
	jsl $03B72B|!BankB
	bcs .collision
.ignore
	ldy $185E|!Base2
	dex
	bpl .loop 
	sty $15E9|!Base2
	tyx
	clc
	rtl
.collision
	lda !7FAB10,x
	and #$0C
	bne .is_custom
	ldy.w !9E,x
	bra .continue
.is_custom
	lda !7FAB9E,x
	tay
	phx
	lda !7FAB10,x
	lsr #2
	dec
	tax
	rep #$20
-	
	inc $8A
	inc $8A
	dex 
	bpl -
	sep #$20
	plx
.continue
	rep #$30
	lda ($8A)
	sta $8A
	sep #$20
	lda [$8A],y
	sep #$10
	sta $0F
	and #$10
	bne .ignore
	ldy $185E|!Base2
	sec
	rtl