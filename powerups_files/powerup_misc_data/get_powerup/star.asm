give_star:
	jsl $01C580|!base3
	lda #$04
	ldy !1534,x
	bne +
	jsl $02ACE5|!base3
+	
	lda #$0A
	sta $1DF9|!base2
	jml $01C560|!base3