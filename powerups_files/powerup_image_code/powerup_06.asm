;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Super Leaf (Super Mario Bros. 3)
;; 
;; Gives Mario a pair of ears and a raccoon tail
;; You can fly for a short period of time.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	lda $13F3|!base2
	ora $74
	ora $73
	ora $71
	ora $187A|!base2
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
	lda #$01		;used to prevent player from
	sta $13DB|!base2	;"jittering" during tail-attack
	bra .tail		;while walking (stz didn't work well)
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

	lda $187A|!base2	;check if player riding yoshi
	cmp #$01		;AND if they aren't turning while
	bne .no_floor		;on yoshi
	phx
	ldx $13DB|!base2	;player walk frames
	lda.w .tail_yoshi,x	;load tail anims while on yoshi
	ldx $18DC|!base2	;check crouching on yoshi
	beq +
	lda #$02
+	sta !extra_tile_frame
	plx
;	lda !timer
;	beq .no_spin_tail
;	lsr #2
;	and #$01
;	beq +
;	lda #$02
;	sta !extra_tile_frame
;	bra .no_anim
;+	
;	lda #$04
;	sta !extra_tile_frame
;	bra .no_anim
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
;	lda $14
;	lsr #3
;	and #$01
;	beq +
;	lda #$0C
;	sta !extra_tile_frame
;	bra .no_floor
;+	
;	lda #$02
;	sta !extra_tile_frame
.no_floor
	lda !power_ram+1
	beq .no_anim
	dec
	sta !power_ram+1
	lsr #2
	and #$03
	phx
	tax
	lda .hover_anim,x
	sta !extra_tile_frame
	plx
.no_anim
	txa
	asl
	tax
	rep #$30
	lda .offset_y,x
	sta !extra_tile_offset_y
	lda $76
	and #$00FF
	bne +
	txa
	clc
	adc.w #(.offset_x_end-.offset_x)
	tax
+	
	lda .offset_x,x
	sta !extra_tile_offset_x
	sep #$30
	rts

.offset_x
	dw $FFF9,$FFFA,$FFF9,$FFF9,$FFF9,$FFF9,$FFF9,$FFF9
	dw $FFFA,$FFF9,$FFF9,$FFF9,$FFF9,$FFF8,$FFF9,$0000
	dw $FFF7,$FFFA,$FFFA,$FFFA,$FFF9,$0000,$FFF9,$FFF9
	dw $FFF9,$FFF9,$FFF9,$FFF9,$FFF8,$FFF7,$0002,$FFFA
	dw $FFF8,$FFFC,$0000,$0000,$FFF9,$0000,$0000,$FFF8
	dw $FFF8,$FFF8,$0000,$0000,$0000,$0000,$0000,$0000
	dw $FFF8,$FFF8,$FFF8,$FFF9,$FFF9,$FFFC,$FFFA,$FFF7
	dw $0000,$0000,$FFF8,$FFF8,$FFF7,$FFF8,$0000,$FFF8
	dw $FFF8,$FFF8,$0000,$0000,$0000,$0000
	dw $0000
	dw $FFF8,$0000,$0000
..end
	dw $0007,$0006,$0007,$0007,$0007,$0007,$0007,$0007
	dw $0006,$0007,$0007,$0007,$0007,$0008,$0007,$0000
	dw $000A,$0007,$0007,$0007,$0007,$0000,$0007,$0007
	dw $0007,$0007,$0007,$0007,$0008,$0009,$FFFE,$0006
	dw $0008,$0004,$0000,$0000,$0007,$0000,$0000,$0008
	dw $0008,$0008,$0000,$0000,$0000,$0000,$0000,$0000
	dw $0008,$0008,$0008,$0007,$0007,$0004,$0006,$0009
	dw $0000,$0000,$0008,$0008,$0009,$0008,$0000,$0008
	dw $0008,$0008,$0000,$0000,$0000,$0000
	dw $0000
	dw $0008,$0000,$0000
.offset_y
	dw $0010,$0010,$0010,$0010,$0010,$0010,$0010,$0010
	dw $0010,$0010,$0010,$0010,$0010,$0011,$0010,$0011
	dw $0015,$001F,$001F,$001F,$0011,$0011,$0010,$0010
	dw $0010,$0010,$0010,$0010,$0011,$0013,$0011,$0011
	dw $0011,$0011,$0011,$0011,$0011,$0011,$0011,$0010
	dw $0011,$0011,$0012,$0012,$0012,$0012,$0012,$0012
	dw $0011,$0011,$0011,$0010,$0010,$0012,$0012,$0010
	dw $0011,$0011,$0012,$0012,$0014,$0012,$0012,$0010
	dw $0012,$0012,$0011,$0011,$0011,$0011
	dw $8000
	dw $0011,$0011,$0011
.tile	
	db $02,$08,$04,$02,$04,$04,$04,$02
	db $08,$04,$02,$04,$04,$22,$02,$0A
	db $00,$00,$00,$00,$02,$0A,$04,$04
	db $04,$04,$04,$04,$24,$28,$0A,$02
	db $02,$02,$0A,$0A,$04,$0A,$0A,$02
	db $02,$02,$00,$00,$00,$00,$00,$00
	db $20,$20,$02,$02,$02,$04,$02,$04
	db $0A,$0A,$00,$00,$26,$00,$00,$00
	db $00,$00,$0A,$0A,$0A,$0A
	db $00
	db $0C,$0E,$0E
..end
.settings
	db $01,$01,$01,$01,$01,$01,$01,$01
	db $01,$01,$01,$01,$01,$01,$01,$41
	db $01,$01,$01,$01,$11,$11,$01,$01
	db $01,$01,$01,$01,$01,$01,$51,$11
	db $11,$01,$41,$01,$01,$11,$01,$11
	db $11,$11,$00,$00,$00,$00,$00,$00
	db $01,$01,$01,$01,$01,$11,$11,$11
	db $11,$11,$01,$01,$01,$00,$00,$01
	db $01,$01,$41,$41,$11,$41
	db $00
	db $01,$11,$41

.hover_anim
	db $06,$04,$02,$02
.pose
	db $47,$48,$47,$49
	db $47,$49,$47,$48
.turn	
	db $00,$00,$01,$01
	db $01,$01,$00,$00
.tail_yoshi
	db $02,$08,$04

