;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Handle powerup item gfx
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

if !dynamic_items == 0
powerup_tiles:
	lda !190F,x		;$190F highest bit is used to difference a custom item from the original ones
	bpl .original_code
	lda !166E,x		;check if it should keep flipping like a flower.
	and #$10
	beq .no_stop_flip
	lda !15F6,x
	ora $64
	sta $0303|!base2,y
.no_stop_flip	
	lda !7FAB9E,x
	sec
	sbc.b #!starting_slot
	tax
	lda.l .powerup_tiles,x	;load custom powerup tiles
	jml $01C6DA|!base3
.original_code
	lda !9E,x
	sec 
	sbc #$74		;load original powerup tiles
	jml $01C6D6|!base3
		
.powerup_tiles			;this is handled automagically
	db !powerup_04_tile
	db !powerup_05_tile
	db !powerup_06_tile
	db !powerup_07_tile
	db !powerup_08_tile
	db !powerup_09_tile
	db !powerup_0A_tile
	db !powerup_0B_tile
	db !powerup_0C_tile
	db !powerup_0D_tile
	db !powerup_0E_tile
	db !powerup_0F_tile
else

;; init_powerup was relocated to be able to initialize the powerups

init_powerup:
	inc !C2,x		;original code, dunno what it does.
	stz $02
init_item:
	lda #$FF
	sta $00			;$00 is used to know the powerup that is going to be in the second item slot
	sta $03
	ldx #$0B
.loop	
	cpx $15E9|!base2	;ignore if we're comparing the this sprite
	beq .clear
	lda !14C8,x
	cmp #$08		;ignore if sprite isn't alive
	bcc .clear
	;beq .clear
	lda !7FAB10,x
	and #$08
	bne ++
	lda.w !9E,x		;probably we need more checks here (custom items)
	cmp #$74
	bcc .clear		;ignore if not an original powerup
	cmp #$7A
	bcs .clear
	bra +++
++	
	lda !7FAB9E,x
	cmp #!starting_slot
	bcc .clear
	cmp #!max_powerup-4
	bcs .clear
+++	
	lda !1602,x
	cmp #$02
	beq +
	lda !1510,x		;ignore if not an item
	beq .clear
	cmp #$02		;check if it is the oldest item
	bcs .erase_older
	stx $00			;save the index of the sprite
.clear	
	dex			;keep searching
	bpl .loop

	ldx $00			;check if we got a item sprite
	cpx #$FF
	beq .skip
	lda #$02		;mark the first item sprite as the second item sprite
	sta !1510,x
	bra .skip

.erase_older
	stx $00
	ldx #$FF
	stx $01
	ldx #$0B
-	
	cpx $15E9|!base2
	beq +
	lda !14C8,x
	cmp #$08		;ignore if sprite isn't alive
	bcc +
	;beq +
	lda !7FAB10,x
	and #$08
	bne ++
	lda.w !9E,x
	cmp #$74		;same search as before
	bcc +			;trying to find the other item
	cmp #$7A
	bcs +
	bra +++
++	
	lda !7FAB9E,x
	cmp #!starting_slot
	bcc +
	cmp #!max_powerup-4
	bcs +
+++	
	lda !1602,x
	cmp #$02
	beq +
	lda !1510,x
	cmp #$01
	bne +
	lda #$02		;if found, mark it as the older item
	sta !1510,x
	stx $01	
	bra ++
+	
	dex
	bpl -
	bra .skip
++
	ldy $00
	lda #$00
	sta !14C8,y	;delete oldest item
	sta !1510,y
	inc $03
	jsr smoke_routine_item		;puff of smoke
.skip	
	ldx $15E9|!base2
	lda #$01		;mark the current sprite as the newest item
	sta !1510,x


update_tilemap:
	lda $02
	beq .skip
	lda $03			;nonsense code, but hey, it works
	beq .skip
	ldx $00
	bpl .new
	ldy $01
	bmi .skip
	lda !1602,y
	bra .new_2
.new	
	lda !1602,x
.new_2
	asl
	sta !item_gfx_refresh
.skip
	ldx $15E9|!base2
	lda !item_gfx_refresh
	eor #$02		;change the dynamic tile that the item will use
	ora #$01		;flag to update vram
	sta !item_gfx_refresh
	lsr 			;make it 1 or 0
	and #$01		;probably not needed, but eh
	sta !1602,x

	lda !190F,x		;check if custom item
	bpl .original_items
	lda !7FAB9E,x
	sec
	sbc.b #!starting_slot
	clc
	adc #$05		;load the correct index for custom items
	bra .continue
