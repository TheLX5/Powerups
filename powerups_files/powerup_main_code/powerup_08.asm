;;;;;;;;;;;;;;;;;;;
;; Frog Suit (SMB3)
;;;;;;;;;;;;;;;;;;;

.main
	lda $187A|!base2
	beq +
	ldx $18DF|!base2
	stz $C1,x
	stz $0DC1|!base2
	stz $187A|!base2
+	
	lda #$01
	sta !ride_yoshi_flag
	lda $75
	beq .out_of_water
	jmp .underwater

.out_of_water
	lda #$00
	ldy $148F|!base2
	beq .next
	lda #$40
.next	
	sta !mask_15
	sta !mask_17
	ldx #$00
	ldy #$00
	
	lda $72
	bne .air
	lda $15
	and #$40
	beq .walking
	iny
.walking
	lda $7B
	bpl .no_fix_sign
	eor #$FF
	inc
.no_fix_sign
	cmp .threesold1,y
	bcc .nonextframe
	inx
.nonextframe
	cmp .threesold2,y
	bcc .nonextframe2
	inx
.nonextframe2
	cmp .threesold3,y
	bcc .no_reset
	lda .reset_speed,y
	ldy $76
	bne .no_fix_sign_2
	eor #$FF
	inc
.no_fix_sign_2
	sta $7B
	stz $13E4|!base2
.no_reset
	lda .ground_frames,x
	sta !power_ram
;	rts
.air
	rts

.threesold1
	db $07,$15
.threesold2
	db $0D,$1E
.threesold3
	db $15,$25
.reset_speed
	db $00,$04

.underwater
	stz $7B
	stz $7D
	ldy #$00
	lda $15
	bpl .slow_speed
	iny
.slow_speed
	lda $14
	lsr #3
	and #$03
	beq .no_dec
	dec
.no_dec	
	tax
	lda .neutral_frames,x
	sta !power_ram
.right
	lda $15
	and #$01
	beq .not_right
	lda .right_frames,x
	sta !power_ram
	lda $77
	bit #$01
	bne .not_right
	lda .right_speed,y
	sta $7B
.not_right
.left
	lda $15
	and #$02
	beq .not_left
	lda .left_frames,x
	sta !power_ram
	lda $77
	bit #$02
	bne .not_left
	lda .left_speed,y
	sta $7B
.not_left
.down	
	lda $15
	and #$04
	beq .not_down
	lda .down_frames,x
	sta !power_ram
	lda $77
	bit #$04
	bne .not_down
	lda .down_speed,y
	sta $7D
.not_down
.up	
	lda $15
	and #$08
	beq .not_up
	lda .up_frames,x
	sta !power_ram
	lda $77
	bit #$08
	bne .not_up
	lda .up_speed,y
	sta $7D
.not_up
	rts

.ground_frames
	db $00,$01,$02
.neutral_frames
	db $13,$13,$13
.right_frames
	db $10,$11,$12
.left_frames
	db $10,$11,$12
.up_frames
	db $0A,$2E,$2F
.down_frames
	db $04,$05,$06
.right_speed
	db $10,$28
.left_speed
	db $F0,$DB
.up_speed
	db $F0,$DB
.down_speed
	db $10,$28