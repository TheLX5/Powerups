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
	inc !C2,x		;original code

	lda #$FF
	sta $00			;$00 is used to know the powerup that is going to be in the second item slot
	ldy #$0B
.loop	
	cpy $15E9|!base2	;ignore if we're comparing the this sprite
	beq .clear
	lda !14C8,y
	cmp #$08		;ignore if sprite isn't alive
	bcc .clear
	lda.w !9E,y		;probably we need more checks here (custom items)
	cmp #$74
	bcc .clear		;ignore if not an original powerup
	cmp #$79
	bcs .clear
	lda !1528,y		;ignore if not an item
	beq .clear
	cmp #$02		;check if it is the oldest item
	bcs .erase_older
	sty $00			;save the index of the sprite
.clear	
	dey			;keep searching
	bpl .loop

	ldy $00			;check if we got a item sprite
	cpy #$FF
	beq .skip
	lda #$02		;mark the first item sprite as the second item sprite
	sta !1528,y
	bra .skip

.erase_older
	lda #$00
	sta !1528,y		;delete oldest item
	sta !1602,y
	sta !14C8,y
	
	jsr .smoke		;puff of smoke
	
	ldy #$0B
-	
	cpy $15E9|!base2
	beq +
	lda !14C8,y
	cmp #$08
	bcc +
	lda.w !9E,y
	cmp #$74		;same search as before
	bcc +			;trying to find the other item
	cmp #$79
	bcs +
	lda !1528,y
	cmp #$01
	bne +
	lda #$02		;if found, mark it as the older item
	sta !1528,y
	
	bra ++
+	
	dey
	bpl -
++
.skip	
	ldx $15E9|!base2
	lda #$01		;mark the current sprite as the newest item
	sta !1528,x

	jsr update_tilemap	;update gfx
	rtl

.smoke
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
		

powerup_tiles:
	lda !1528,x
	ora !14C8,x
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
	lda #$00		;finish gfx routine
	ldy #$02
	jml $01C6E2|!base3
	
.dynamic_tiles
	db $0A,$0C

update_tilemap:
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
	rts 

dynamic_item_tiles:		;to be expanded and will also include labels
	db $00,$02,$06,$04,$00
endif