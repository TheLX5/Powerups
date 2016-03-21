if !dynamic_z = 0
PlrDMA:
	LDA	$0D84|!base2
	BNE	+
	JMP	.skip_all
+		
	REP	#$20
	LDY	#$86			; palette DMA
	STY	$2121
	LDA	#$0014
	STA	$4315
	LDA	#$2200
	STA	$4310
		
	LDA	!pal_bypass
	AND	#$00FF
	BNE	.bypass_pal_upload
		
	LDA	$0D82|!base2
	STA	$4312
	LDY.b	#LuigiPalettes>>16
	STY	$4314
	BRA	.continue_upload
.bypass_pal_upload
	LDA	!pal_pointer
	STA	$4312
	LDA	!pal_pointer+1
	STA	$4313
	SEP	#$20
	LDA	#$00
	STA	!pal_bypass
	REP	#$20
		
.continue_upload
	LDX	#$02
	STX	$420B
		
	LDY	#$80			; adjust some DMA settings
	STY	$2115
	LDA	#$1801
	STA	$4310
.player_top
	LDA	#$6000			; mario's top tiles
	STA	$2116
	TAX	
..loop		
	CPX	#$06			; PlrDMA2
	BCS	..yoshi
	SEP	#$20
	LDA	!gfx_pointer+$02
	STA	$4314
	REP	#$20
	LDA	$0D85|!base2,x
	STA	$4312
	BRA	..dma
..yoshi
	LDY	#$7E
	STY	$4314
	LDA	$0D85|!base2,x
	STA	$4312
..dma		
	LDA	#$0040
	STA	$4315
	LDY	#$02
	STY	$420B
	INX	#2
	CPX	$0D84|!base2
	BCC	..loop

.player_bottom
	LDA	#$6100			; mario's bottom tiles
	STA	$2116
	TAX	
..loop		
	CPX	#$06			; PlrDMA3
	BCS	..yoshi
	SEP	#$20
	LDA	!gfx_pointer+$02
	STA	$4314
	REP	#$20
	LDA	$0D8F|!base2,x
	STA	$4312
	BRA	..dma
		
..yoshi
	LDY	#$7E
	STY	$4314
	LDA	$0D8F|!base2,x
	STA	$4312
..dma
	LDA	#$0040
	STA	$4315
	LDY	#$02
	STY	$420B
	INX	#2
	CPX	$0D84|!base2
	BCC	..loop
		
.player_8x8	
	LDY	$0D9B|!base2
	CPY	#$02
	BEQ	+
		
++
	LDA.w	#!dmaer_tile<<4|$6000 	; mario's 8x8 tiles DMA
	STA	$2116
	LDA	$0D99|!base2
	STA	$4312
	LDY.b	#extended_gfx>>16
	STY	$4314
	LDA	#$0040
	STA	$4315
	LDX	#$02
	STX	$420B
		
if !enable_projectile_dma == 1
	incsrc projectile_dma_engine.asm
endif		
		
+		
	SEP	#$20
		
.skip_all	
	JML	$00A38F|!base3
endif