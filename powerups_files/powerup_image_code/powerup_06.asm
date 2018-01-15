;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Super Leaf (Super Mario Bros. 3)
;; 
;; Gives Mario a pair of ears and a raccoon tail
;; You can fly for a short period of time.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	ldx $13F3|!base2
	bne .tail
	lda !timer
	sec
	sbc #$04
	beq .no_spin
	bmi .no_spin
	lsr #2
	and #$03
	sta $00
	lda !power_ram
	asl #2
	and #$04
	clc
	adc $00
	tax
	lda.w .pose,x
	sta $13E0|!base2
	lda .turn,x
	sta $76
	bra .tail
.no_spin
	cmp #$FD
	bne .tail
	lda !power_ram
	sta $76
.tail	
	ldx $13E0|!base2
	lda $76
	clc
	ror #3
	ora .settings,x
	sta !extra_tile_flag
	lda .tile,x
	sta !extra_tile_frame

	lda !timer
	beq .no_spin_tail
	lsr #2
	and #$01
	beq +
	lda #$02
	sta !extra_tile_frame
	bra .no_anim
+	
	lda #$04
	sta !extra_tile_frame
	bra .no_anim
.no_spin_tail
	lda $77
	and #$04
	bne .no_anim
	lda $7D
	bmi .no_floor
	lda $74
	ora $13E3|!base2
	ora $13F3|!base2
	bne .no_floor
	lda $14
	lsr #3
	and #$01
	beq +
	lda #$0C
	sta !extra_tile_frame
	bra .no_floor
+	
	lda #$02
	sta !extra_tile_frame
.no_floor
	lda !power_ram+1
	beq .no_anim
	dec
	sta !power_ram+1
	lsr #2
	and #$03
	tax
	lda .hover_anim,x
	sta !extra_tile_frame
.no_anim	
	txa
	asl
	tax
	rep #$20
	lda .offset_y,x
	sta !extra_tile_offset_y
	sep #$20
	ldy $76
	bne +
	txa
	clc
	adc.b #($47*2)
	tax
+	
	rep #$20
	lda .offset_x,x
	sta !extra_tile_offset_x
	sep #$20
	lda $13F3|!base2
	beq +
	rep #$20
	lda #$0000
	sta !extra_tile_offset_x
	sep #$20
	lda #$0A
	sta !extra_tile_frame
+	
	rts

.offset_x
	dw $FFF8,$FFF8,$FFF8,$FFF8,$FFF8,$FFF8,$FFF8,$FFF8
	dw $FFF8,$FFF8,$FFF8,$FFF8,$FFF8,$FFF8,$FFF8,$0000
	dw $FFF2,$FFF2,$FFF2,$FFF2,$FFF8,$0000,$FFF8,$FFF8
	dw $FFF8,$FFF8,$FFF8,$FFF8,$FFF8,$FFF8,$0000,$0000
	dw $FFF6,$FFF8,$0000,$0000,$FFF8,$0000,$0000,$FFF6
	dw $FFF6,$FFF6,$0000,$0000,$0000,$0000,$0000,$0000
	dw $FFF8,$FFF8,$FFF8,$FFF8,$FFF8,$FFF8,$FFF8,$FFF8
	dw $0000,$0000,$FFF8,$FFF8,$FFF8,$FFF8,$0000,$FFF8
	dw $FFF8,$FFF8,$0000,$0000,$0000,$0000,$FFF8

	dw $0008,$0008,$0008,$0008,$0008,$0008,$0008,$0008
	dw $0008,$0008,$0008,$0008,$0008,$0008,$0008,$0000
	dw $000E,$000E,$000E,$000E,$0008,$0000,$0008,$0008
	dw $0008,$0008,$0008,$0008,$0008,$0008,$0000,$0000
	dw $000A,$0008,$0000,$0000,$0008,$0000,$0000,$000A
	dw $000A,$000A,$0000,$0000,$0000,$0000,$0000,$0000
	dw $0008,$0008,$0008,$0008,$0008,$0008,$0008,$0008
	dw $0000,$0000,$0008,$0008,$0008,$0008,$0000,$0008
	dw $0008,$0008,$0000,$0000,$0000,$0000,$0008
.offset_y
	dw $0012,$0012,$0012,$0012,$0012,$0012,$0012,$0012
	dw $0012,$0012,$0012,$0012,$0012,$0012,$0012,$0012
	dw $0018,$0024,$0024,$0024,$0012,$0012,$0012,$0012
	dw $0012,$0012,$0012,$0012,$0012,$0012,$0012,$0012
	dw $0012,$0012,$0012,$0012,$0012,$0012,$0012,$0012
	dw $0012,$0012,$0012,$0012,$0012,$0012,$0012,$0012
	dw $0012,$0012,$0012,$0012,$0012,$0012,$0012,$0012
	dw $0012,$0012,$0012,$0012,$0012,$0012,$0012,$0012
	dw $0012,$0012,$0012,$0016,$0012,$0012,$0012
.tile	
	db $00,$02,$00,$00,$00,$02,$00,$00
	db $02,$00,$00,$00,$02,$04,$00,$0A
	db $04,$08,$08,$08,$00,$0A,$00,$00
	db $02,$02,$00,$00,$0C,$00,$0A,$04
	db $00,$04,$0A,$0A,$00,$0A,$0A,$00
	db $00,$00,$00,$00,$00,$00,$00,$00
	db $0C,$0C,$00,$00,$00,$00,$00,$00
	db $0A,$0A,$00,$00,$00,$00,$00,$00
	db $00,$00,$0A,$0A,$0A,$0A,$00
.settings
	db $01,$01,$01,$01,$01,$01,$01,$01
	db $01,$01,$01,$01,$01,$01,$01,$01
	db $01,$01,$01,$01,$01,$11,$01,$01
	db $01,$01,$01,$01,$01,$01,$11,$11
	db $01,$01,$01,$01,$01,$11,$01,$01
	db $01,$01,$00,$00,$00,$00,$00,$00
	db $01,$01,$01,$01,$01,$01,$01,$01
	db $11,$11,$01,$01,$01,$00,$00,$01
	db $01,$01,$01,$01,$11,$01,$01

.hover_anim
	db $02,$04,$02,$06
.pose
	db $00,$25,$00,$0F
	db $00,$0F,$00,$25
.turn	
	db $00,$00,$01,$01
	db $01,$01,$00,$00


