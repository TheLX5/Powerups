;projectiles DMA, top
		
	LDA	!projectile_do_dma
	AND	#$00FF
	BEQ	+
		
	LDA.w	#!projectile_dma_tile<<4|$6000
	STA	$2116
	LDX	#$02
-		
	LDA	!projectile_gfx_index,x
	STA	$4312
	LDA	!projectile_gfx_bank
	STA	$4314
	LDA	#$0040
	STA	$4315
	LDY	#$02
	STY	$420B
	DEX	#2
	BPL	-
		
;projectiles DMA, bottom
		
	LDA	#!projectile_dma_tile<<4|$6100
	STA	$2116
	LDX	#$02
-		
	LDA	!projectile_gfx_index+$04,x
	STA	$4312
	LDA	!projectile_gfx_bank
	STA	$4314
	LDA	#$0040
	STA	$4315
	LDY	#$02
	STY	$420B
	DEX	#2
	BPL	-
+