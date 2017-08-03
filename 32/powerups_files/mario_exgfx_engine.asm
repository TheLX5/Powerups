if !dynamic_z = 0
mario_exgfx:
	lda !gfx_bypass_flag		;check if you there is another gfx due to be loaded
	beq .no_bypass_everything
	rep #$20
	lda !gfx_bypass_num		;load mario's gfx
	bra .bypass_everything
.no_bypass_everything
	lda #$00
	ldx $0DB3|!base2		;check if player = luigi
	beq .not_luigi
	lda #!max_powerup+$01
.not_luigi
	clc
	adc $19
	tax
	rep #$20
	lda.l GFXData,x			;get the correct powerup data
.bypass_everything
	rep #$10
	sta $02
	and #$007F
	sta $00
	asl
	clc
	adc $00
	tax				;multiply data*3
	lda.l PowerupGFX,x
	sta !gfx_pointer
	sta !get_32+2
	sep #$20
	lda.l PowerupGFX+2,x
	sta !gfx_pointer+2		;store info in pointers
	sep #$10
	
	ldx #$00			;check if using a 32*32 player
	lda $02
	and #$80
	sta !get_32
	beq .normal_upload


	rep #$20
	lda $09
	clc
	adc !gfx_pointer
	and #$0300
	sec
	ror
	pha

	lda $09
	clc
	adc !gfx_pointer
	and #$3C00
	asl
	ora $01,s
	sta $0D85|!base2
	lda !gfx_pointer+2
	and #$00FF
	tay
	bit $09
	bvc +
	iny
+	
	sty $0D87|!base2
	tya
	pla
	jmp .skip

.normal_upload
	rep #$20
	lda $09
	ora #$0800
	cmp $09
	beq $01
	clc
	and #$F700
	ror
	lsr
	adc !gfx_pointer
	sta $0D85|!base2
	clc
	adc #$0200
	sta $0D8F|!base2
	
	ldx #$00
	lda $0A
	ora #$0800
	cmp $0A
	beq $01
	clc
	and #$F700
	ror
	lsr
	adc !gfx_pointer
	sta $0D87|!base2
	clc
	adc #$0200
	sta $0D91|!base2

.skip

	lda $0B
	and #$FF00
	lsr #3
	adc !gfx_pointer
	sta $0D89|!base2
	clc
	adc #$0200
	sta $0D93|!base2

	lda $0C
	and #$FF00
	lsr #3
	adc #$2000
	sta $0D99|!base2
	sep #$20
	lda #$0A
	sta $0D84|!base2
	jml $00F69E|!base3
endif