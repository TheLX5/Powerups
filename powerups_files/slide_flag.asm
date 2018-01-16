slide_flag:
	lda !slide_flag
	beq .can_slide
	lda #$00
	rtl
.can_slide
	lda $148F|!base2
	ora $13ED|!base2
	rtl