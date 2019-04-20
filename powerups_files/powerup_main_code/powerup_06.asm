;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Super Leaf (Super Mario Bros. 3)
;; 
;; Gives Mario a pair of ears and a raccoon tail
;; You can fly for a short period of time.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	lda #!super_leaf_settings
	sta !cape_settings
	lda #!super_leaf_flight_timer
	sta !flight_timer
	lda #!super_leaf_tap_timer
	sta !cape_button_timer

	lda $13F3|!base2
	beq .no_balloon
	lda #$00
	sta !timer
.no_balloon
	
	lda !timer
	bne .return
	
	bit $16
	bvc .return
	
	lda $73
	ora $74
	ora $187A|!base2
	ora $140D|!base2
	ora $1470|!base2
	ora $13E3|!base2
	ora $13F3|!base2
	bne .return
	
	lda #!super_leaf_spin_sfx
	sta !super_leaf_spin_port|!base2
	
	lda $76
	sta !power_ram
	lda #!super_leaf_spin_timer
	sta !timer
	
.return	
	sec
	sbc #$04
	bmi .real_return
	lsr #2
	cmp #$01
	beq +
	cmp #$02
	bne .real_return
	lda #$01
	sta $13E8|!base2
	lda !power_ram
	asl
-
	tay
	rep #$20
	lda $94
	clc
	adc.w .x_tail,y
	sta $13E9|!base2
	lda $96
	clc
	adc #$0014
	sta $13EB|!base2
	sep #$20
	bra .real_return+3
+	
	lda #$01
	sta $13E8|!base2
	lda !power_ram
	eor #$01
	bra -
.real_return
	stz $13E8|!base2
	
	lda $7D
	rol #2
	and #$01
	ora $74
	ora $75
	ora $14A5|!base2
	ora $140D|!base2
	ora $13E3|!base2
	ora $13F3|!base2
	bne ++++
	lda $16
	bpl ++++
	lda #$04
	sta $1DFC|!base2
	lda #$10
	sta $14A5|!base2
	lda #$0F
	sta !power_ram+1
	stz $7D
	rts
++++
	lda $77
	and #$04
	beq +
	lda #$05
	sta !flags
+	
	lda $14A5|!base2
	ora $140D|!base2
	ora $13E3|!base2
	ora $13F3|!base2
	ora $74
	ora $75
	ora !flags
	bne +
	lda $16
	bpl +
	lda #$0F
	sta !power_ram+1
	lda #$04
	sta $1DFC|!base2
+	
	lda !flags
	beq +
	dec
	sta !flags
+	
	rts

.x_tail
	dw $FFF4,$000C