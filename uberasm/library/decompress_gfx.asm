decompress_gfx:
	ldy $19
	lda $02801B|!base3
	sta $8A
	lda $02801C|!base3
	sta $8B
	lda $02801D|!base3
	sta $8C
	lda [$8A],y
	sta !gfx_player_request
	sta !gfx_pl_compressed_flag
	lda $028021|!base3
	sta $8A
	lda $028022|!base3
	sta $8B
	lda $028023|!base3
	sta $8C
	lda [$8A],y
	sta !gfx_extra_request
	sta !gfx_ex_compressed_flag

.decompress_items
	lda.b #!gfx_items_buffer
	sta $00
	lda.b #!gfx_items_buffer/$100
	sta $01
	lda.b #!gfx_items_buffer/$10000
	sta $02
	rep #$30
	lda #$0FFE
	jsl $0FF900|!bank
	sep #$30

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
	lda $02801E|!base3
	sta $8A
	lda $02801F|!base3
	sta $8B
	lda $028020|!base3
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
	rtl
