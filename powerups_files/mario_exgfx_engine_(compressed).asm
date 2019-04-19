mario_exgfx:
	lda !gfx_bypass_flag		;check if you there is another gfx due to be loaded
	beq .no_bypass_everything
	bra .bypass_everything
.no_bypass_everything
if !SA1 == 1
	lda !player_num
	sta $2251
	stz $2252
	lda.b #!max_powerup+1
	sta $2253			;get the correct index based on powerup status*player num
	stz $2254
	stz $2250
	lda #$00
	xba
	lda $19
	clc
	adc $2306	
else	
	lda !player_num
	sta $4202			;get the correct index based on powerup status*player num
	lda.b #!max_powerup+1
	sta $4203
	lda #$00
	xba
	nop #4
	lda $19
	clc
	adc $4216
endif
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

	lda !gfx_pl_compressed_flag
	beq .handle_pl_uncompressed

	rep #$20
	ldx $0100|!base2
	cpx #$0C
	bcc .level
	cpx #$10
	bcs .level
.ow	
if (!gfx_ow_pl_buffer&$FFFF) < $8000
	lda.w #(!gfx_ow_pl_buffer&$FFFF)
else
	lda.w #$0000
endif	
	sta $00
	lda.w #!gfx_ow_pl_buffer
	sta.l !gfx_pointer+0
	lda.w #!gfx_ow_pl_buffer/$100
	sta.l !gfx_pointer+1
	bra .cont

.level
if (!gfx_player_buffer&$FFFF) < $8000
	lda.w #($8000-(!gfx_player_buffer&$FFFF))
else
	lda.w #$0000
endif	
	sta $00
	lda.w #!gfx_player_buffer
	sta.l !gfx_pointer+0
	lda.w #!gfx_player_buffer/$100
	sta.l !gfx_pointer+1

.cont
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
	sec
	sbc $00
	
	bra .handle_pl_rest
	
.handle_pl_uncompressed
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

	lda !gfx_ex_compressed_flag
	beq .handle_extra_tile_uncompressed

	rep #$20
	lda.w #!gfx_extra_buffer
	sta.l !extra_tile_pointer+0
	lda.w #!gfx_extra_buffer/$100
	sta.l !extra_tile_pointer+1

	lda $0B
	and #$FF00
	lsr #3
	clc
	adc !extra_tile_pointer
	bra .skip_decompressed

.handle_extra_tile_uncompressed
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

.skip_decompressed
	
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