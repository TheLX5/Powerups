;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Tanooki Suit (Super Mario Bros. 3)
;; 
;; Gives Mario a full tanooki suit
;; You can fly for a short period of time.
;; You can also convert yourself in a statue.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	lda #!super_leaf_settings
	sta !cape_settings
	lda #!super_leaf_flight_timer
	sta !flight_timer

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
	cmp #$02
	bne .real_return
	
	lda #$01
	sta $13E8|!base2
	lda !power_ram
	asl
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
	lda !power_ram+2
	asl
	tax
	jsr (.ptrs,x)
	rts

.ptrs
	dw .init
	dw .statue
	dw .reset

.init
	lda !power_ram+3
	beq +
	dec
	sta !power_ram+3
+	
	lda $74
	ora $187A|!base2
	ora $148F|!base2
	ora $13ED|!base2
	ora $13E3|!base2
	ora !power_ram+3
	bne ..no
	lda $15
	and #$04	
	beq ..no
	lda $16
	and #$40
	beq ..no
	lda #$01
	sta !power_ram+2
	lda #$FF
	sta !mask_17
	lda #$BB
	sta !mask_15
	stz $7D
	stz $7B
	lda #$FF
	sta !power_ram+3
	lda #$04
	sta !power_ram+4
	sta $18BD|!base2
	lda #$10
	sta $1DF9|!base2
	stz $1DFC|!base2
	jsl $01C5AE|!base2
	stz $140D|!base2
	stz $13E8|!base2
	lda #$00
	sta !timer
	sta !flags
..no	
	rts

.statue
	lda !power_ram+4
	beq +
	dec
	sta !power_ram+4
+	
	lda !power_ram+3
	beq ..cancel
	dec
	sta !power_ram+3
	lda #$FF
	sta !mask_17
	lda #$FB
	sta !mask_15
	stz $7B
	lda #$00
	sta !timer
	sta !flags
	stz $140D|!base2
	stz $14A6|!base2
	lda $15
	and #$04
	sta $15
	beq ..cancel
	rts
..cancel
	lda #$02
	sta !power_ram+2
	lda #$04
	sta !power_ram+4
	sta $18BD|!base2
	lda #$10
	sta $1DF9|!base2
	jsl $01C5AE|!base3
	lda #$FF
	sta $78
	lda #$00
	sta !timer
	sta !flags
	rts
	
.reset
	lda !power_ram+4
	beq ..force
	dec
	sta !power_ram+4
	stz $140D|!base2
	stz $14A5|!base2
	lda #$FF
	sta !mask_17
	lda #$FB
	sta !mask_15
	lda #$00
	sta !timer
	sta !flags
	rts
..force
	lda #$00
	sta !power_ram+2
	lda #$04
	sta !power_ram+3
	lda #$00
	sta !timer
	sta !flags
	rts
.x_tail
	dw $FFF4,$000C