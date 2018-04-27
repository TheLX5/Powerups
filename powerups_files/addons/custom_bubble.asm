!smoke_tile_1	= $64
!smoke_tile_2	= $62

bubble_hijack:	
		LDA	!190F,x
		AND	#$80
		BNE	.custom_bubble
		JML	$02D8AD|!base3

.custom_bubble
		PHB	
		PHK	
		PLB	
		JSR	bubble_main
		PLB	
		RTL	

bubble_main:
		JSR	.graphics_routine
		LDA	!14C8,x
		CMP	#$02
		BNE	.not_defeated
		LDA	#$08
		STA	!14C8,x
		JMP	.almost_pop
.ret
		RTS	
.not_defeated		
		LDA	$9D
		BNE	.ret
		LDA	$13
		AND	#$01
		BNE	.no_update_timer
		DEC	!1534,x
		LDA	!1534,x
		CMP	#$04
		BNE	.no_update_timer
		LDA	#$19
		STA	$1DFC|!base2
.no_update_timer	
		LDA	!1534,x
		DEC	
		BNE	.no_pop_bubble
		JMP	.pop_bubble
.no_pop_bubble		
		CMP	#$07
		BCC	.ret
	;sub_off_screen
	PHB	
	LDA.b	#$01|(!base3/$10000)
	PHA	
	PLB	
	PHK	
	PEA.w	.suboffscreen-1
	PEA.w	$80C9
	JML	$01AC2B|!base3
.suboffscreen		
	PLB	
	LDA	$14
	AND	#$01
	BNE	.no_update_x
	LDA	!B6,x
	BEQ	.zero_x
	BMI	.minus_x
	DEC	#2
.minus_x	
	INC	A
.zero_x
	STA	!B6,x
.no_update_x
		JSL	$018022|!base3
	;movement
		JSL	$01801A|!base3
	LDA	$14
	AND	#$03
	BNE	.no_accel
	LDA	!AA,x
	SEC	
	SBC	#$01
	CMP	#$F8
	BEQ	.no_accel
	STA	!AA,x
;	LDA	!151C,x
;	AND	#$01
;	TAY	
;	LDA	!AA,x
;	CLC	
;	ADC	y_accel,y
;	STA	!AA,x
;	CMP	y_max_spd,y
;	BNE	.no_accel
;	INC	!151C,x
.no_accel		
		JSL	$019138|!base3
		LDA	!1588,x
		BNE	.almost_pop
		JSL	$018032|!base3
		JSL	$01A7DC|!base3
		BCC	.return
		PHK	
		PEA.w	.sub_vert_pos-1
		PEA.w	$80C9
		JML	$01AD42|!base3
.sub_vert_pos		
		LDA	$0E
		CMP	#$E1
		BMI	.next
.check_side
		CPY	#$01
		BNE	.no_above
.next
	LDA	$0E
	CMP	#$EF
	BPL	.no_above
		JSL	$01AA33|!base3
		BRA	.almost_pop
.no_above		
		STZ	$7D
		STZ	$7B
.almost_pop
		LDA	!1534,x
		CMP	#$07
		BCC	.return
		LDA	#$06
		STA	!1534,x
.return			
		RTS	
.pop_bubble		
		LDA	#$08
		STA	!14C8,x
		LDA	#$21
		STA	!9E,x
		JSL	$07F7D2|!base3
		LDA	#$20
		STA	!154C,x
		;sub_horz_pos
		JSL	sub_horz_pos
		TYA	
		STA	!157C,x
		RTS	

.graphics_routine
		JSL	GetDrawInfo
		STZ	$05
		STZ	$06
		PHX	
		LDA	!1534,x
		CMP	#$60
		BCS	.continue
		AND	#$02
		BEQ	.skip_bubble
.continue		
		LDY	!15EA,x
		LDA	!1534,x
		STA	$03
		LDX	#$04
.loop			
		LDA	$00
		CLC	
		ADC.w	bubble_tile_disp_x,x
		STA	$0300|!base2,y
		LDA	$01
		CLC	
		ADC.w	bubble_tile_disp_y,x
		STA	$0301|!base2,y
		LDA.w	bubble_tilemap,x
		STA	$0302|!base2,y
		LDA	bubble_tile_props,x
		ORA	$64
		STA	$0303|!base2,y
		LDA	$03
		CMP	#$06
		BCS	.no_smoke
		CMP	#$03
		LDA	#$02
		ORA	$64
		STA	$0303|!base2,y
		LDA	#!smoke_tile_1
		BCS	$02
		LDA	#!smoke_tile_2
		STA	$0302|!base2,y
