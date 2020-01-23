;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Handle powerup item gfx
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

if !dynamic_items == 0
powerup_tiles:
	lda !14D4,x
	xba
	lda !E4,x		;fixes powerups being processed off screen
	rep #$20
	cmp #$FF80
	bcs .offscreen_v_fix
	cmp $13D7|!base2
	sep #$20
	bcc .offscreen_v_fix
	stz !14C8,x
.offscreen_v_fix
	sep #$20

	lda !190F,x		;$190F highest bit is used to recognize a custom item from the original ones
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
	db !powerup_10_tile
	db !powerup_11_tile
	db !powerup_12_tile
	db !powerup_13_tile
	db !powerup_14_tile
	db !powerup_15_tile
	db !powerup_16_tile
	db !powerup_17_tile
else

;; init_powerup was relocated to be able to initialize the powerups

init_powerup:
	inc !C2,x		;original code, dunno what it does.
init_pballoon_item:
	stz $02
	stz !1510,x
init_item:
.search_oldest
	phb
	phk
	plb
	lda !item_gfx_latest
	sta $00
	lda !item_gfx_oldest
	sta $01
	stz $03
	tax

	cpx #$FF
	beq ..free
	cpx $15E9|!base2
	beq ..free
	lda !14C8,x
	cmp #$08
	bcc ..free
	lda !7FAB10,x
	and #$08
	bne ..custom_sprite
	lda !9E,x
	cmp #$7D
	beq ..found
	cmp #$74
	bcc ..free
	cmp #$7A
	bcs ..free
	bra ..found
..custom_sprite
	lda !7FAB9E,x
	cmp #!starting_slot
	bcc ..free
	cmp.b #!starting_slot+!max_powerup-4
	bcs ..free
..found
	lda #$01
	tsb $03
..free
	
.search_latest
	ldx $00
	cpx #$FF
	beq ..free
	cpx $15E9|!base2
	beq ..free
	lda !14C8,x
	cmp #$08
	bcc ..free
	lda !7FAB10,x
	and #$08
	bne ..custom_sprite
	lda !9E,x
	cmp #$7D
	beq ..found
	cmp #$74
	bcc ..free
	cmp #$7A
	bcs ..free
	bra ..found
..custom_sprite
	lda !7FAB9E,x
	cmp #!starting_slot
	bcc ..free
	cmp.b #!starting_slot+!max_powerup-4
	bcs ..free
..found
	lda #$02
	tsb $03
..free

.checker
	lda $03
	asl
	tax
	jmp (..ptrs,x)

..ptrs
	dw ..none_alive
	dw ..oldest_alive
	dw ..latest_alive
	dw ..both_alive

..none_alive
	lda #$FF
	sta !item_gfx_oldest
	ldx $15E9|!base2
	stz !1602,x
	bra ..end	
..oldest_alive
	lda !item_gfx_oldest
	bra ..shared_alive
..latest_alive
	lda !item_gfx_latest
	sta !item_gfx_oldest
	bra ..shared_alive
..both_alive
	ldx $01
	stz !14C8,x
	jsr smoke_routine_item
	lda !item_gfx_latest
	sta !item_gfx_oldest
..shared_alive
	tay
	lda !1602,y
	eor #$01
	ldx $15E9|!base2
	sta !1602,x
..end	
	txa
	sta !item_gfx_latest

	lda !1602,x
	inc
	ora !item_gfx_refresh
	and #$13
	sta !item_gfx_refresh


	lda !190F,x		;check if custom item
	bpl .original_items
	lda !9E,x
	cmp #$78
	beq .poison
	lda !7FAB9E,x
	sec
	sbc.b #!starting_slot
	clc
	adc.b #$05		;load the correct index for custom items
	bra .continue
.poison	
	lda.b #2+!max_powerup+1
	bra .continue
.original_items
	lda !9E,x
	cmp #$7D
	bne +
