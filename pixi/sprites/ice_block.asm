incsrc ../powerup_defs.asm

; $C2		format: -----ssa
;		ss = size; 00 = 16x16, 01 = 32x16, 10 = 16x32, 11 = 32x32
;		a = in air flag
; $7FAB28	format: ecpnmssi
;		e = empty flag
;		c = custom sprite flag (unused)
;		p = never disappear (permafrost)
;		n = never fall (if it's in air) (unused)
;		m = can't be carried flag
;		ss = size, see above
;		i = show global image (unused)

	!carry_flag		= !1510
	!ice_block_size		= !C2
	!inside_settings	= !7FAB28
	!sprite_dir		= !157C
	!sprite_timer		= !1540
	!sprite_interaction	= !154C

	!update_y_pos		= $01801A|!BankB	;update Y position without gravity
	!update_x_pos		= $018022|!BankB	;update X position without gravity
	!update_gravity		= $01802A|!BankB	;update positions with gravity
	!block_interact		= $019138|!BankB	;get $1588 info
	!get_sprite_clip_a	= $03B69F|!BankB	;get clipping A
	!get_sprite_clip_b	= $03B6E5|!BankB	;get clipping B
	!get_player_clip	= $03B664|!BankB	;get mario clipping
	!check_contact		= $03B72B|!BankB	;check contact
	!finish_oam		= $01B7B3|!BankB	;finish oam routine in $03Xx area
	!show_contact		= $01AB6F|!BankB

;	lda !inside_settings,x
;	asl #2
;	bcc .normal_sprite
;.normal_sprite
	
block_layer:
	db $00,$01,$0E,$0E
block_width:
	db $11,$11,$21,$21
block_height:
	db $11,$21,$11,$21
block_size:
	db $00,$10,$01,$11
block_bottom_width:
	db $0C,$0C,$1C,$1C
block_bottom_y_lo_disp:
	db $12,$22,$12,$12
block_bottom_y_hi_disp:
	db $00,$00,$00,$00

block_carry_x_disp:
	dw $0000,$0000,$0010,$0010
block_carry_y_disp:
	dw $0000,$0010,$0000,$0000
data_019F5B:
	db $0B,$F5,$04,$FC,$04,$00 
data_019F61:
	db $00,$FF,$00,$FF,$00,$00

data_019F67:
	db $F3,$0D
data_019F69:
	db $FF,$00
kick_speed:
	db $D2,$2E,$CC,$34
	db $E0,$20,$DE,$22
	db $E0,$20,$DE,$22
	db $E2,$1E,$E0,$20
data_019F99:
	db $FC,$04

	

print "INIT ",pc
Init:
	phb
	phk
	plb
	lda #$FF
	sta !1540,x
	lda !inside_settings,x
	and #$06
	sta !C2,x
	lsr
	tay
	lda block_layer,y
	sta !1656,x
	jsr graphics
	plb
	rtl

print "MAIN ",pc
	phb
	phk
	plb
	lda $9D
	bne +
	jsr main
+	
	jsr graphics
	lda #$03
	%SubOffScreen()
	plb
	rtl

main:
	lda !inside_settings,x
	and #$20
	beq .no_permafrost
	lda #$FF
	sta !sprite_timer,x
.no_permafrost
	lda !sprite_timer,x
	bne .no_shatter
	lda #$02
	sta !14C8,x
.no_shatter

actual_main:
	lda !14C8,x
	jsl $0086DF|!BankB
	dw Return
	dw Return
	dw Killed
	dw Return
	dw Return
	dw Return
	dw Return
	dw Return
	dw Normal
	dw Normal
	dw Kicked
	dw Carried
	dw Return
Return:	
	lda !7FAB34,x
	and #$7F
	sta !7FAB34,x
	rts

Killed:
	lda #!ice_block_break_sfx
	sta !ice_block_break_port|!Base2
	lda !ice_block_size,x
	lsr
	and #$03
	tay
	lda !inside_settings,x
	bpl .sprite_inside
	stz !14C8,x
	bra .no_sprite_inside
.sprite_inside
	lda #$21
	sta !9E,x
	lda #$00
	sta !7FAB10,x
	lda !15A0,x
	pha 
	lda !186C,x
	pha
	lda !157C,x
	pha
	jsl $07F7D2|!BankB
	pla
	sta !157C,x
	pla
	sta !186C,x
	pla
	sta !15A0,x
	lda #$08
	sta !14C8,x
	lda #$D8
	sta !AA,x
	stz !B6,x
	lda #$20
	sta !154C,x
.no_sprite_inside
	lda !E4,x
	clc
	adc coin_x_disp,y
	sta !E4,x
	lda !14E0,x
	adc #$00
	sta !14E0,x
	lda !D8,x
	clc
	adc coin_y_disp,y
	sta !D8,x
	lda !14D4,x
	cpy #$03
	beq +
	adc #$00
	bra ++
+	
	adc #$FF
++	
	sta !14D4,x
	
	lda !15A0,x
	ora !186C,x
	bne .offscreen
	lda !E4,x
	sta $9A
	lda !14E0,x
	sta $9B
	lda !D8,x
	sta $98
	lda !14D4,x
	sta $99
	phb
	lda.b #$02|(!BankB/$10000)
	pha
	plb
	lda #$FF
	jsl $028663|!BankB
	plb
.offscreen
	rts

Carried:
	jsl !block_interact
	jsr extra_interaction
	stz !AA,x
	lda $76
	eor #$01
	sta !sprite_dir,x
	lda $71
	cmp #$01
	bcc +
	lda $1419|!Base2
	bne +
	lda #$09
	sta !14C8,x
	rts
+	
	jsr sprite_contact_carried
	lda $1419|!Base2
	bne code_01A011
	bit $15
	bvc code_01A015
code_01A011:
	jmp offset_fix
	

code_01A015:
	stz !1626,x
	lda #$09
	sta !14C8,x
	lda $15
	and #$08
	bne code_01A068
	lda $15
	and #$04
	beq code_01A079
	

	lda !ice_block_size,x
	and #$06
	tay
	rep #$20
	stz $04
	ldx $76
	bne +
	lda block_carry_x_disp,y
	sta $04
+	
	lda block_carry_y_disp,y
	sta $06
	sep #$20
	ldx $15E9|!Base2

	ldy $76
	lda $D1
	clc
	adc data_019F67,y
	sta !E4,x
	lda $D2
	adc data_019F69,y
	sta !14E0,x

	lda !E4,x
	sec
	sbc $04
	sta !E4,x
	lda !14E0,x
	sbc $05
	sta !14E0,x
	
	%SubHorzPos()
	lda data_019F99,y
	clc
	adc $7B
	sta !B6,x
	stz !AA,x
	bra code_01A0A6


code_01A068:
	jsl !show_contact
	lda #$90
	sta !AA,x
	lda $7B
	sta $B6,x
	asl
	ror $B6,x
	bra code_01A0A6

code_01A079:
	lda #$0A
	sta !14C8,x
	jsl !show_contact
	ldy $76
	lda $187A|!Base2
	beq $02
	iny #2
	lda !ice_block_size,x
	lsr
	and #$03
if !SA1 == 1
	sta $2251
	lda #$04
	sta $2253
	stz $2250
	stz $2252
	stz $2254
	nop #3
	tya
	clc
	adc $2306
else
	sta $4202
	lda #$04
	sta $4203
	nop #3
	tya
	clc
	adc $4216
endif	
	tay
	lda kick_speed,y
	sta !B6,x
	eor $7B
	bmi code_01A0A6
	lda $7B
	sta $00
	asl $00
	ror
	clc
	adc kick_speed,y
	sta !B6,x

code_01A0A6:
	lda #$10
	sta !154C,x
	lda #$0C
	sta $149A|!Base2
	rts




Kicked:	
	lda $9D
	ora !163E,x
	beq +
	rts
+	
	lda #$00
	ldy !B6,x
	beq +
	bpl ++
	inc
++	
	sta !157C,x
+	
	lda !164A,x
	beq +
	jsr .liquids
+	
	lda !15B8,x
	pha
	jsl !update_gravity
	jsr extra_interaction
	pla
	beq +
	sta $00
	ldy !164A,x
	bne +
	cmp !1528,x
	beq +
	eor !B6,x
	bmi +
	lda #$F8
	sta !AA,x
	bra ++
+	
	lda !1588,x
	ora !1504,x
	and #$04
	beq ++
	lda #$10
	sta !AA,x
++	
	lda !1588,x
	ora !1504,x
	and #$0B
	beq +
	jsr block_side
+	
	jsr sprite_contact
	jmp block_interaction

.liquids
	dec !AA,x
	lda $14
	and #$08
	beq +
	dec !AA,x
+	
	lda !B6,x
	beq +
	bmi ++
	dec !B6,x
+	
	rts
++	
	inc !B6,x
	rts

block_side:
	lda #$01
	sta $1DF9|!Base2
	lda !15A0,x
	bne +
	lda !E4,x
	sec
	sbc $1A
	clc
	adc #$14
	cmp #$1C
	bcc +
	lda !1588,x
	ora !1504,x
	and #$40
	asl #2
	rol
	and #$01
	sta $1933|!Base2
	ldy #$00
	lda $18A7|!Base2
	jsl $00F160|!BankB
	lda #$05
	sta !1FE2,x
+	
	lda #$02
	sta !14C8,x
	rts



Normal:
	lda !14C8,x
	cmp #$08
	beq .next
	lda !1588,x
	ora !1504,x
	and #$0B
	beq .end
	lda #$02
	sta !14C8,x
.end	
.next
	lda !164A,x
	beq .outside_water
	jsr .liquids
	lda !1588,x
	ora !1504,x
	and #$0B
	beq .apply_gravity
	lda #$02
	sta !14C8,x
	bra .end_gravity

.outside_water
	lda !154C,x
	beq .fall
	lda !carry_flag,x
	bne .check_floor
.zero_gravity
	lda #$FF
	sta !1540,x
.zero_gravity_2
	stz !AA,x
	jsl !update_x_pos
	jsl !update_y_pos
	bra .end_gravity
.fall
	lda !C2,x
	lsr
	bcc .check_floor
	lda !carry_flag,x
	beq .zero_gravity_2
.check_floor
	lda !1588,x
	ora !1504,x
	and #$04
	beq .apply_gravity
	lda !carry_flag,x
	beq .no_floors
-	
	lda #$02
	sta !14C8,x
	bra .apply_gravity
.no_floors
	lda !154C,x
	beq -
.apply_gravity
	jsl !update_gravity
	jsr extra_interaction
.end_gravity
	jsr sprite_contact
	jmp block_interaction
	rts


.liquids
	dec !AA,x
	lda $14
	and #$08
	beq +
	dec !AA,x
+	
	lda !B6,x
	beq +++
	bmi ++
	dec !B6,x
+++
	rts
++	
	inc !B6,x
	rts

extra_interaction:
	lda !C2,x
	and #$06
	cmp #$06
	bne .end
	lda !1588,x
	pha
	lda !sprite_x_low,x
	pha
	lda !sprite_x_high,x
	pha
	lda !sprite_y_low,x
	pha
	sec
	sbc #$10
	sta !sprite_y_low,x
	lda !sprite_y_high,x
	pha
	sbc #$00
	sta !sprite_y_high,x

	jsl $019138|!BankB
	lda !1588,x
	sta !1504,x
	
	pla
	sta !sprite_y_high,x
	pla
	sta !sprite_y_low,x
	pla
	sta !sprite_x_high,x
	pla
	sta !sprite_x_low,x
	pla
	sta !1588,x
.end	
	rts

block_interaction:
	lda !14C8,x
	cmp #$08
	beq .process
	lda !154C,x
	beq .process
	jmp skip_dir
.process
	lda !ice_block_size,x
	lsr
	and #$03
	tay
	cpy #$03
	bne +
	lda !D8,x
	pha
	sec
	sbc #$10
	sta !D8,x
	lda !14D4,x
	pha
	sbc #$00
	sta !14D4,x
+	
	phy
	lda block_size,y
	%SolidSprite()
	ply
	cpy #$03
	bne +
	sta $8A
	pla
	sta !14D4,x
	pla
	sta !D8,x
+	
	lda $8A
	beq skip
	lsr 
	bcs top
	lsr
	bcs bottom	
	and #$03
	bne sides
	lda $8A
	and #$C0
	beq skip
	cpy #$03
	beq top
	jmp wall_contact
skip:
	jmp skip_dir
bottom:
	lda $8A
	and.b #%00001101
	bne skip
	jmp wall_contact
top:	
	lda !164A,x
	beq .no_liquids
	inc !AA,x
	inc !AA,x
.no_liquids
sides:
	lda !inside_settings,x
	and #$08
	bne skip_dir

	lda $148F|!Base2
	ora $1470|!Base2
	bne nope

	jsr get_ice_block_clip
	jsl !get_player_clip
	jsl !check_contact
	bcc skip_dir

	lda $187A|!Base2
	bne nope

	bit $15
	bvc nope

	lda #$0B
	sta !14C8,x
	lda #$01
	sta !carry_flag,x
	bra skip_dir
skip_dir:
nope:	
	rts

wall_contact:
	lda #$02
	sta !14C8,x
	rts


graphics:
	lda $13
	and #$1F
	ora $9D
;	phk
;	pea .ice_block_spark-1
;	pea $80C9
;	jml $01B152|!BankB
.ice_block_spark
	%GetDrawInfo()
	lda !ice_block_size,x
	lsr
	and #$03
	sta $09
if !SA1 == 1
	sta $2251
	lda #$05
	sta $2253
	stz $2250
	stz $2252
	stz $2254
	nop #4
	lda $2306
else
	sta $4202
	lda #$05
	sta $4203
	nop #4
	lda $4216
endif	
	sta $02
	
	lda !15F6,x
	ora $64
	sta $03

	ldx #$03
	stx $04
-	
	phx
	txa
	clc
	adc $02
	tax
	lda $00
	clc
	adc x_disp,x
	sta $0300|!Base2,y
	lda $01
	clc
	adc y_disp,x
	sta $0301|!Base2,y
	lda ice_tiles,x
	sta $0302|!Base2,y
	lda ice_props,x
	ora $03
	sta $0303|!Base2,y
	phy
	tya
	lsr #2
	tay
	lda size,x
	sta $0460|!Base2,y
	ply
	plx
	iny #4
	dex
	bpl -
	ldx $15E9|!Base2
	lda !inside_settings,x
	bmi .no_sprite_inside
	ldx $09
	lda $00
	clc
	adc coin_x_disp,x
	sta $0300|!Base2,y
	lda $01
	clc
	adc coin_y_disp,x
	sta $0301|!Base2,y
	lda #$E8
	sta $0302|!Base2,y
	lda #$04
	ora $64
	sta $0303|!Base2,y
	tya
	lsr #2
	tay
	lda #$02
	sta $0460|!Base2,y
	ldx $15E9|!Base2
	lda #$05
	bra .coin_inside
.no_sprite_inside
	lda #$04
.coin_inside
	ldy #$FF
	jsl $01B7B3|!BankB
	rts



x_disp:
	db $00,$08,$00,$08,$04
	db $00,$02,$02,$00,$02
	db $00,$10,$00,$10,$10
	db $00,$10,$00,$10,$0C
y_disp:
	db $00,$00,$08,$08,$04
	db $00,$00,$10,$10,$09
	db $00,$00,$02,$02,$02
	db $F0,$F0,$00,$00,$FC
ice_tiles:
	db $48,$4A,$4A,$48,$69
	db $48,$4A,$4A,$48,$7F
	db $48,$4A,$4A,$48,$7F
	db $48,$4A,$4A,$48,$7F
ice_props:
	db $00,$40,$80,$C0,$00
	db $00,$40,$C0,$80,$00
	db $00,$40,$80,$C0,$00
	db $00,$40,$80,$C0,$00
size:
	db $00,$00,$00,$00,$00
	db $02,$02,$02,$02,$00
	db $02,$02,$02,$02,$00
	db $02,$02,$02,$02,$00
coin_x_disp:
	db $00,$01,$08,$08
coin_y_disp:
	db $00,$08,$01,$F8


block_y_lo_disp:
	db $02,$02,$02,$12

offset_fix:
	lda !ice_block_size,x
	and #$06
	tay
	rep #$20
	stz $04
	ldx $76
	bne +
	lda block_carry_x_disp,y
	sta $04
+	
	lda block_carry_y_disp,y
	sta $06
	sep #$20
	ldx $15E9|!Base2

	ldy #$00
	lda $76
	bne +
	iny
+	
	lda $1499|!Base2
	beq +
	iny #2
	cmp #$05
	bcc +
	iny
+	
	lda $1419|!Base2
	beq +
	cmp #$02
	beq ++
+	
	lda $13DD|!Base2
	ora $74
	beq +
++	
	ldy #$05
+	
	phy
	ldy #$00
	lda $1471|!Base2
	cmp #$03
	beq +
	ldy #$3D
+	
	lda $0094|!Base1,y
	sec
	sbc $04
	sta $00
	lda $0095|!Base1,y
	sbc $05
	sta $01
	lda $0096|!Base1,y
	sec
	sbc $06
	sta $02
	lda $0097|!Base1,y
	sbc $07
	sta $03
	ply
	lda $00
	clc
	adc data_019F5B,y
	sta !E4,x
	lda $01
	adc data_019F61,y
	sta !14E0,x
	lda #$0D
	ldy $73
	bne +
	ldy $19
	bne ++
+	
	lda #$0F
++	
	ldy $1498|!Base2
	beq +
	lda #$0F
+	
	clc
	adc $02
	sta !D8,x
	lda $03
	adc #$00
	sta !14D4,x

	lda #$01
	sta $148F|!Base2
	sta $1470|!Base2
	rts

get_ice_block_clip:
	phy
	lda !ice_block_size,x
	lsr
	and #$03
	tay
	lda !E4,x
	sec
	sbc #$01
	sta $04
	lda !14E0,x
	sbc #$00
	sta $0A
	lda !D8,x
	sec
	sbc block_y_lo_disp,y
	sta $05
	lda !14D4,x
	sbc #$00
	sta $0B
	lda block_width,y
	sta $06
	lda block_height,y
	sta $07
	ply
	rts


sprite_contact_carried:
sprite_contact:
	txa
	beq .return
	tay
	eor $13
	lsr
	bcc .return
	ldx.b #!SprSize-1
.loop	
	cpx $15E9|!Base2
	beq .next
	lda !14C8,x
	cmp #$08
	bcs .found
.next	
	dex
	bpl .loop
.return	
	ldx $15E9|!Base2
	rts

.found	
	lda !1686,x
	ora !1686,y
	and #$08
	ora !1564,x
	ora !1564,y
	ora !1632,x
	eor !1632,y
	ora !15D0,x
	bne .next
	
	stx $1695|!Base2
	lda !E4,x
	sec
	sbc.w !E4,y
	sta $00
	lda !14E0,x
	sbc !14E0,y
	sta $01
	
	lda.w !ice_block_size,y
	and #$06
	sta $0F
	cmp #$04
	bcs .size_32
+	
	rep #$20
	lda $00
	clc
	adc #$0010
	cmp #$0020
	sep #$20
	bcs .next
	bra .vert
.size_32	
	lda !157C,y
	bne .left
	rep #$20
	lda $00
	cmp #$0020
	sep #$20
	bcs .next
	bra .vert
.left	
	rep #$20
	lda $00
	clc
	adc #$0010
	cmp #$0020
	sep #$20
	bcs .next
	
.vert	
	ldy #$00
	lda !1662,x
	and #$0F
	beq +
	iny
+	
	lda !D8,x
	clc
	adc.w data_01A40B,y
	sta $00
	lda !14D4,x
	adc #$00
	sta $01
	
	ldy $15E9|!Base2
.vert_16
	lda.w !D8,y
	sta $04
	lda !14D4,y
	sta $05
	lda $0F
	cmp #$06
	bne .not_32x32
	rep #$20
	lda $04
	sec
	sbc #$0030
	sta $02
	sep #$20
	bra +
.not_32x32
	cmp #$02
	bne .not_16x32
	rep #$20
	lda $04
	sec
	sbc #$0020
	sta $02
	sep #$20
	bra +
.not_16x32
	ldx #$00
	lda $04
	clc
	adc.w data_01A40B,x
	sta $02
	lda $05
	adc #$00
	sta $03
+
	ldx $1695|!Base2
	lda $0F
	cmp #$06
	bne +
-
	rep #$20
	lda $00
	sec
	sbc $02
	sec
	sbc #$0020
	cmp #$0020
	bra ++
+	
	cmp #$02
	beq -
	rep #$20
	lda $00
	sec
	sbc $02
	clc
	adc #$000C
	cmp #$001A
++	
	sep #$20
	bcs .no_interacts
	
	phb
	lda.b #$01|(!BankB/$10000)
	pha
	plb
	phk
	pea .no_interact-1
	pea $80C9
	jml $01A4BA|!BankB
.no_interact
	plb
.no_interacts
	jmp .next

data_01A40B:
	db $02,$0A
data_01A40B_2:
	db $0C,$1E
	db $1E