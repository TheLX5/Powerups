!buffer_size		= $0030
!buffer_inc		= $0004
!buffer_separation	= $0004
	wdm

	lda #$03
	sta !extra_tile_flag
	rep #$20
	lda !misc
	clc
	adc #!buffer_separation
	cmp #!buffer_size
	bcc +
	sec
	sbc #!buffer_size
+	
	tax
	lda.l !collision_data_x,x
	sec
	sbc $94
	sta !extra_tile_offset_x
	lda.l !collision_data_x+2,x
	sec
	sbc $96
	clc
	adc #$000A
	sta !extra_tile_offset_y
	sep #$20
	
	lda $14
	lsr #2
	and #$03
	tax
	lda !flags
	beq .small_anim
	lda.l .big_frames,x
	bra .store_anim
.small_anim
	lda.l .small_frames,x 
.store_anim
	sta !extra_tile_frame

.circular_buffer_update
	rep #$20
	lda !misc
	sec
	sbc #!buffer_inc
	clc
	adc.w #!buffer_size-!buffer_inc
	cmp #!buffer_size
	bcc .transfer
	sec
	sbc #!buffer_size
.transfer
	tax
	lda $94
	cmp !collision_data_x,x
	bne .buffer_cycle_2
	lda $96
	cmp.l !collision_data_x+2,x
	bne .buffer_cycle_2
	sep #$20
	rts
.buffer_cycle_2
	lda !misc
	clc
	adc #!buffer_inc
	cmp #!buffer_size
	bcc .transfer_2
	sec
	sbc #!buffer_size
.transfer_2
	tax
	lda $94
	sta !collision_data_x,x
	lda $96
	sta.l !collision_data_x+2,x
	lda !misc
	clc
	adc.w #!buffer_inc
	cmp.w #!buffer_size
	bne .fix_index
	lda #$0000
.fix_index
	sta !misc
	sep #$20
	rts

.big_frames
	db $00,$02,$04,$06
.small_frames
	db $08,$0A,$0C,$0A