.original_items
	lda !9E,x
	sec
	sbc #$74		;load the correct index for original items
.continue
	tay
	lda !1602,x		;determine which item in SP1 will be overwritten
	asl
	tax 
	phb
	phk
	plb			;load dynamic tile to show
	lda.w dynamic_item_tiles,y
	xba
	plb

	rep #$20
	and #$FF00		;update the item gfx pointers
	lsr #3
	adc #powerup_items
	;tyx
	sta !item_gfx_pointer,x
	clc
	adc #$0200
	sta !item_gfx_pointer+6,x

	sep #$20
	ldx $15E9|!base2
	rtl

smoke_routine_item:
	lda !186C,y
	ora !15A0,y
	bne ++
	ldx #$03
-	
	lda $17C0|!base2,x
	beq +
	dex
	bpl -
++
	rts
+	
	lda #$01
	sta $17C0|!base2,x
	lda #$1B
	sta $17CC|!base2,x
	lda.w !D8,y
	sta $17C4|!base2,x
	lda.w !E4,y
	sta $17C8|!base2,x
	rts

dynamic_item_tiles:
	db $00,$02,$06,$04,$00
	db !dynamic_powerup_04_tile
	db !dynamic_powerup_05_tile
	db !dynamic_powerup_06_tile
	db !dynamic_powerup_07_tile
	db !dynamic_powerup_08_tile
	db !dynamic_powerup_09_tile
	db !dynamic_powerup_0A_tile
	db !dynamic_powerup_0B_tile
	db !dynamic_powerup_0C_tile
	db !dynamic_powerup_0D_tile
	db !dynamic_powerup_0E_tile
	db !dynamic_powerup_0F_tile

.box
	db $00,$02,$06,$04
	db !dynamic_powerup_04_tile
	db !dynamic_powerup_05_tile
	db !dynamic_powerup_06_tile
	db !dynamic_powerup_07_tile
	db !dynamic_powerup_08_tile
	db !dynamic_powerup_09_tile
	db !dynamic_powerup_0A_tile
	db !dynamic_powerup_0B_tile
	db !dynamic_powerup_0C_tile
	db !dynamic_powerup_0D_tile
	db !dynamic_powerup_0E_tile
	db !dynamic_powerup_0F_tile

powerup_tiles:
	lda !14C8,x
	bne .draw
	lda #$F0
	sta $0301|!base2,y
	jml $01C6E5|!base3
.draw	
	lda !190F,x		;check if custom item
	bpl .no_stop_flip
	lda !166E,x
	and #$10		;check if it should be flipping
	beq .no_stop_flip
	lda !15F6,x
	ora $64
	sta $0303|!base2,y
.no_stop_flip	
	lda !1602,x		;check which dynamic tile will the powerup use
	tax
	lda.l .dynamic_tiles,x
	sta $0302|!base2,y

	ldx $15E9|!base2
	stz $00
	lda !154C,x
	beq .no_cover		;not coming out of the block, no cover up tile
	lda !9E,x
	cmp #$77		;no cape, no tile
	beq .no_cover
	lda $0300|!base2,y
	sta $0304|!base2,y
	lda $0301|!base2,y	;literally copy everything
	sta $0305|!base2,y
	and #$F0
	clc
	adc #$0F
	sta $0301|!base2,y
	lda $0302|!base2,y
	sta $0306|!base2,y
	lda #$2E
	sta $0302|!base2,y
	lda $0303|!base2,y
	sta $0307|!base2,y
	lda #$00
	sta $0303|!base2,y
	inc $00
.no_cover
	lda $00			;finish gfx routine
	ldy #$02
	jml $01C6E2|!base3
	
.dynamic_tiles
	db $0A,$0C,$0E

question_block_fix:
	jsl $07F7D2|!base3	;original code
	lda !9E,x
	cmp #$74
	bcc +
	cmp #$7A
	bcs +
	stx $15E9|!base2
	pei ($9A)
	pei ($98)		;position was fuk
	lda #$01
	sta $02
	stz !1602,x
	stz !1510,x
	jsl init_item
	rep #$20
	pla
	sta $98
	pla
	sta $9A
	sep #$20
+	
	rtl
endif