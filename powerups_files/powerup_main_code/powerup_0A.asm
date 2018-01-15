	lda $9D
	bne .return
	lda $77
	and #$04
	ora $73
	ora $74
	ora $75
	ora $187A|!base2
	bne .return_clear
	lda !power_ram
	asl
	tax
	jmp (.ptrs,x)

.ptrs		
	dw .checks
	dw .going_up
	dw .dont_go_up

.return_clear
	lda #$00
	sta !misc
	sta !power_ram
.return
	rts

.checks
	lda $16
	and #$80
	beq ..nope
	lda #!rocket_boots_time
	sta !misc
	lda #$01
	sta !power_ram
	bra .boost_up
..nope	
.dont_go_up
	rts

.going_up
	lda $15
	and #$80
	bne .boost_up
	rts
.boost_up
	stz $140D|!base2
	stz $13ED|!base2
	lda #$24
	sta $72
	lda !misc
	cmp #$02
	bcs .not_yet
	lda #$02
	sta !power_ram
	rts
.not_yet
	lda $7D
	bmi .rising
	sec
	sbc #$06
	sta $7D
	lda !misc
	dec
	sta !misc
	bra .done
.rising
	cmp #$D8
	bcc .done
	sec
	sbc #$04
	sta $7D
	cmp #$E8
	bcc ..skip
	lda !misc
	dec 
	sta !misc
	bra .done
..skip	
	lda !misc
	dec	
	dec
	sta !misc
.done
	lda $14
	and #$07
	beq .no_sfx
	lda #!rocket_boots_boost_sfx
	sta !rocket_boots_boost_port|!base2
	rep #$20
	lda $96
	clc
	adc #$0018
	cmp $1C
	sep #$20
	bcc .no_sfx
	ldy #$03
.loop	
	lda $17C0|!base2,y
	beq .found
	dey
	bpl .loop
.no_sfx
	rts
.found
	lda #$01
	sta $17C0|!base2,y
	lda $94
	sta $17C8|!base2,y
	lda $96
	clc
	adc #$18
	sta $17C4|!base2,y
	lda #$0F
	sta $17CC|!base2,y
	rts