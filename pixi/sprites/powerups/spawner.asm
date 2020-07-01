incsrc ../../powerup_defs.asm

print "INIT ",pc
init:
	lda !extra_byte_2,x
	sta !157C,x
	lda !extra_byte_1,x
	cmp.b #power_table_end-power_table
	bcc .end
	stz !14C8,x
.end
	rtl


print "MAIN ",pc
	phb
	phk
	plb
	jsr generator_main
	lda #$00
	%SubOffScreen()
	plb
	rtl

power_table:
	db $74
	db $75
	db $77
	db $76
	db !starting_slot+$00
	db !starting_slot+$01
	db !starting_slot+$02
	db !starting_slot+$03
	db !starting_slot+$04
	db !starting_slot+$05
	db !starting_slot+$06
	db !starting_slot+$07
	db !starting_slot+$08
	db !starting_slot+$09
	db !starting_slot+$0A
	db !starting_slot+$0B
	db !starting_slot+$0C
	db !starting_slot+$0D
	db !starting_slot+$0E
	db !starting_slot+$0F
	db !starting_slot+$13
.end
	
return:
	rts


generator:
.main	
	lda $9D
	bne return
	dec !157C,x
	phx
	stz $00
	ldx.b #!SprSize-1
..loop	
	cpx $15E9|!Base2
	beq ..next_slot
	lda !14C8,x
	cmp #$08
	bcc ..next_slot
	lda !7FAB10,x
	and #$08
	bne ..is_custom
	lda.w !9E,x
	cmp #$74
	bcc ..next_slot
	cmp #$7A
	bcs ..next_slot
	inc $00
	bra ..next_slot
..is_custom
	lda !7FAB9E,x
	cmp #!starting_slot
	bcc ..next_slot
	cmp.b #!starting_slot+!max_powerup-4
	bcs ..next_slot
	inc $00
..next_slot
	dex
	bpl ..loop
	plx
	lda $00
	beq ..ready
..end	
	lda !extra_byte_2,x
	sta !157C,x
	rts
..ready	
	lda !157C,x
	bne return
	lda !extra_byte_2,x
	sta !157C,x
	bra ..check_slots
	lda !sprite_y_low,x
	cmp $1C
	lda !sprite_y_high,x
	sbc $1D
	bne return
	lda !sprite_x_low,x
	cmp $1A
	lda !sprite_x_high,x
	sbc $1B
	bne return
	lda !sprite_x_low,x
	sec
	sbc $1A
	clc
	adc #$10
	cmp #$10
	bcc ..ret

..check_slots
	%GetDrawInfo()
	jsl $02A9DE|!BankB
	bpl .spawn
..ret
	rts
	
.spawn	
	lda #$02
	sta $1DFC|!Base2
	lda #$08
	sta !14C8,y
	phx
	lda !extra_byte_1,x
	sta $00
	tax
	lda.l power_table,x
	cpx #$04
	bcs ..custom
	sta.w !9E,y
	tyx
	jsl $07F7D2|!BankB
	bra ..continue
..custom
	tyx
	sta !7FAB9E,x
	jsl $07F7D2|!BankB
	lda #$88
	sta !7FAB10,x
	jsl $0187A7|!BankB
	lda !190F,x
	ora #$80
	sta !190F,x
..continue
	lda $01,s
	tax
	lda !E4,x
	sta.w !E4,y
	lda !14E0,x
	sta !14E0,y
	lda !extra_bits,x
	and #$04
	bne +
	lda $00
	cmp #$06
	beq ..adjust
	cmp #$02
	beq ..adjust
	cmp #$0E
	beq ..adjust
+	
	lda !D8,x
	sta.w !D8,y
	lda !14D4,x
	sta !14D4,y
	bra ..continue_setup
..adjust
	lda !D8,x
	sec
	sbc #$10
	sta.w !D8,y
	lda !14D4,x
	sbc #$00
	sta !14D4,y
..continue_setup
	lda !extra_bits,x
	and #$04
	beq +
	lda !15A0,x
	ora !186C,x
	php
	tyx
	lda #$2C
	sta !154C,x
	sta !15AC,x
	plp
	bne ++
	stz $00
	stz $01
	lda #$1B
	sta $02
	lda #$01
	%SpawnSmoke()
	bra ++
+	
	tyx
	lda #$2C
	sta !154C,x
	sta !15AC,x
	lda #$3E
	sta !1540,x
	lda #$D0
	sta !AA,x
++	
	lda #$01
	sta $02
	lda $15E9|!Base2
	pha
	stx $15E9|!Base2
	lda $00
	pha
	jsl init_item
	pla 
	cmp #$0E
	bne +
	lda #$00
	sta !7FAB10,x
+	
	pla
	sta $15E9|!Base2
	plx
	rts

init_item:
	lda $02806F|!BankB
	sta $00
	lda $028070|!BankB
	sta $01
	lda $028071|!BankB
	sta $02
	jml [!Base1]