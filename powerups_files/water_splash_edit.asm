fix_water_splash:
	phx
	ldx $19
	lda.l water_splash_disp,x
	beq +
	lda #$00
	sta $01,s
+	
	plx
	lda $96
	clc
	adc.l $00FD9D|!base3,x
	jml $00FDC9|!base3

water_splash_disp:
	db $00,$00,$00,$00,$00,$00,$00,$00	; powerups 0 - 7
	db $01,$00,$00,$01,$00,$00,$00,$00	; powerups 8 - F
	db $00,$00,$00				; powerups 10 - 12