.balloon
	lda.b #2+!max_powerup+0
	bra .continue
+	
	sec
	sbc.b #$74		;load the correct index for original items
.continue
	tay
	
	ldx $15E9|!base2
	lda #$00
	xba
	lda !1602,x
	asl
	tax			;load dynamic tile to show
	lda.w dynamic_item_tiles,y
	xba

	rep #$20
	and #$FF00		;update the item gfx poi nters
	lsr #3
	adc.w #read2($00A38B|!base3) ;#powerup_items
	sta !item_gfx_pointer,x
	clc
	adc #$0200
	sta !item_gfx_pointer+6,x
	sep #$20

	ldx $15E9|!base2
	plb
	rtl



smoke_routine_item:
	lda !186C,x
	ora !15A0,x
	bne ++
	ldy #$03
-	
	lda $17C0|!base2,y
	beq +
	dey
	bpl -
++
	rts
+	
	lda #$01
	sta $17C0|!base2,y
	lda #$1B
	sta $17CC|!base2,y
	lda !D8,x
	sta $17C4|!base2,y
	lda !E4,x
	sta $17C8|!base2,y
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
	db !dynamic_powerup_10_tile
	db !dynamic_powerup_11_tile
	db !dynamic_powerup_12_tile
	db !dynamic_powerup_13_tile
	db !dynamic_powerup_14_tile
	db !dynamic_powerup_15_tile
	db !dynamic_powerup_16_tile
	db !dynamic_powerup_17_tile
	db $4C
	db $4E


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
	db !dynamic_powerup_10_tile
	db !dynamic_powerup_11_tile
	db !dynamic_powerup_12_tile
	db !dynamic_powerup_13_tile
	db !dynamic_powerup_14_tile
	db !dynamic_powerup_15_tile
	db !dynamic_powerup_16_tile
	db !dynamic_powerup_17_tile
	db $4C
	db $4E

powerup_tiles:
	lda !14D4,x
	xba
	lda !E4,x		;fixes powerups being processed off screen
	rep #$20
	cmp #$FF80
	bcs .offscreen_v_fix
	cmp $13D7|!base2
	sep #$20
	bcc .offscreen_v_fix
	stz !14C8,x
.offscreen_v_fix
	sep #$20
	
	lda !14C8,x
	cmp #$08
	beq .draw
	cmp #$0C
	beq .draw
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
	lda #$00
	ldy #$02
	jml $01C6E2|!base3

.dynamic_tiles
	db $0A,$0C,$0E

question_block_fix:
	jsl $07F7D2|!base3	;original code
	lda !9E,x
	cmp #$7D
	beq ++
	cmp #$74
	bcc +
	cmp #$7A
	bcs +
++	
	lda $15E9|!base2
	pha
	stx $15E9|!base2
	stz !1602,x
	stz !1510,x
	jsl init_item
	pla
	sta $15E9|!base2
+	
	rtl

invisible_mushroom_fix:
	jsl $07F7D2|!base3
	stz !1510,x
	jml init_item


green_mushroom_checkpoint_fix:
	jsl $07F7D2|!base3
	stx $15E9|!base2
	stz !1510,x
	jml init_item


super_koopa_fix:
	jsl $07F7D2|!base3
	stz !1510,x
	lda $15E9|!base2
	pha
	stx $15E9|!base2
	jsl init_item
	pla
	sta $15E9|!base2
	rtl

bubble_fix:
	jsl $07F7D2|!base3
	stz !1510,x
	lda $04,s
	cmp #$74
	beq +
	rtl
+	
	jml init_item

pballoon_fix:
	jsl $07F7D2|!base3
	lda $04,s
	cmp #$7D
	beq +
	rtl
+	
	stz !1510,x
	lda $15E9|!base2
	pha
	stx $15E9|!base2
	jsl init_item
	pla
	sta $15E9|!base2
	rtl

endif