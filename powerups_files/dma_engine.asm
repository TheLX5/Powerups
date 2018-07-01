PlrDMA:
	lda $0D84|!base2
	bne +
	jmp .skip_all
+	
	rep #$20
	phd
	lda #$4300
	tcd

	ldy #$86			; palette DMA
	sty $2121
	lda #$0014
	sta $15
	lda #$2200
	sta $10
		
	lda !pal_bypass
	and #$00FF
	bne .bypass_pal_upload
		
	lda $0D82|!base2
	sta $12
	ldy.b #LuigiPalettes>>16
	sty $14
	bra .continue_upload
.bypass_pal_upload
	lda.l !pal_pointer
	sta $12
	lda.l !pal_pointer+1
	sta $13
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
	sta $10

;misc tiles
	ldx #$7E
	stx $14
	lda #$6060
	sta $2116
	ldx #$06
	cpx $0D84|!base2
	bcs .skip
-	
	lda $0D85|!base2,x
	sta $12
	lda #$0040
	sta $15
	sty $420B
	inx #2
	cpx $0D84|!base2
	bcc -

	lda #$6160
	sta $2116
	ldx #$06
-	
	lda $0D8F|!base2,x
	sta $12
	lda #$0040
	sta $15
	sty $420B
	inx #2
	cpx $0D84|!base2
	bcc -


;player upload
.skip

;cape tile
	lda !extra_tile_index
	xba 
	bmi .skip_cape
	ldx $0D88|!base2
	stx $14
	
	lda #$6040
	sta $2116
	lda $0D89|!base2
	sta $12
	lda #$0040
	sta $15
	sty $420B

	lda #$6140
	sta $2116
	lda $0D93|!base2
	sta $12
	lda #$0040
	sta $15
	sty $420B

.skip_cape

;mario tiles

	ldx $0D87|!base2
	stx $14
	lda $0D86|!base2 : pha
	ldx #$06
-	
	lda.l .vramtbl,x
	sta $2116
	lda #$0080
	sta $15
	lda $0D85|!base2
	sta $12
	sty $420B
	inc $0D86|!base2
	inc $0D86|!base2
	dex #2
	bpl -
	pla : sta $0D86|!base2

	ldx.b #powerup_items/$10000
	stx $14
	lda !item_gfx_refresh
	and #$0003
	asl
	tax
	jmp (.ptrs,x)

.ptrs
	dw .no_update
	dw .1_tile
	dw .2_tile
	dw .both_tiles

.1_tile	
	lda !item_gfx_pointer 
	sta $12
	lda #$60A0
	sta $2116
	lda #$0040
	sta $15
	sty $420B

	lda #$61A0
	sta $2116
	lda.l !item_gfx_pointer+6
	sta $12
	lda #$0040
	sta $15
	sty $420B
	jmp .no_update


.2_tile
	lda !item_gfx_pointer+2
	sta $12
	lda #$60C0
	sta $2116
	ldx.b #powerup_items/$10000
	stx $14
	lda #$0040
	sta $15
	sty $420B

	lda #$61C0
	sta $2116
	lda.l !item_gfx_pointer+8
	sta $12
	lda #$0040
	sta $15
	sty $420B
	jmp .no_update


.both_tiles
	lda #$60A0
	sta $2116
	ldx #$00
-	
	lda !item_gfx_pointer,x
	sta $12
	lda #$0040
	sta $15
	sty $420B
.skip_both
	inx #2
	cpx #$04
	bcs -

;bottom tiles
	lda #$61A0
	sta $2116
	ldx #$00
-	
	lda.l !item_gfx_pointer+6,x
	sta $12
	lda #$0040
	sta $15
	sty $420B
.skip_both_2
	inx #2
	cpx #$04
	bcs -


.no_update


if !no_dynamic_item_box == 0
	ldx $0100|!base2
	cpx #$13
	beq .item_box_refresh
	lda !item_gfx_refresh
	and #$0010
	beq .skip_item_refresh
	
.item_box_refresh
	lda #$60E0
	sta $2116
	ldx.b #powerup_items/$10000
	stx $14
	lda.l !item_gfx_pointer+4
	sta $12
	lda #$0040
	sta $15
	sty $420B

	lda #$61E0
	sta $2116
	lda.l !item_gfx_pointer+10
	sta $12
	lda #$0040
	sta $15
	sty $420B
endif

.skip_item_refresh

	lda !item_gfx_refresh
	and #$FF00
	sta !item_gfx_refresh
	
if !enable_projectile_dma == 1
	incsrc projectile_dma_engine.asm
endif		
	pld
	sep #$20
.skip_all
	jml $00A38F|!base3

.vramtbl
	dw $6300,$6200,$6100,$6000