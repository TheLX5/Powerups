;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Handle player tile data
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Tiles:
	txy
	lda $1497|!base2
	beq .skip
	lsr #3
	tax
	lda.l $00E292|!base3,x
	and $1497|!base2
	ora $13FB|!base2
	ora $9D
	bne .skip
	plb
	rtl
.skip	
	lda #$F8
	sta $04
	cpy #$29
	bne .start
	lda $19
	bne .start
	ldy #$20
.start
	phy
	jsr HandleCustomImages
	plx

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
	jml $00E3C0|!base3
	
..UseAlt
	lda.l TileAltTable,x
	asl
	tax
	rep #$20
	ldy $13E0|!base2
	lda.l TileAltIndex-$02,x
	sta $00
	sep #$20
	lda.b #TileAltTable>>16
	sta $02
	lda [$00],y
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
	dw powerup_10_img
	dw powerup_11_img
	dw powerup_12_img