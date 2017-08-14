cape_image:
	lda !extra_tile_flag
	lsr
	bcs .custom_tile
	lda !cape_settings
	and #$10
	bne .cape_image
.hide_cape
	jml $00E458|!base3
.cape_image
	jml $00E401|!base3
	
.custom_tile
	phy
	lda !extra_tile_frame
	sta $0C
	lda !extra_tile_flag
	bit #$10
	beq .normal_priority
	ldy #$08
.normal_priority
	and.b #%11001110
	sta $0303,y
	lda #$04
	sta $0302|!base2,y
	rep #$20
	lda $80
	clc
	adc !extra_tile_offset_y
	pha
	clc
	adc #$0010
	cmp #$0100
	pla
	sep #$20
	bcs .no_draw
	sta $0301,y
	rep #$20
	lda $7E
	clc
	adc !extra_tile_offset_x
	pha
	clc
	adc #$0080
	cmp #$0200
	pla
	sep #$20
	bcs .no_draw
	sta $0300,y
	xba
	lsr
.no_draw
	php
	tya
	lsr #2
	tax
	rol
	plp
	and #$03
	ora #$02
	sta $0460,x
	ply
	iny #4
	inc $05
	inc $05 
	jml $00E458|!base3

cape_spin:
	pha
	lda !cape_settings
	lsr 
	pla 
	bcc .Nope
.Yes	
	jml $00CF45|!base3
.Nope	
	jml $00CF48|!base3

enable_fly:
	lda !cape_settings
	and #$02
	beq .nope
.yes	
	jml $00D8ED|!base3
.nope		
	jml $00D928|!base3

no_infinite_fly:
	lda !cape_settings
	and #$04
	beq .nope
	lda $7D
	bmi .nope
	lda $149F|!base2
	beq .nope
	jml $00D814|!base3
.nope
	jml $00D811|!base3

custom_flight_time:
	phy
	ldy #$50
	lda !cape_settings
	and #$08
	beq .Store
	lda !flight_timer
	tay
.Store	sty $149F|!base2
	ply 
	rtl 