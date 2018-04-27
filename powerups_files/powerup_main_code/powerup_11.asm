	lda !flags
	bne .no_refill
	lda !timer
	bne .no_refill
	lda #$01
	sta !flags
.no_refill
	lda $72
	beq .return
	lda $187A|!base2
	bne .return
	lda !flags
	beq .return
	bit $16
	bvc .return
	lda #!spawn_cloud_sfx
	sta !spawn_cloud_port|!base2
	lda #$14
	sta $14A6|!base2

	LDX #$09
.find_slot
	LDA $170B|!base2,x
	BEQ .spawn_cloud
	DEX
	CPX #$07
	BNE .find_slot
.return					; don't spawn clouds if there are no free slots
	RTS

.spawn_cloud
	lda #$00
	sta !flags
	lda #$FA
	sta !timer

if !enable_projectile_dma == 1
	txa
	sec
	sbc #$07
	and #$03
	sta !projectile_do_dma
endif	

	LDA #!cloud_ext_num
	STA $170B|!base2,x

	LDA $94				; x position lo/hi
	SEC
	SBC #$08
	STA $171F|!base2,x
	LDA $95
	SBC #$00
	STA $1733|!base2,x
	
	LDA $96				; y position lo/hi
	CLC
	ADC #$24
	STA $1715|!base2,x
	LDA $97
	ADC #$00
	STA $1729|!base2,x
	
	LDA #$64			; expiry timer
	STA $176F|!base2,x
	STZ $1765|!base2,x		; clear misc flags
	STZ $173D|!base2,x		; no y/x speed
	STZ $1747|!base2,x
	LDA $13F9|!base2		; go behind fg stuff
	STA $1779|!base2,x
	
if !cloud_flower_smoke == 1
	LDX #$01			; draw 2 smoke trails ala yellow yoshi
.smoke_trail_loop
	LDY #$07
.find_extended
	LDA $170B|!base2,y
	BEQ .spawn_smoke_trail
	DEY
	BPL .find_extended
	LDY #$07
	
.spawn_smoke_trail
	LDA #$0F
	STA $170B|!base2,y
	LDA $96
	CLC
	ADC #$24
	STA $1715|!base2,y
	LDA $97
	ADC #$00
	STA $1729|!base2,y
	LDA $94
	CLC
	ADC .smoke_x_disp,x
	STA $171F|!base2,y
	LDA $95
	ADC .smoke_x_disp_hi,x
	STA $1733|!base2,y
	LDA .smoke_x_speed,x
	STA $1747|!base2,y
	LDA #$15
	STA $176F|!base2,y
	
	DEX
	BPL .smoke_trail_loop
endif
	RTS

.smoke_x_disp
	db $08,$F8
.smoke_x_disp_hi
	db $00,$FF
.smoke_x_speed
	db $10,$F0

