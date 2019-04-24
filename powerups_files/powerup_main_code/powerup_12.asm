;;;;;;;;;;;;;;;;;;;
;; Cat Suit (SM3DW)
;;;;;;;;;;;;;;;;;;;

.cat_mario
;	lda #$01
;	sta !ducking_flag
;	sta !slide_flag
;	dec
	lda #$00
	sta !power_ram

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

	jsr .scratch
	jsr .climb
	rts

.scratch
	lda !power_ram+1
	bne ..attacking

..waiting	
	lda $77
	and #$04
	eor #$04
	ora $71
	ora $73
	ora $74
	ora $1407|!base2
	ora $140D|!base2
	ora $1470|!base2
	ora $14A5|!base2
	ora $13E3|!base2
	ora $13F3|!base2
	ora $187A|!base2
	bne ...not_pressed

	lda $16
	and #$40
	beq ...not_pressed
	
	lda #$01
	sta !power_ram+1
	lda #$12
	sta !timer
	lda #$01
	sta $1DF9|!base2
;	stz $7B
...not_pressed
	rts

..attacking
	lda !timer
	bne ...try
	lda #$00
	sta !power_ram+1
	rts
...try
	lsr #2
	and #$03
	tax
	lda.l ..poses,x
	sta !power_ram
	cpx #$02
	bcs +
	rts 
+	
	ldx $76
	lda $94
	clc
	adc.l ..x_disp,x
	sta $00
	lda $95
	adc.l ..x_disp+2,x
	sta $08
	lda $96
	clc
	adc #$05
	sta $01
	lda $97
	adc #$00
	sta $09
	lda #$12
	sta $02
	lda #$14
	sta $03
	
if !SA1	== 0
	ldx #$0B
else
	ldx #$15
endif	
...loop	
	lda !14C8,x
	cmp #$08
	bcs ...found
...try_again
	dex
	bpl ...loop
	jmp ...blocks

...found
	stx $15E9|!base2
	jsl $03B69F|!base3
	jsl $03B72B|!base3
	bcc ...try_again

	lda !7FAB10,x
	and #$08
	bne +
	phx
	lda !9E,x
	tax
	lda ..normal_sprites_table,x
	plx
	bra ++
+			
	phx
	lda !7FAB9E,x
	tax
	lda ..custom_sprites_table,x
	plx
++	
	cmp #$00
	bne ....try_again
	
	lda #$04
	sta !14C8,x
	lda #$1F
	sta !1540,x
	lda #$08
	sta $1DF9|!base2
if !SA1 == 1
	rep #$20
	txa
	and #$00FF
	clc
	adc.w #!9E
	sta $B4
	adc #$0016
	sta $CC
	adc #$0016
	sta $EE
	sep #$20
	lda ($B4)
	sta $87
endif
	jsl $07FC3B|!base3
	lda #$02
	jsl $02ACE5|!base3
....try_again
	jmp ...try_again

...blocks
	stz $13E8|!base2
	lda !power_ram
	beq ..end
	sec
	sbc #$46
	asl
	tay
	lda #$01
	sta $13E8|!base2
	lda $76
	asl
	tax
	rep #$20
	lda $94
	clc
	adc.l ..block_x_disp,x
	sta $13E9|!base2
	tyx
	lda $96
	clc
	adc.l ..block_y_disp,x
	sta $13EB|!base2
	sep #$20
..end	
	rts

..block_y_disp
	dw $0006
	dw $0016
..block_x_disp
	dw $FFF2
	dw $000E
..poses
	db $00,$00,$47,$46,$46

..x_disp
	db $EE,$10,$FF,$00

incsrc ../powerup_interaction_code/cat_table.asm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.climb
	lda !power_ram+1
	bne +

	phb
	lda.b #!ram_77_backup/$10000
	pha
	plb
	
	lda.w !flags
	bpl ..not_disable
	ldy.w !misc
	dey
	sty.w !misc
	bne ..disable
	lda #$80
	trb.w !flags
	plb
+	
	rts

..last_frame
	lda.w !ram_77_backup
	and #$03
	beq ..return
	ldx $76
	lda.l .wall_separate_speeds+2,x
	sta $7B
	stz $7A
	lda #$D8
	sta $7D
	lda #$80
	sta $1406
..return_move
	lda $77
	eor #$03
	and $15
	beq +
	ldy.w !flags
	bmi +
	asl #2
	sta.w !flags
+	
	lda #$80
	tsb.w !flags
	stz $77
	stz.w !ram_77_backup
	lda #!cat_suit_no_move
	sta !misc
..return_clear
	stz.w !misc+1
..return
	plb
	rts

..disable
	and #$7F
	lsr #2
	trb $15
	trb $16
..not_disable
	lda.w !misc+1
	beq +
	dec.w !misc+1

	lda $76
	inc
	eor #$03
	tsb $15
	lda $77
	beq ..last_frame
+	
	lda $13EF
	bne ..return_clear
	lda $77
	bit #$98
	bne ..return_move

 	ldy.w !misc+1
	bne ..dont_check_input
	and $15
	beq ..return_clear
	ldy.w !flags
	bmi +
	asl #2
	sta.w !flags
+	
	lda #!cat_suit_time_to_stick
	sta.w !misc+1

..dont_check_input
	lda.w !misc+1
	dec
	beq ..end_wall_climb
	lda $71
	ora $73
	ora $74
	ora $75
	ora $1407
	ora $140D
	ora $1470
	ora $187A
	bne ..return_clear
	lda $7E
	cmp #$09
	bcc ..return_clear
	cmp #$E8
	bcs ..return_clear

	ldy #$10
	lda $14
	lsr #2
	and #$01
	bne +
	iny 
+	
	sty.w !power_ram

	ldy #!cat_suit_climb_speed
	lda $9D
	bne ..return_2
	lda $16
	php
	bpl ..store_speed
	ldy #!cat_suit_kick_y_speed
..store_speed
	sty $7D
	ldx $76
	lda.l .wall_stay_speeds,x
	plp
	bpl +
	lda #$01
	sta $1DF9
	stz $77
	stz.w !misc+1
	stz.w !ram_77_backup
	lda #$80
	tsb.w !flags
	lda #!cat_suit_no_move
	sta.w !misc
;	lda #$0B
;	sta $72
	lda.l .kick_x_speeds,x
+	
	sta $7B
	lda #$80
	sta $1406
..return_2
	plb
	rts

..end_wall_climb
	ldx $76
	lda.l .wall_separate_speeds,x
	sta $7B
	stz $7A
	lda #$F0
	sta $7D
	stz $77
	lda #!cat_suit_no_move
	sta !misc
	lda #$80
	tsb.w !flags
	plb
	rts

.wall_stay_speeds:
	db -$10,$10
.wall_separate_speeds:
	db $18,-$18,$0A,-$0A
.kick_x_speeds
	db !cat_suit_kick_x_speed,!cat_suit_kick_x_speed^$FF+1