	lda $75
	beq .ground
	jmp .underwater
.ground
	jmp powerup_0C




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
	lda #$01
	sta $73
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