.no_smoke		
		PHY	
		TYA	
		LSR	#2
		TAY	
		LDA	bubble_tile_size,x
		STA	$0460|!base2,y
		PLY	
		INY	#4
		DEX	
		BPL	.loop
		LDA	#$05
		STA	$05
.skip_bubble		
		LDA	$00
		STA	$0300|!base2,y
		LDA	$01
		STA	$0301|!base2,y
		LDA	#$E8
		STA	$0302|!base2,y
		LDA	#$04
		ORA	$64
		STA	$0303|!base2,y
		LDA	$14
		LSR	#2
		AND	#$03
		BNE	.use_2_tiles
		LDX	#$02
		BRA	.finish_gfx
.use_2_tiles
		INC	$05
		TAX	
		LDA	$00
		CLC	
		ADC	#$04
		STA	$0300|!base2,y
		STA	$0304|!base2,y
		LDA	$01
		CLC	
		ADC	#$08
		STA	$0305|!base2,y
		LDA.l	$01C66C|!base3,x
		STA	$0302|!base2,y
		STA	$0306|!base2,y
		LDA	$0303|!base2,y
		ORA	#$80
		STA	$0307|!base2,y
		LDX	#$00
		PHY	
		INY	#4
		TYA	
		LSR	#2
		TAY	
		TXA	
		STA	$0460|!base2,y
		PLY	
.finish_gfx		
		TYA	
		LSR	#2
		TAY	
		TXA	
		STA	$0460|!base2,y
		PLX	
		LDY	#$FF
		LDA	$05
		JSL	$01B7B3|!base3
		RTS	

sub_horz_pos:
		LDY #$00
		LDA $D1
		SEC
		SBC !E4,x
		STA $0F
		LDA $D2
		SBC !14E0,x
		BPL +
		INY
+		RTL

x_speed:
	db $08,$F8
y_accel:
	db $01,$FF
y_max_spd:
	db $0C,$F4

bubble_tile_disp_x:
	db $F8,$08,$F8,$08,$01
	db $F9,$07,$F9,$07,$00
	db $FA,$06,$FA,$06,$00
bubble_tile_disp_y:
	db $F6,$F6,$06,$06,$FE
	db $F5,$F5,$03,$03,$FC
	db $F4,$F4,$04,$04,$FB
bubble_tilemap:
	db !big_bubble_tile,!big_bubble_tile,!big_bubble_tile,!big_bubble_tile
	db !big_bubble_shine_tile
bubble_tile_props:
	db !big_bubble_props,$40+!big_bubble_props,$80+!big_bubble_props
	db $C0+!big_bubble_props,!big_bubble_shine_prop
bubble_tile_size:
	db $02,$02,$02,$02,$00
bubble_tilemap_offset:
	db $00,$05,$0A,$05


GetDrawInfo:
   LDA !14E0,x
   XBA
   LDA !E4,x
   REP #$20
   SEC : SBC $1A
   STA $00
   CLC
   ADC.w #$0040
   CMP.w #$0180
   SEP #$20
   LDA $01
   BEQ +
     LDA #$01
   +   STA !15A0,x
   TDC
   ROL A
   STA !15C4,x
   BNE .Invalid

   LDA !14D4,x
   XBA
   LDA !1662,x
   AND #$20
   BEQ .CheckOnce
.CheckTwice
   LDA !D8,x
   REP #$21
   ADC.w #$001C
   SEC : SBC $1C
   SEP #$20
   LDA !14D4,x
   XBA
   BEQ .CheckOnce
   LDA #$02
.CheckOnce
   STA !186C,x
   LDA !D8,x
   REP #$21
   ADC.w #$000C
   SEC : SBC $1C
   SEP #$21
   SBC #$0C
   STA $01
   XBA
   BEQ .OnScreenY
   INC !186C,x
.OnScreenY
   LDY !15EA,x
   RTL
 
.Invalid
   PLA             ; destroy the JSL
   PLA
   PLA
   PLA             ; sneak in the bank
   PLY
   PHB
   PHY
   PHA
   RTL
