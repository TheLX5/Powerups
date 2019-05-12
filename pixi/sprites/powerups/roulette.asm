incsrc ../../powerup_defs.asm

print "INIT ",pc
	lda $02806F|!BankB
	sta $00
	lda $028070|!BankB
	sta $01
	lda $028071|!BankB
	sta $02
	jml [!Base1]
	rtl

print "MAIN ",pc
	phb
	phk
	plb
	lda $64
	pha
	jsr roulette_main
skip:	
	pla
	sta $64
	lda #$00
	%SubOffScreen()
	plb
	rtl

roulette:

.main	
	lda !190F,x
	and #$7F
	sta !190F,x
	inc !151C,x
	lda !151C,x
	cmp #$68
	bcc ..no_change_image
	stz !151C,x
	inc !160E,x
..no_change_image
	
.logic
	lda !1540,x
	beq +
;	cmp #$0F
;	bcc ++
;;	lda #$C0
;	sta !AA,x
;	stz $157C,x
;	lda #$20
;	sta !1558,x
++	
	jsl $019138|!BankB
	lda !1528,x
	bne ++
	lda #$10
	sta $64
++	
	lda $9D
	bne ++++
	lda #$FC
	sta !AA,x
	jsl $01801A|!BankB
++++	
-	
	jmp .prepare_draw
+	
	lda $9D
	bne -
	inc !1570,x
	lda #$F8
	ldy !157C,x
	bne +
	lda #$08
+	
	sta !B6,x
	
	stz !1662,x
	lda !C2,x
	beq ..movement
	bmi ..no_move
	lda #$0B
	sta !1662,x
	jsl $019138|!BankB
	lda !1588,x
	bne ..no_move
	stz !C2,x
	bra ..no_move
..movement
	jsl $01802A|!BankB
	lda $14
	and #$03
	beq +
	dec !AA,x
+	
..no_move
	lda !1588,x
	and #$08
	beq ..not_ceiling
	stz !AA,x
..not_ceiling
	lda !1588,x
	and #$04
	bne ..in_ground
	bra ..in_air
..in_ground
	lda #$C8
	sta !AA,x
	
..in_air
	lda !1558,x
	ora !C2,x
	bne +
	lda !1588,x
	and #$03
	beq +
	lda !157C,x
	eor #$01
	sta !157C,x
+	
.prepare_draw
	lda !C2,x
	beq +
	cmp #$FF
	bne ++
+	
	lda !1632,x
	beq +
++	
	lda #$10
	sta $64
+	
	jsr .gfx

.interaction
	jsl $01A7DC|!BankB
	bcs ..contact
	rts
..contact
	lda !160E,x
	and #$03
	asl
	tax
	rep #$20
	lda.w .gfx_index,x
	sta $00
	sep #$20
	lda.b #!extra_byte_1/$10000
	sta $02
	ldy $15E9|!Base2
	lda [$00],y
	tyx
	tay
	lda !7FAB9E,x
	pha 
	lda !9E,x
	pha 
	lda !190F,x
	pha 
	lda ..item_id,y
	sta !9E,x
	sta !7FAB9E,x
	lda ..item_flag,y
	sta !190F,x
	lda $02800F|!BankB
	sta $00
	lda $028010|!BankB
	sta $01
	lda $028011|!BankB
	sta $02
	phk
	pea.w ..grab_item-1
	pea.w $80C9
	jml [!Base1]
..grab_item
	wdm
	ldx $15E9|!Base2
	pla
	sta !190F,x
	pla
	sta !9E,x
	pla
	sta !7FAB9E,x

	stz !14C8,x
	rts

..item_id
	db $74	;00 mushroom
	db $75	;01 fire
	db $76	;02 star
	db $77	;03 cape
	db $00	;04 hammer
	db $01	;05 boomerang
	db $02	;06 leaf
	db $03	;07 tanooki
	db $04	;08 frog
	db $05	;09 superball
	db $06	;0A rocket
	db $07	;0B mini
	db $08	;0C ice
	db $09	;0D penguin
	db $0A	;0E propeller
	db $0B	;0F shell
	db $0C	;10 bubble
	db $0D	;11 cloud
	db $0E	;12 cat
	db $00	;13 unused
	db $00	;14 unused
	db $00	;15 unused
	db $00	;16 unused
	db $00	;17 unused

..item_flag
	db $00	;mushroom
	db $00	;cape
	db $00	;fire
	db $00	;star
	db $80	;hammer
	db $80	;boomerang
	db $80	;leaf
	db $80	;tanooki
	db $80	;frog
	db $80	;superball
	db $80	;rocket
	db $80	;mini
	db $80	;ice
	db $80	;penguin (unused)
	db $80	;propeller
	db $80	;shell
	db $80	;bubble
	db $80	;cloud
	db $80	;cat
	db $80	;unused
	db $80	;unused
	db $80	;unused
	db $80	;unused
	db $80	;unused
	
	
.gfx	
	lda !1602,x
	and #$01
	asl
	pha				;
	lda !160E,x
	and #$03
	asl
	tax

	rep #$20
	lda.w ..index,x
	sta $00
	ldy.b #!extra_byte_1/$10000
	sty $02
	ldy $15E9|!Base2
	lda [$00],y
	and #$00FF
	sta $0E
	tax
	lda.w ..dynamic_tiles,x
	xba
	and #$FF00
	lsr #3
	adc.w #read2($00A38B|!BankB)
	plx
	sta !item_gfx_pointer,x
	clc
	adc #$0200
	sta !item_gfx_pointer+6,x
	sep #$20

	tyx
	lda !1602,x
	inc
	ora !item_gfx_refresh
	and #$13
	sta !item_gfx_refresh
..draw	
	%GetDrawInfo()
	
	lda $00
	sta $0300|!Base2,y
	lda !C2,x
	beq +
	dec $01
+	
	lda $01
	sta $0301|!Base2,y

	lda !1602,x
	tax
	lda.w ..dynamic_slots,x
	sta $0302|!Base2,y
	
	ldx $0E
	lda.w ..palettes,x
	ora $64
	sta $0303|!Base2,y

	ldx $15E9|!Base2
	ldy #$02
	lda #$00
	jsl $01B7B3|!BankB
	rts

..index	
	dw !extra_byte_1
	dw !extra_byte_2
	dw !extra_byte_3
	dw !extra_byte_4

..dynamic_slots
	db $0A,$0C

..dynamic_tiles
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

..palettes
	db $08,$0A,$04,$04
	db !powerup_04_prop
	db !powerup_05_prop
	db !powerup_06_prop
	db !powerup_07_prop
	db !powerup_08_prop
	db !powerup_09_prop
	db !powerup_0A_prop
	db !powerup_0B_prop
	db !powerup_0C_prop
	db !powerup_0D_prop
	db !powerup_0E_prop
	db !powerup_0F_prop
	db !powerup_10_prop
	db !powerup_11_prop
	db !powerup_12_prop
	db !powerup_13_prop
	db !powerup_14_prop
	db !powerup_15_prop
	db !powerup_16_prop
	db !powerup_17_prop