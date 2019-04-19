mario_exgfx:
	lda !gfx_bypass_flag		;check if you there is another gfx due to be loaded
	beq .no_bypass_everything
	bra .bypass_everything
.no_bypass_everything
	lda #$00
	xba
	lda !player_num
	beq .no
	lda.b #!max_powerup+1
.no	
	clc
	adc $19
	tax
	lda.l GFXData,x			;get the correct powerup data
	sta $00
	lda.l ExtraGFXData,x
	bra .continue

.bypass_everything
	lda !gfx_bypass_num		;load mario's gfx
	sta $00
	lda !extra_gfx_bypass_num	;load player's extra gfx
.continue
	sta $02
	sta !extra_tile_index
	lda $00
	sta !gfx_index
	stz $01
	rep #$30
	lda $00	
	asl
	clc
	adc $00
	tax				;multiply data*3
	
	lda.l PowerupGFX,x
	sta !gfx_pointer
	sep #$20
	lda.l PowerupGFX+2,x
	sta.l !gfx_pointer+2		;store info in pointers
	sep #$10

	ldx #$00
	rep #$20
	lda $09
	clc
	adc !gfx_pointer
	and #$0300
	sec
	ror
	pha

	lda $09
	clc
	adc !gfx_pointer
	and #$3C00
	asl
	ora $01,s

.handle_pl_rest	
	sta $0D85|!base2

	lda !gfx_pointer+2
	and #$00FF
	tay
	bit $09
	bvc +
	iny
+	
	sty $0D87|!base2
	tya
	pla

.extra_tile
	sep #$20
	stz $03

	rep #$30
	lda $02
	asl
	clc
	adc $02
	tax
	lda.l ExtraTilesGFX,x
	sta !extra_tile_pointer
	sep #$20
	lda.l ExtraTilesGFX+2,x
	sta.l !extra_tile_pointer+2
	sep #$10

	rep #$20
	lda $0B
	and #$FF00
	lsr #3
	clc
	adc !extra_tile_pointer
	
	sta $0D89|!base2
	clc
	adc #$0200
	sta $0D93|!base2
	lda.l !extra_tile_pointer+2
	tay 
	sty $0D88|!base2
	sep #$20

	lda #$0A
	sta $0D84|!base2
	jml $00F635|!base3