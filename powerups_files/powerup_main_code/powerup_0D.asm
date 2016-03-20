!cloud_ammo = !flags

	LDA $72				; only in the air
	BEQ .return
	LDA $187A|!base2		; and without yoshi
	BNE .return
	
	BIT $16				; Y/X buttons
	BVC .return
	
	LDA #$04			; sound effect 
	STA $1DFC|!base2
	LDA #$14			; show spinning pose
	STA $14A6|!base2
	
	LDA !cloud_ammo
	BEQ .return

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
	LDA !cloud_ammo
	DEC
	STA !cloud_ammo

	LDA #$01
	STA !projectile_do_dma
	
	LDA #!cloud_num
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
	
	RTS

.smoke_x_disp
	db $08,$F8
.smoke_x_disp_hi
	db $00,$FF
.smoke_x_speed
	db $10,$F0