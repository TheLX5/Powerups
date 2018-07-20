give_1up:
	lda #$08
	clc
	adc !1594,x
	jsl $02ACE5|!base3
	rts