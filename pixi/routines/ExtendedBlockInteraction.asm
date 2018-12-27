; interaction routine with blocks for extended sprites
; input:
; nothing
; output:
; $0B = Slope type that the sprite is touching.
; $0C = Low byte of the map16 number in Layer 1 that the sprite is touching.
; $0D = Low byte of the map16 number in Layer 2/3 that the sprite is touching.
; $0E = Sprite has interacted with a interactable/solid block in any Layer flag.
; $0F = Sprite has been processed with Layer 2/3
; $8B = High byte of the map16 number in Layer 1 that the sprite is touching.
; $8C = High byte of the map16 number in Layer 2/3 that the sprite is touching.


!LM_RAM		= $0BF6|!base2		; 256 bytes of free RAM. Must be on shadow RAM.

!L1_Screen_Lo	= !LM_RAM			; 96 bytes (32 * 3).
!L2_Screen_Lo	= !LM_RAM+48		; 48 bytes (shared).
!L1_Screen_Hi	= !LM_RAM+96		; 96 bytes (32 * 3).
!L2_Screen_Hi	= !LM_RAM+96+48		; 48 bytes (shared).

; These ones don't need to be on the shadow RAM, though...
!L1_Lookup_Lo	= !LM_RAM+96+96		; 32 bytes
!L2_Lookup_Lo	= !LM_RAM+96+96+16		; 16 bytes (shared)
!L1_Lookup_Hi	= !LM_RAM+96+96+32		; 32 bytes
!L2_Lookup_Hi	= !LM_RAM+96+96+32+16	; 16 bytes (shared)


ExtendedTest:
	stz $0F
	stz $0E
	stz $0B
	stz $8B
	stz $8C
	stz $8A
	stz $0D
	stz $0E
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
	if !EXLEVEL == 1
		lda.l !L1_Lookup_Lo,x		;load map16 pointers based on Y pos high byte.
	else
		lda.l $00BA60|!BankB,x
	endif
	ldy $0F			;$0F = ???
	beq .not_horz
	if !EXLEVEL == 1
		lda.l !L2_Lookup_Lo,x		;load map16 pointers based on Y pos high byte.
	else
		lda.l $00BA70|!BankB,x
	endif
.not_horz
	clc
	adc $00			;merge the pointers with the merged Y and X nybbles
	sta $05	
	if !EXLEVEL == 1
		lda.l !L1_Lookup_Hi,x
	else
		lda.l $00BA9C|!BankB,x
	endif
	ldy $0F
	beq .not_horz2		;do the same as above
	if !EXLEVEL == 1
		lda.l !L2_Lookup_Hi,x
	else
		lda.l $00BAAC|!BankB,x
	endif
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