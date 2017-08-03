;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Handle player tile data
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

OAM_data:
	pha
	lda !get_32
	tax
	pla
	cpx #$00
	bne .no_flip
.normal
	ldx $04
	cpx #$E8
	bne .no_flip
	eor #$40
.no_flip
	jml $00E3EC|!base3

OAM_8x8:
	ldx $06
	lda !get_32
	bne .big
	lda.l $00DFDA,x
	jml $00E466
.big	
	lda.l mario_8x8,x
	jml $00E466

OAM_y_pos:
	pha
	lda !get_32
	and #$00FF
	bne .big
	pla
	clc
	adc.l $00DE32|!base3,x
	rtl
.big
	pla 
	clc 
	adc.l mario_y_pos,x
	rtl 

OAM_x_pos:
	pha
	lda !get_32
	and #$00FF
	bne .big
	pla
	clc
	adc.l $00DD4E|!base3,x
	rtl
.big
	pla 
	clc 
	adc.l mario_x_pos,x
	rtl 

Tiles:
	lda !get_32
	beq .normal
	lda $1497
	beq .skip
	bra +
.normal
	lda $1497
	beq .continue_normal
+	
	lsr #3
	txy
	tax
	lda.l $00E292|!base3,x
	and $1497|!base2
	ora $13FB|!base2
	pha
	lda !get_32
	tax
	pla
	cpx #$00
	bne .big
	ora $9D
	bne .continue_normal
.force
	plb
	rtl
.big	
	ora $9D
	bne .skip
	plb
	rtl
.skip	
	lda #$F8
	bra +
.continue_normal
	lda #$C8
+
	tyx
	cpx #$43
	bne .real_continue
	lda #$E8
.real_continue
	sta $04
	cpx #$29
	bne .start
	lda $19
	bne .start
	ldx #$20
.start
	phx
	jsr HandleCustomImages
	plx
	lda !get_32
	beq .normal_tiles
	jmp .bigger_tiles
.normal_tiles
	lda.l $00DCEC,x
	ora $76
	tay
	lda.l $00DD32,x
	sta $05
	ldx $19
	lda.l TileAltTable,x
	bne .UseAlt
	lda $13E0|!base2
	cmp #$3D
	bcs +
	adc.l TileIndexData,x
+	tax 
	lda.l $00E00C,x
	sta $0A
	lda.l $00E0CC,x
	sta $0B
-	lda.l $00DF1A,x
	bpl +
	and #$7F
	sta $0D
	lda #$04
+	sta $06
	txy
	jml $00E3C0

.UseAlt	
	lda.l TileAltTable,x
	asl
	tax
	rep #$20
	lda $13E0|!base2
	and #$00FF
	sta $0B
	lda.l TileAltIndexUpper-$02,x
	clc
	adc $0B
	sta $00
	sep #$20
	lda.b #TileAltTable>>16
	sta $02
	lda [$00]
	sta $0A
	rep #$20
	lda.l TileAltIndexLower-$02,x
	clc 
	adc $0B
	sta $00
	sep #$20
	lda [$00]
	sta $0B
	ldx $19
	lda $13E0|!base2
	cmp #$3D
	bcs +
	clc 
	adc.l TileIndexData,x
+	tax 
	bra -

.bigger_tiles
	lda.l PosPointPointer,x
	ora $76
	tax
	lda.l PosPoint,x
	sta $05
	
	ldx $19
	lda.l TileAltTable,x
	bne ..UseAlt
	lda $13E0|!base2
	cmp #$3D
	bcs +
	adc.l TileIndexData,x
+	tax 
	lda.l excharactertilemap,x
-
	sta $0A
	stz $06
	jml $00E3C0
	
..UseAlt
	lda.l TileAltTable,x
	asl
	tax
	rep #$20
	lda $13E0|!base2
	and #$00FF
	sta $0B
	lda.l TileAltIndexUpper-$02,x
	clc
	adc $0B
	sta $00
	sep #$20
	lda.b #TileAltTable>>16
	sta $02
	lda [$00]
	bra -

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Handle custom images ($13E0)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

HandleCustomImages:
	lda $19
	cmp #!max_powerup
	beq +
	bcs .Return
+		
	phb
	phk
	plb
	rep #$30
	and #$00FF
	asl
	tax
	lda.w PowerupImages,x
	sta $00
	sep #$30
	ldx #$00
	jsr ($0000|!base1,x)
	plb
.Return		
	rts

PowerupImages:
	dw powerup_00_img
	dw powerup_01_img
	dw powerup_02_img
	dw powerup_03_img
	dw powerup_04_img
	dw powerup_05_img
	dw powerup_06_img
	dw powerup_07_img
	dw powerup_08_img
	dw powerup_09_img
	dw powerup_0A_img
	dw powerup_0B_img
	dw powerup_0C_img
	dw powerup_0D_img
	dw powerup_0E_img
	dw powerup_0F_img