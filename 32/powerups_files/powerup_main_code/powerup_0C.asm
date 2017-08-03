;;;;;;;;;;;;;;;;;;;;;
;; Cat Mario

	lda !flags
	asl
	tax
	jsr (.codes-2,x)
.skip	
	rts

.codes	
	dw .doing_nothing
	dw .climb_wall
	dw .attack

.doing_nothing
	lda !wait_timer
	bne .return
	lda $77
	and #$03
	beq .check_attack
	and $15
	beq .check_attack
	lda #$A0
	sta !timer
	lda #$01
	sta !flags
.return
	rts
.check_attack
	rts
.climb_wall
	lda !timer
	beq ..slide
	dec
	sta !timer
	lda $77
	and #$03
	sta $00
	lda $15
	and $00
	bne ..keep
	bra ..cancel
..keep
	lda $15
	and #$08
	beq ..no_up
	lda #$E2
	sta $7D
	rts
..no_up
	lda $15
	and #$04
	beq ..no_down
	lda #$1E
	sta $7D
	rts
..no_down
	stz $7D
	rts
..slide
	lda $15
	and #$03
	beq ..cancel
	lda #$0A
	sta $7D
	rts
..cancel
	lda #$00
	sta !flags
	sta !timer
	lda #$30
	sta !wait_timer
	rts
.attack
	rts