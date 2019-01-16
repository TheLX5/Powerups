gfx_decompression:
	jsl $028AB1|!base3

	lda !gfx_player_request
	beq .no_player
	dec
	sta !gfx_player_request

.decompress_player
	lda.b #!gfx_player_buffer
	sta $00
	lda.b #!gfx_player_buffer/$100
	sta $01
	lda.b #!gfx_player_buffer/$10000
	sta $02

	ldy $19
	lda $028018
	sta $8A
	lda $028019
	sta $8B
	lda $02801A
	sta $8C
	lda #$00
	xba
	lda [$8A],y
	rep #$30
	clc
	adc.w #!starting_player_exgfx
	jsl $0FF900|!base3

.backup_player_gfx
	phb
	ldy.w #!gfx_ow_pl_buffer
	ldx.w #!gfx_player_buffer
	lda.w #$07FF
	mvn !gfx_ow_pl_buffer>>16,!gfx_player_buffer>>16
	plb
	sep #$30

.no_player
	lda !gfx_extra_request
	beq .no_decompression
	dec
	sta !gfx_extra_request

.decompress_extra_gfx
	lda.b #!gfx_extra_buffer
	sta $00
	lda.b #!gfx_extra_buffer/$100
	sta $01
	lda.b #!gfx_extra_buffer/$10000
	sta $02

	ldy $19
	lda $02801E
	sta $8A
	lda $02801F
	sta $8B
	lda $028020
	sta $8C
	lda #$00
	xba
	lda [$8A],y
	rep #$30
	clc
	adc.w #!starting_extra_exgfx
	jsl $0FF900|!base3
	sep #$30

.no_decompression
	jml $00A2EA|!base3