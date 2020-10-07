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
;; This place runs with DB set to BWRAM
;; There's no need for !base2 defines
;; It will break if the powerup ram addresses are
;; remapped to use bank $41

.climb
	lda !power_ram+1
	bne ..skip
	
	phb
	lda.b #!ram_77_backup/$10000
	pha
	plb
	
	lda.w !power_ram+2
	bne +
	lda $77
	and #$04
	beq +
	stz.w !power_ram+7
	stz.w !power_ram+11
+	
	lda.w !flags
	bpl ..unlocked
	ldy.w !misc
	dey
	sty.w !misc
	bne ..locked
	lda #$80
	trb.w !flags
	plb
..skip	
	rts

..check_last_frame
	lda.w !ram_77_backup
	and #$03
	beq ..end
	
	ldy #!cat_LedgePullYSpeed
	lda.w !power_ram+6
	beq ...time_out
...time_left
	lda $15
	bit #$08
	beq ...drop
	lda.w !power_ram+6
	sec
	sbc.b #!cat_wallkick_penalization
	cmp.b #$100-!cat_wallkick_penalization+1
	bcs ...drop
	sta.w !power_ram+6
	bra ...skip
...drop
	inx #4
	ldy #!cat_DropYSpeed
	bra ...skip
...time_out
	lda #!cat_NoMoveOut
	sta.w !misc
	ldy #$F8
...skip
	lda.l ..Tbl_LedgePullXSpd,x
	sta $7B
	sta.w !power_ram+9
	lda #$01
	sta.w !power_ram+10
	stz $7A
	sty $7D
	sty.w !power_ram+8
	lda #$0B
	sta $72
	lda #$80
	sta $1406
..clear_l
	jmp ..clear

..detach
	lda.w !power_ram+2
	beq ..end
	jmp ..walldrop
..end	
	plb
	rts

..locked
	and #$7F
	lsr #2
	trb $15
	trb $16
..unlocked
	ldx $76
	lda.w !power_ram+2
	beq +
	txa
	inc
	trb $15
	eor #$03
	tsb $15
	lda $77
	beq ..check_last_frame
+	
	lda $13EF
	ora $71
	ora $73
	ora $74
	ora $75
	ora $1407
	ora $140D
	ora $1470
	ora $187A
	bne ..detach
	lda $7E
	cmp #$09
	bcc ..detach
	cmp #$E8
	bcs ..detach
	lda $77
	bit #$9C
	bne ..detach
	
	ldy.w !power_ram+2
	bne ..climbing
	and $15
	beq ..detach
	asl #2
	sta.w !flags
	stz.w !misc
	
	inc.w !power_ram+2
	
	lda.w !power_ram+7
	bne +
	lda.b #!cat_suit_wall_attach_time
	sta.w !power_ram+6
+	
	inc
	sta.w !power_ram+7
	
	stz $13DF
	lda !ram_77_backup
	bmi ..climbing
	lda $94
	and #$F0
	ora.l ..Tbl_WallSnap,x
	sta $94
	
..climbing
	lda $9D
	bne ..return_l
	ldy #$10
	lda.w !power_ram+6
	beq ++
	dec.w !power_ram+6
	lda $16
	bmi ..wallkick
	lda $15
	lsr #2
	and #$03
	tax
	lda.l ..Tbl_WallClimbSpd,x
	sta.w !power_ram+5
	sta $7D
	bne +
	stz.w !power_ram+4
	bra ..draw_pose
++	
-	
	stz.w !power_ram+6
	lda #$03
	sta $7D
	stz.w !power_ram+4
	lda #$01
	jsr ..generate_smoke
	lda.w !ram_77_backup
	bne ..draw_pose
	lda #$80
	tsb.w !flags
	stz.w !misc
	bra ..draw_pose
+	
	inc.w !power_ram+4
	lda.w !power_ram+4
	lsr #!cat_climb_ani_rate
	bcc ..draw_pose
	iny
..draw_pose
	sty.w !power_ram
	
	ldx $76
	lda.l ..Tbl_WallStaySpd,x
	sta $7B
	stz $7A
	lda #$80
	sta $1406
..return_l
	bra ..return

..wallkick
	lda.w !power_ram+6
	sec
	sbc.b #!cat_wallkick_penalization
	cmp.b #$100-!cat_wallkick_penalization+1
	bcs -
	sta.w !power_ram+6
	ldy #!cat_KickYSpeed
	ldx $76
	lda $15
	and #$04
	beq +
..walldrop
	lda #!cat_NoMoveDetach
	sta.w !misc
..end_wall_climb
	ldy #!cat_DropYSpeed
	inx #2
	lda #$01
	sta $1DF9
	bra ++
+	
	lda #!cat_NoMoveTime
	sta.w !misc
	lda #$02
	sta $1DF9
++	
	sty $7D
	sty.w !power_ram+8
	lda.l ..Tbl_WallKickXSpd,x
	sta $7B
	sta.w !power_ram+9
	lda #$01
	sta.w !power_ram+10
	stz $7A
	stz $77
	stz.w !ram_77_backup
	lda #$0B
	sta $72
	lda #$80
	tsb.w !flags
..clear
	stz.w !power_ram+2
..return
	plb
	rts
	
..generate_smoke
	lda $14
	and #$03
	bne ...return
	lda $7F
	ora $81
	bne ...return
	ldx #$03
...loop
	lda $17C0,x
	beq ...found_free
	dex
	bpl ...loop
	dec $1863
	bpl ...found_extra
	lda #$03
	sta $1863
...found_extra
	ldx $1863
...found_free
	lda #$03
	sta $17C0,x
	lda #$0B
	sta $17CC,x
	phx
	ldx $76
	lda $94
	clc
	adc.l ...x_disp,x
	plx
	sta $17C8,x
	lda $96
	clc
	adc #$0D
	sta $17C4,x
...return
	rts

...x_disp
	db $FB,$0D

..Tbl_WallSnap
	db $0D,$02		; Wall attach X pos adjust, low nybble

..Tbl_WallClimbSpd
	db $00			; Wall climb speed, no input
	db $00 ;!cat_ClimbSpeed^$FF+1	; Wall climb speed, holding Down
	db !cat_ClimbSpeed		; Wall climb speed, holding Up
	db !cat_ClimbSpeed		; Wall climb speed, holding both Up and Down
	db $00

..Tbl_WallStaySpd
	db $F0,$10		; Wall attach reinforcing speeds

..Tbl_LedgePullXSpd
	db !cat_LedgePullXSpeed^$FF+1,!cat_LedgePullXSpeed	; Climb up past ledge X speeds

..Tbl_WallKickXSpd
	db !cat_KickXSpeed,!cat_KickXSpeed^$FF+1			; Wall kick X speeds
	db !cat_DropXSpeed,!cat_DropXSpeed^$FF+1			; Wall drop X speeds