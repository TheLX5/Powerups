if !dynamic_items == 1
	lda $02806F|!bank
	sta $00
	lda $028070|!bank
	sta $01
	lda $028071|!bank
	sta $02
	jml [!dp]
else	
	rtl
endif