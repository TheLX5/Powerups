give_mushroom:
	lda #$02
	sta $71
	lda #$2F
	sta $1496|!base2,y
	sta $9D
	lda #$04
	ldy !1534,x
	bne +
	jsl $02ACE5|!base3
+	
	lda #$0A
	sta $1DF9|!base2
	jmp clean_ram