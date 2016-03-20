	LDA $73
	ORA $74
	ORA $187A|!base2
	ORA $1470|!base2
	BNE .return

	BIT $16
	BVS .shoot_ice_ball
	LDA $140D|!base2
	BEQ .return
	INC $13E2|!base2
	LDA $13E2|!base2
	AND #$0F
	BNE .return
	TAY
	LDA $13E2|!base2
	AND #$10
	BEQ +
	INY
+
	STY $76
.shoot_ice_ball
	LDX #$09
.find_slot
	LDA $170B|!base2,x
	BEQ .found_slot
	DEX
	CPX #$07
	BNE .find_slot
.return
	RTS
	
.found_slot
	LDA #$01
	STA !projectile_do_dma
	LDA #$06		; play sfx
	STA $1DFC|!base2
	LDA #$0A		; show shooting pose
	STA $149C|!base2
	LDA #!iceball_num	; ext sprite number
	STA $170B|!base2,x
	LDA #$38		; y speed
	STA $173D|!base2,x
	
	LDA $7B			; x speed stuff
	BPL +
	EOR #$FF
	INC
+	CMP #$30
	BCC +			; avoid going out of bounds
	LDA #$2F
+	LSR #3
	ASL
	ADC $76
	TAY
	LDA .x_speed,y
	STA $1747|!base2,x
	
	LDY $76
	LDA $94			; x position lo/hi
	CLC
	ADC .x_disp,y
	STA $171F|!base2,x
	LDA $95
	ADC #$00
	STA $1733|!base2,x		; y position lo/hi
	LDA $96
	CLC
	ADC #$08
	STA $1715|!base2,x
	LDA $97
	ADC #$00
	STA $1729|!base2,x
	LDA $13F9|!base2		; go behind fg stuff
	STA $1779|!base2,x
	STZ $175B|!base2,x		; hit counter = 0
	LDA #$02
	STA !extra_extended,x
	RTS
	
;7b $30 values

.x_speed
	db $FE,$02,$FD,$03,$FD,$03,$FD,$03,$FD,$03,$FC,$04
.x_disp
	db $00,$08