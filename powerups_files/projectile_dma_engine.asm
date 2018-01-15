;projectiles DMA, top
		
	LDA	!projectile_do_dma
	AND	#$00FF
	BEQ	+
		
	LDA.w #!projectile_dma_tile<<4|$6000
	sta $2116
	ldx #$02
-	
	lda !projectile_gfx_index,x
	sta $4312
	phx
	txa
	lsr
	tax
	lda !projectile_gfx_bank,x
	plx
	sta $4314
	lda #$0040
	sta $4315
	ldy #$02
	sty $420B
	dex #2
	bpl -
		
;projectiles DMA, bottom
		
	lda #!projectile_dma_tile<<4|$6100
	sta $2116
	ldx #$02
-	
	lda !projectile_gfx_index+$04,x
	sta $4312
	phx
	txa
	lsr
	tax
	lda !projectile_gfx_bank,x
	plx
	sta $4314
	lda #$0040
	sta $4315
	ldy #$02
	sty $420B
	dex #2
	bpl - 
+	