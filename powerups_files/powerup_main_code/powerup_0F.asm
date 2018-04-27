;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Shell suit
;; by LX5
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	lda $187A|!base2
	ora $1470|!base2
	bne .reset
	lda !flags
	asl
	tax
	jmp (.ptrs,x)

.ptrs	
	dw .checks
	dw .sliding
	
.sliding
	stz $149B|!base2
	stz $18D2|!base2
	lda #$01
	sta !disable_spin_jump
	sta $73
	lda $75
	beq .no_water
	lda $77
	and #$04
	bne .no_water
	lda #$80
.no_water
	ora #$0F
	sta !mask_15
	ldy $76
	lda.w .speeds,y
	sta $7B
	lda $77
	and #$01
	beq +
	stz $76
	lda #$01
	sta $1DF9|!base2
	jsr .cape_spin
+	
	lda $77
	and #$02
	beq .not_in_shell
	lda #$01
	sta $76
	lda #$01
	sta $1DF9|!base2
	jsr .cape_spin
.not_in_shell
	bit $15
	bvs .xy
.reset	
	lda #$00
	sta !disable_spin_jump
	sta !mask_15
	sta !flags
	sta $73
.xy	
	rts
	
.cape_spin
	ldy $76
	rep #$20
	lda $94
	sta $13E9|!base2
	lda $96
	clc
	adc #$0014
	sta $13EB|!base2
	sep #$20
	lda #$01
	sta $13E8|!base2
	rts

.checks
	lda $13E4|!base2
	cmp #$64
	bcc .no_active
	cmp #$70
	bcs .no_active
	lda $73
	beq .no_active
	lda #$01
	sta !flags
	sta $73
	lda $13E3|!base2
	beq .no_active
	phb
	lda #$00
	pha
	plb
	phk
	pea .no_wall-1
	pea $84CE
	jml $00EB42|!base3
.no_wall
	plb
.no_active
	rts

.speeds
	db (!shell_suit_base_x_speed-0)^$FF,!shell_suit_base_x_speed+0