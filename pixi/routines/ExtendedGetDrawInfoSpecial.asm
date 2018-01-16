
; Gets the OAM index to be used, deletes when off screen, etc.

	lda.l .oam_slots-8,x
	tay
	stz $03
	lda !extended_x_high,x
	xba 
	lda !extended_x_low,x
	rep #$20
	sec
	sbc $1A
	clc
	adc #$0040
	cmp #$0180
	sep #$20
	bcs .erase_spr
	lda !extended_y_low,x
	clc
	adc #$10
	php
	cmp $1C
	rol $00
	plp
	lda !extended_y_high,x
	adc #$00
	lsr $00
	sbc $1D
	bne .erase_spr
	lda !extended_x_low,x
	sec
	sbc $1A
	sta $01
	lda !extended_x_high,x
	sbc $1B
	beq .no_high_bit
	lda #$01
	sta $03
.no_high_bit
	lda !extended_y_low,x
	sec
	sbc $1C
	sta $02
	lda !extended_behind,x
	sta $04
	sec
	rtl

.erase_spr
	stz !extended_num,x
	lda #$01
	sta $03
	phx
	ldx #$09
.loop	
	lda !extended_num,x
	beq .found_slot
	dex
	cpx #$07
	bpl .loop
	lda #$00
	sta !projectile_do_dma
.found_slot
	plx
	clc
	rtl

.oam_slots
	db $F8,$FC