give_1up:
	lda !190F,x
	bpl .1up
.poison	
	jsl $00F5B7|!base3
	bra +
.1up	
	lda #$08
	clc
	adc !1594,x
	jsl $02ACE5|!base3
+	
	jml $01C560|!base3