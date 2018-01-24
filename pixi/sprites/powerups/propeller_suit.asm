;;;;;;;;;;;;;;;;;;;;;;;;;;
;  ____________________  ;
; /		       \ ;
;|  PROPELLER MUSHROOM  |;
; \____________________/ ;
;			 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;

if !SA1 == 0
	!item_gfx_refresh = $7E2111
	!item_gfx_pointer = $7E2112
else
	!item_gfx_refresh = $404211
	!item_gfx_pointer = $404212
endif

!DrawOne16x16Tile = 0	  ;>  Enable this to make the Propeller Mushroom use one 16x16 tile.
			  ;   The reason why this is here is because the sprite uses six
			  ;   8x8 tiles and that's basically forcing you to use the No More
			  ;   Sprite Tile Limits patch. If you're not going to use that
			  ;   then I recommend you to enable this option. Note that it
			  ;   doesn't affect the item box sprite, and I recommend you to edit the
			  ;   values below if enabling this.

!PropShroomTileD  = $2C00 ;>  The mushroom tile (the two 8x8 tiles if not drawing a 16x16 tile,
			  ;   and the lower part of the shroom if doing so) in powerup_gfx.bin,
			  ;   used in the define below. Just edit the $08, the format is that like
			  ;   when you choose a tile in Lunar Magic's 8x8 Graphics Editor.
!PropellerTile1	  = #$3C  ;\
!PropellerTile2	  = #$2E  ; | The value for the propeller tiles in powerup_gfx.bin. Same format as
!PropellerTile3	  = #$3E  ; | above.
!PropellerTile4	  = #$40  ;/

!PropShroomTile	  = #(!PropShroomTileD>>3)+read2($00A38B) ;>  Don't touch this.

; /		 \ ;
;|  Init routine  |;
; \		 / ;

print "INIT ",pc
	lda $028012|!BankB
	sta $00
	lda $028013|!BankB
	sta $01
	lda $028014|!BankB
	sta $02
	jml [!Base1]
	;jsl read3($028012|!BankB)
	;rtl
	;jml read3($01C6DE)+$02

; /		 \ ;
;|  Main routine  |;
; \		 / ;

TouchedItem:
	plb
	stz !14C8,x
	pea.w $8021
	lda $02800F|!BankB
	sta $00
	lda $028010|!BankB
	sta $01
	lda $028011|!BankB
	sta $02
	jml [!Base1]
	;jml read3($02800F|!BankB)
	;JmL read3($01C539)

print "MAIN ",pc

PropMushroomMain:
	phb
	phk : plb

	jsr SubGFX

	lda !14C8,x
	cmp #$08
	bne Rtrn0
	lda $9D
	bne Rtrn0

	%SubOffScreen()
	jsl $01A7DC|!BankB
	bcs TouchedItem

	jsl $01801A|!BankB
	lda !1534,x
	bne DroppingFromItemBox
	lda !1540,x
	bne ExitingQuestionBlock
	jsl $018022|!BankB

	lda !B6,x
	cmp #$0C
	bcs +
	inc !B6,x
+
	lda $14
	lsr
	bcc Rtrn0

	ldy !151C,x
	lda !157C,x
	cmp #$06
	bcc +
	ldy #$02
+
	lda !AA,x
	clc : adc YSpeeds,y
	sta !AA,x
	cmp YSpeedsLimits,y
	bne Rtrn0
	tya
	eor #$01
	sta !151C,x
	inc !157C,x

Rtrn0:	plb
	rtl

DroppingFromItemBox:
	lda #$10
	sta !AA,x
	plb
	rtl

ExitingQuestionBlock:
	lda !AA,x
	beq +
	clc : adc #$02
	sta !AA,x
+	plb
	rtl

YSpeeds:
db $01,$FF,$FE
YSpeedsLimits:
db $16,$E8,$FC

SubGFX:
	lda !14C8,x
	cmp #$08
	bne .GetDrawInfo

	lda $14
	and #$06
	lsr
	tay
	lda !1602,x
	asl
	sta $00
	lda.w GFXIndexes,y
	pha
	ldx $00
	xba
	rep #$20
	and #$FF00
	lsr #3
	adc.w #read2($00A38B)

if !DrawOne16x16Tile == 0

	sta !item_gfx_pointer+6,x

	lda.w !PropShroomTile
	sta !item_gfx_pointer,x

else

	sta !item_gfx_pointer,x

	lda.w !PropShroomTile
	sta !item_gfx_pointer+6,x

endif

	sep #$20
	ldx $15E9|!Base2
	pla
	cmp !160E,x
	beq .skip
	sta !160E,x
	lda !1602,x
	inc
	ora !item_gfx_refresh
	and #$13
	sta !item_gfx_refresh
.skip
.GetDrawInfo
	%GetDrawInfo()

	lda !1534,x
	beq .DrawTiles
	lda $14
	and #$0C
	beq .DontDraw

.DrawTiles

if !DrawOne16x16Tile == 0

	phx
	lda !1602,x : tax
	lda.w .DynamicTiles,x
	sta $02
	ldx #$05

.Loop0
	lda $00
	clc : adc.w .XPositions,x
	sta $0300|!Base2,y

	lda $01
	clc : adc.w .YPositions,x
	sta $0301|!Base2,y

	lda $02
	clc : adc.w .VRAMTiles,x
	sta $0302|!Base2,y

	lda #$04
	cpx #$02
	bcs +
	ora #$40
+	ora $64
	sta $0303|!Base2,y

	iny #4
	dex : bpl .Loop0

	plx
	ldy #$00
	lda #$05
	jsl $01B7B3|!BankB

else
	lda $00
	sta $0300|!Base2,y
	lda $01
	sta $0301|!Base2,y

	phx
	lda !1602,x : tax
	lda.w .DynamicTiles,x
	sta $0302|!Base2,y
	plx

	lda #$04
	ora $64
	sta $0303|!Base2,y

	ldy #$02
	lda #$00
	jsl $01B7B3|!BankB

endif
	rts
.DontDraw
	lda !item_gfx_refresh
	and #$03
	sta !item_gfx_refresh
	rts

.XPositions:
db $08,$08,$00,$00,$08,$00

.YPositions:
db $00,$08,$00,$08,$F8,$F8

.VRAMTiles:
db $00,$01,$00,$01,$11,$10

.DynamicTiles:
db $0A,$0C,$0E

GFXIndexes:
db !PropellerTile2,!PropellerTile3,!PropellerTile4,!PropellerTile1