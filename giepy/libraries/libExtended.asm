;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Extended sprites library
;; Compiled & created by LX5
;;
;; ----------------------------------------------------------------------
;; ExtendedUpdate
;; 	This is a general routine to update extended sprites positions.
;; 	There are 4 options to call here:
;;	- ExtendedUpdate_XPos
;;	- ExtendedUpdate_YPos
;;	- ExtendedUpdate_NoGravity
;;	- ExtendedUpdate_Gravity
;; 
;; Input:
;;	X = Extended sprite index
;; 
;; Output:
;;	Nothing. 	
;;
;; ----------------------------------------------------------------------
;; 
;; ExtendedGetDrawInfo
;; 	Prepares some information to draw an extended sprite on screen.
;;	It also removes the sprite if it goes offscreen.
;;
;; Input:
;; 	X = Extended sprite index
;;
;; Output:
;; 	Y = OAM index
;;	$01 = X position of the sprite on screen.
;;	$02 = Y position of the sprite on screen.
;;
;; ----------------------------------------------------------------------
;; 
;; ExtendedGetDrawInfo2
;; 	Prepares some information to draw an extended sprite on screen.
;;	This one has a more natural despawn for offscreen sprites at the
;;	cost of some extra cycles.
;;	Also, this routine provides the X position high bit ($7E0420).
;;
;; Input:
;; 	X = Extended sprite index
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
;; ExtendedBlockInteraction
;; 	Interaction routine with blocks for extended sprites.
;;	Note that this routine is quite big, it may generate lag.
;;	This routine also triggers the MarioFireball offset from Custom Blocks.
;;
;; Input:
;;	X = Extended sprite index
;;
;; Output:
;;	$0B = Slope type that the sprite is touching.
;;	$0C = Low byte of the map16 number in Layer 1 that the sprite is touching.
;;	$0D = Low byte of the map16 number in Layer 2/3 that the sprite is touching.
;;	$0E = Sprite has interacted with a interactable/solid block in any Layer flag.
;;	$0F = Sprite has been processed with Layer 2/3
;;	$8B = High byte of the map16 number in Layer 1 that the sprite is touching.
;;	$8C = High byte of the map16 number in Layer 2/3 that the sprite is touching.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!extended_y_fraction = $1751|!addr

ExtendedUpdate:
.Gravity
	lda !extended_y_speed,x
	cmp #$40
	bpl .NoGravity
	clc
	adc #$03
	sta !extended_y_speed,x
.NoGravity
	jsl ExtendedUpdate_YPos
.XPos	
	txa
	clc
	adc #$0A
	tax
.YPos	
	lda !extended_y_speed,x
	asl #4
	clc
	adc !extended_y_fraction,x
	sta !extended_y_fraction,x
	php
	ldy #$00
	lda !extended_y_speed,x
	lsr #4
	cmp #$08
	bcc +
	ora #$F0
	dey
+	
	plp
	adc !extended_y_low,x
	sta !extended_y_low,x
	tya
	adc !extended_y_high,x
	sta !extended_y_high,x
	ldx $15E9|!addr
	rtl
	

ExtendedGetDrawInfo:
	lda.l $028B78|!bankB,x
	tay
	lda $1747|!addr,x
	and #$80
	eor #$80
	lsr
	sta $00
	lda $171F|!addr,x
	sec
	sbc $1A
	sta $01
	lda $1733|!addr,x
	sbc $1B
	bne .erase_spr
	
	lda $1715|!addr,x
	sec
	sbc $1C
	lda $1729|!addr,x
	adc $1D
	beq .neg
	lda $02
	cmp #$F0
	bcs .erase_spr
	rtl
.neg	
	lda $02
	cmp #$C0
	bcc .erase_spr
	cmp #$E0
	bcc .hide_spr
	rtl
.erase_spr
	stz $170B|!addr,x
.hide_spr
	lda #$F0
	sta $02
	rtl

.oam_ptr
	db $90,$94,$98,$9C,$A0,$A4,$A8,$AC

;--------------------------------------------

ExtendedGetDrawInfo2:
	lda.l $028B78|!bankB,x
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
	lda #$01
	sta $03
	clc
	rtl

.oam_slots
	db $90,$94,$98,$9C,$A0,$A4,$A8,$AC

;--------------------------------------------

ExtendedBlockInteraction:
	stz $0F
	stz $0E
	stz $0B
	stz $1694|!Base2
	lda $140F|!Base2	;checking if we're in a special level
	bne .normal_level
	lda $0D9B|!Base2	;boss battles
	bpl .normal_level
	and #$40		;larry/iggy platform
	beq .larry_platform
	lda $0D9B|!Base2
	cmp #$C1		;check bowser battle
	beq .normal_level
.special_level
	lda !extended_y_low,x	;check if Y pos is XXA8
	cmp #$A8
	rtl

.larry_platform
	lda !extended_x_low,x
	clc
	adc #$0A
	sta $14B4|!Base2
	lda !extended_x_high,x
	adc #$00
	sta $14B5|!Base2
	lda !extended_y_low,x
	clc
	adc #$08
	sta $14B6|!Base2
	lda !extended_y_high,x
	adc #$00
	sta $14B7|!Base2
	jsl $01CC9D|!BankB
	ldx $15E9|!Base2
	rtl
	
