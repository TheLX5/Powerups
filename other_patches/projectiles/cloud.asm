namespace cloud

!y_pos_lo = $1715|!base2
!x_pos_lo = $171F|!base2
!y_pos_hi = $1729|!base2
!x_pos_hi = $1733|!base2
!y_speed = $173D|!base2
!x_speed = $1747|!base2
!misc = $1765|!base2	; dt-----g
			; d: disappear flag
			; t: being touched flag
			; g: graphics index bit
!expiry_timer = $176F|!base2
!go_behind_layers = $1779|!base2

; the tile numbers etc are below the gfx routine

main:
	JSR sub_gfx
	LDA $9D
	BNE .return
	
	LDA !expiry_timer,x
	BNE .active
	
	LDY #$03			; disappear in a puff of smoke
.smoke_loop
	LDA $17C0|!base2,y
	BEQ .found_smoke
	DEY
	BPL .smoke_loop
	LDY #$03
.found_smoke
	LDA #$01
	STA $17C0|!base2,y
	LDA #$1C
	STA $17CC|!base2,y
	LDA !y_pos_lo,x
	STA $17C4|!base2,y
	LDA !x_pos_lo,x
	CLC
	ADC #$08
	STA $17C8|!base2,y
	
	STZ $170B|!base2,x			; kill

.return
	RTS

.active
	LDA $14
	AND #$07
	BNE .skip_physics
	
	LDA !x_speed,x			; do some kind of air friction stuff
	BEQ +
	BMI .increase_x
	DEC !x_speed,x
	BRA +
.increase_x
	INC !x_speed,x
+
	LDA !y_speed,x
	BEQ +
	BMI .increase_y
	DEC !y_speed,x
	BRA +
.increase_y
	INC !y_speed,x
+
.skip_physics

	LDA $14				; animation
	AND #$07
	BNE .dont_change_frame
	LDA !misc,x
	EOR #$01
	STA !misc,x
		
.dont_change_frame

	LDA !expiry_timer,x		; see if the cloud is almost expiring
	CMP #$1E
	BCS .skip_flashy_stuff
	LDA $14
	LSR				; if yes, flip the disappear bit every other frame
	BCC .skip_flashy_stuff
	LDA !misc,x
	EOR #$80
	STA !misc,x
	
.skip_flashy_stuff
	REP #$21
	LDA $94
	ADC #$000E
	SEP #$21
	SBC !x_pos_lo,x
	STA $00
	XBA
	SBC !x_pos_hi,x
	BMI .nope			; nope if diff <0 or >$2D
	BNE +
	LDA $00
	CMP #$2D
	BCS .nope
+	LDA $7D
	BMI .nope
	
	LDA $187A|!base2
	ASL
	TAY
	REP #$21
	LDA $96
	ADC .player_y_disp,y
	SEP #$21
	SBC !y_pos_lo,x
	STA $00
	XBA
	SBC !y_pos_hi,x
	XBA
	LDA $00
	REP #$20
	CMP #$FFFB
	SEP #$20
	BCC .nope
.okay
	LDA !y_pos_hi,x			; set mario y position
	XBA
	LDA !y_pos_lo,x
	REP #$21			; -1
	SBC .player_y_disp,y
	STA $96
	SEP #$20
	LDA #$01			; set on sprite flag
	STA $1471|!base2
	STZ $7D
	
	BIT !misc,x			; check if already touching
	BVS .end
	LDA !y_speed,x			; push the cloud down a bit
	CLC
	ADC #$06
	STA !y_speed,x
	LDA !misc,x			; set touched bit
	ORA #$40
	STA !misc,x
	BRA .end
	
.nope
	SEP #$20
	LDA !misc,x			; set as not being touched
	AND #~$40
	STA !misc,x

.end
	JSR update_x_pos
	JSR update_y_pos
	RTS
	
.player_y_disp
	dw $001F,$002F

;---------------------------------------
sub_gfx:
	LDA !misc,x			; check disappear flag
	BMI .return
	JSR get_draw_info
	BCS .return
	
	LDA !misc,x			; animation index
	AND #$01
	STA $04
	if !enable_projectile_dma == 1
		phy	
		tay	
		lda.w	cloud_projectile,y
		jsr	cloud_projectile_dma
		ply	
		txa 
		sec 
		sbc #$08
		sta $0F
	endif
	
	PHX				; set up loop
	LDX #$01
