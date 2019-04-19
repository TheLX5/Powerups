init:	
	lda $0DAE|!addr
	bne end_init
	
if !dynamic_items == 1
	ldy $0DC2|!addr
	lda.b #read1($02802D|!bank)
	dec
	sta $00
	lda.b #read1($02802E|!bank)
	sta $01
	lda.b #read1($02802F|!bank)
	sta $02
	lda [$00],y
	xba
	rep #$20
	and #$FF00
	lsr #3
	adc.w #read2($00A38B|!bank)
	sta !item_gfx_pointer+4
	clc
	adc #$0200
	sta !item_gfx_pointer+10
	sep #$20
	lda !item_gfx_refresh
	ora #$10
	sta !item_gfx_refresh
endif

	lda #$FF
	sta !item_gfx_oldest
	sta !item_gfx_latest

	lda $86
	sta !slippery_flag_backup

.init_cloud_data
	lda $19
	cmp #!cloud_flower_powerup_num
	bne +

	rep #$30
	phx
	ldx #$006C
-	
	lda $94
	sta.l !collision_data_x,x
	lda $96
	sta.l !collision_data_x+2,x
	dex #4
	bpl -
	plx
	sep #$30

+	

if !gfx_compression == 1
	jsl decompress_gfx
endif
end_init:

	rtl