.normal_level
	pea $00DA
	jsr .run_interaction
	pla
	pla
	rol $0E
	lda $1693|!Base2
	sta $0C
	lda $8A
	sta $8B
	lda $5B
	bpl ..normal_level
	inc $0F
	lda !extended_x_low,x
	pha
	clc
	adc $26
	sta !extended_x_low,x
	lda !extended_x_high,x
	pha
	adc $27
	sta !extended_x_high,x
	lda !extended_y_low,x
	pha
	clc
	adc $28
	sta !extended_y_low,x
	lda !extended_y_high,x
	pha
	adc $29
	sta !extended_y_high,x
	pea $00DA
	jsr .run_interaction
	pla
	pla
	rol $0E
	lda $1693|!Base2
	sta $0D
	lda $8A
	sta $8C
	pla
	sta !extended_y_high,x
	pla
	sta !extended_y_low,x
	pla
	sta !extended_x_high,x
	pla
	sta !extended_x_low,x
..normal_level
	lda $0E			;$0E = has extended sprite touched anything???
	cmp #$01
	rtl

.run_interaction
	lda $0F
	inc
	and $5B
	beq .horizontal_level
	
	lda !extended_y_low,x
	clc
	adc #$08
	sta $98
	and #$F0		;process interaction, Y position
	sta $00
	lda !extended_y_high,x
	adc #$00
	cmp $5D
	bcs .short_return
	sta $03
	sta $99
	
	lda !extended_x_low,x
	clc
	adc #$0A
	sta $9A
	sta $01			;process interaction, X position
	lda !extended_x_high,x
	adc #$00
	cmp #$02
	bcs .short_return
	sta $9B
	sta $02
	
	lda $01
	lsr #4			;merge Y and X high nybbles
	ora $00			;format: YYYYXXXX
	sta $00
	
	ldx $03
	lda.l $00BA80|!BankB,x		;load map16 pointers based on Y pos high byte.
	ldy $0F			;$0F = ???
	beq .not_vert
	lda.l $00BA8E|!BankB,x		;load map16 pointers based on Y pos high byte.
.not_vert
	clc
	adc $00			;merge the pointers with the merged Y and X nybbles
	sta $05		
	lda.l $00BABC|!BankB,x	
	ldy $0F
	beq .not_vert2		;do the same as above
	lda.l $00BACA|!BankB,x
.not_vert2
	adc $02			;but add the pointers to X high position
	sta $06
	bra .continue_short

.short_return
	clc
	rts

.horizontal_level
	lda !extended_y_low,x
	clc
	adc #$08
	sta $98
	and #$F0		;process interaction, Y position
	sta $00
	lda !extended_y_high,x
	adc #$00
	sta $02
	sta $99
	lda $00
	sec
	sbc $1C
	cmp #$F0
	bcs .short_return
	
	lda !extended_x_low,x
	clc
	adc #$0A
	sta $9A
	sta $01			;process interaction, X position
	lda !extended_x_high,x
	adc #$00
	cmp $5D
	bcs .short_return
	sta $9B
	sta $03

	lda $01
	lsr #4			;merge Y and X high nybbles
	ora $00			;format: YYYYXXXX
	sta $00
	
	ldx $03
	lda.l $00BA60|!BankB,x		;load map16 pointers based on Y pos high byte.
	ldy $0F			;$0F = ???
	beq .not_horz
	lda.l $00BA70|!BankB,x		;load map16 pointers based on Y pos high byte.
.not_horz
	clc
	adc $00			;merge the pointers with the merged Y and X nybbles
	sta $05		
	lda.l $00BA9C|!BankB,x	
	ldy $0F
	beq .not_horz2		;do the same as above
	lda.l $00BAAC|!BankB,x
.not_horz2
	adc $02			;but add the pointers to X high position
	sta $06
	
.continue_short
	lda.b #!BankA/$10000
	sta $07
	ldx $15E9|!Base2
	lda [$05]
	sta $1693|!Base2
	inc $07
	lda [$05]
	sta $8A
	jsl $06F7A0|!BankB	;replaced code to get extended sprites to work with MarioFireball offset
	cmp #$00
	beq .passable
	lda $1693|!Base2
	cmp #$11
	bcc .water_tiles	;ledges
	cmp #$6E
	bcc .switch_palace_blocks	;solid block
	cmp #$D8
	;bcs .passable
	bcs .tileset_specific	;corners
	
	ldy $9A			;slopes
	sty $0A
	ldy $98
	sty $0C
	jsl $00FA19|!BankB	;prepare check for slopes
	lda $00
	cmp #$0C		;compare position+pointer
	bcs .decent_pos
	cmp [$05],y		;check if passable on slope
	bcc .passable
.decent_pos
	lda [$05],y		;load slopes collision
	sta $1694|!Base2
	phx
	ldx $08
	lda.l $00E53D|!BankB,x
	plx
	sta $0B			;interact with slopes
.switch_palace_blocks
	sec
	rts
	
.passable
	clc
	rts	

.water_tiles
	lda $98
	and #$0F
	cmp #$06
	bcs .passable
	sec
	rts

.tileset_specific
	lda $98
	and #$0F		;check if this is inside enough of a tile
	cmp #$06
	bcs .passable
	lda !extended_y_low,x
	sec
	sbc #$02		;adjust Y pos and run again the routine
	sta !extended_y_low,x
	lda !extended_y_high,x
	sbc #$00
	sta !extended_y_high,x	;probably it's a check to see if sprite is inside of a block?
	jmp .run_interaction	