.draw_loop
	LDA $00				; x position
	CLC
	ADC .x_disp,x
	STA $0300|!base2,y
	LDA $01
	ADC #$00
	STA $02
	
	LDA $03				; y position
	STA $0301|!base2,y
	
	PHX				; tiles with animation
	
	if !enable_projectile_dma == 1
		ldx	$0F
		lda.w	power_dynamic_tiles,x
	else		
		LDX $04
		LDA .tiles,x
	endif		
	
	STA $0302|!base2,y
	PLX
	
	LDA .props,x			; properties
	STA $0303|!base2,y
	
	PHY				; tile size
	TYA				; get Y/4
	LSR
	LSR
	TAY
	LDA $02				; x position high bit
	AND #$01
	ORA #$02			; 16x16
	STA $0460|!base2,y
	PLY
	
	DEX
	BMI .done
	INY
	INY
	INY
	INY
	BRA .draw_loop
.done
	PLX
.return
	RTS

.tiles
	db !cloud_tile_frame_1,!cloud_tile_frame_2	; frame 1, frame 2
.x_disp
	db $00,$10					; left tile, right tile
.props
	db $30+!cloud_prop,$70+!cloud_prop		; left tile, right tile
	
	
; returns with carry set if it's offscreen
get_draw_info:
	LDA !x_pos_hi,x			; X check
	XBA
	LDA !x_pos_lo,x
	REP #$20
	SEC
	SBC $1A
	STA $00
	CLC
	ADC #$0020			; length
	CMP #$0140			; $0100+2*length
	SEP #$20
	BCS .return
	LDA !y_pos_hi,x			; Y check
	XBA
	LDA !y_pos_lo,x
	REP #$20
	SEC
	SBC $1C
	STA $03
	CLC
	ADC #$0020
	CMP #$0110
	SEP #$20
	BCS .return

	LDY #$FC			; find OAM slot
.OAM_loop
	LDA $02FD|!base2,y
	CMP #$F0
	BNE .found_slot
	CPY #$3C
	BEQ .found_slot
	DEY
	DEY
	DEY
	DEY
	BRA .OAM_loop
.found_slot
	CLC
.return
	RTS


namespace off

; copypasted from imamelia's patch (but I removed the BCC $03s because whyyy)
update_x_pos:
	LDA $1747|!base2,x
	ASL #4
	CLC
	ADC $175B|!base2,x
	STA $175B|!base2,x
	PHP
	LDY #$00
	LDA $1747|!base2,x
	LSR #4
	CMP #$08
	BCC +
	ORA #$F0
	DEY
+	PLP
	ADC $171F|!base2,x
	STA $171F|!base2,x
	TYA
	ADC $1733|!base2,x
	STA $1733|!base2,x
	RTS

update_y_pos:
	LDA $173D|!base2,x
	ASL #4
	CLC
	ADC $1751|!base2,x
	STA $1751|!base2,x
	PHP
	LDY #$00
	LDA $173D|!base2,x
	LSR #4
	CMP #$08
	BCC +
	ORA #$F0
	DEY
+	PLP
	ADC $1715|!base2,x
	STA $1715|!base2,x
	TYA
	ADC $1729|!base2,x
	STA $1729|!base2,x
	RTS


if !enable_projectile_dma == 1

cloud_projectile_dma:
		PHX	
		LDX	$15E9|!base2		;get index
		REP	#$20
		AND	#$00FF
		ASL	#6
		CLC	
		ADC.w	#cloud_projectile_gfx	;this needs to be changed
		PHA				;then we can patch this file without
		TXA				;patching powerup.asm
		SEC	
		SBC	#$0008
		ASL	
		TAX	
		PLA	
		STA	!projectile_gfx_index,x	;get GFX index
		CLC	
		ADC	#$0200
		STA	!projectile_gfx_index+$04,x
		SEP	#$20
		LDA	#$01
		STA	!projectile_do_dma	;enable projectile DMA
		PLX	
		RTS	

cloud_projectile:
		db $00,$01
.gfx		
	incbin cloud_gfx.bin
endif