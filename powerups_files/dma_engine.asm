PlrDMA:
	lda $0D84|!base2
	bne +
	jmp .skip_all
+		
	rep #$20
	ldy #$86			; palette DMA
	sty $2121
	lda #$0014
	sta $4315
	lda #$2200
	sta $4310
		
	lda !pal_bypass
	and #$00FF
	bne .bypass_pal_upload
		
	lda $0D82|!base2
	sta $4312
	ldy.b #LuigiPalettes>>16
	sty $4314
	bra .continue_upload
.bypass_pal_upload
	lda !pal_pointer
	sta $4312
	lda !pal_pointer+1
	sta $4313
	sep #$20
	lda #$00
	sta !pal_bypass
	rep #$20
		
.continue_upload
	ldy #$02
	sty $420B
		
	ldx #$80			; adjust some DMA settings
	stx $2115
	lda #$1801
	sta $4310

.bigger_upload
;cape tile
	ldx $0D88|!base2
	stx $4314
	
	lda #$6040
	sta $2116
	lda $0D89|!base2
	sta $4312
	lda #$0040
	sta $4315
	sty $420B

	lda #$6140
	sta $2116
	lda $0D93|!base2
	sta $4312
	lda #$0040
	sta $4315
	sty $420B

;misc tiles
	ldx #$7E
	stx $4314
	lda #$6060
	sta $2116
	ldx #$06
	cpx $0D84|!base2
	bcc .skip
-	
	lda $0D85|!base2,x
	sta $4312
	lda #$0040
	sta $4315
	sty $420B
	inx #2
	cpx $0D84|!base2
	bcc -

	lda #$6160
	sta $2116
	ldx #$06
-	
	lda $0D8F|!base2,x
	sta $4312
	lda #$0040
	sta $4315
	sty $420B
	inx #2
	cpx $0D84|!base2
	bcc -


;player upload
.skip
+
	ldx $0D87|!base2
	stx $4314
	lda $0D86|!base2 : pha
	ldx #$06
-	
	lda.l .vramtbl,x
	sta $2116
	lda #$0080
	sta $4315
	lda $0D85|!base2
	sta $4312
	sty $420B
	inc $0D86|!base2
	inc $0D86|!base2
	dex #2
	bpl -
	pla : sta $0D86|!base2

	lda !item_gfx_refresh
	lsr
	bcc .skip_item_refresh
	asl
	sta !item_gfx_refresh

;top_tiles
	lda #$60A0
	sta $2116
	ldx.b #powerup_items/$10000
	stx $4314
	ldx #$00
-	
	lda !item_gfx_pointer,x
	sta $4312
	lda #$0040
	sta $4315
	sty $420B
	inx #2
	cpx #$06
	bne -

;bottom tiles
	lda #$61A0
	sta $2116
	ldx #$00
-	
	lda !item_gfx_pointer+6,x
	sta $4312
	lda #$0040
	sta $4315
	sty $420B
	inx #2
	cpx #$06
	bne -

.skip_item_refresh
	
	;jmp .skip_all-2

if !enable_projectile_dma == 1
	incsrc projectile_dma_engine.asm
endif		

	sep #$20
.skip_all
	jml $00A38F|!base3

.vramtbl
	dw $6300,$6200,$6100,$6000