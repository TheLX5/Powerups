
ducking_flag:
	lda !ducking_flag
	beq .can_duck
	lda #$00
	rtl
.can_duck
	lda $15
	and #$04
	rtl
