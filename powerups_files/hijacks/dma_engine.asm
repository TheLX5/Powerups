org $00A300|!base3			;Main DMA routines handler. Includes:
!a	JML PlrDMA			;Projectile DMA, 8x8 DMAer and Mario ExGFX

org $00E40D|!base3			;8x8 DMAer code
	JSR.w capetilehijack		;Makes some 8x8 cape tiles to be loaded with DMA.

org $00F691|!base3			;8x8 DMAer code
	ADC.w #extended_gfx		;New 8x8 tiles location.

org $00E1D4+$2B|!base3			;8x8 DMAer code
	db $00,$8C,$14,$14,$2E		;Edits some values.
	db $00,$CA,$16,$16,$2E
	db $00,$8E,$18,$18,$2E
	db $00,$EB,$1A,$1A,$2E
	db $04,$ED,$1C,$1C

org $00DF1A|!base3			;8x8 DMAer code
	db $00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00

	db $00,$00,$00,$00,$00,$00,$28,$00
	db $00

	db $00,$00,$00,$00,$82,$82,$82,$00
	db $00,$00,$00,$00,$84,$00,$00,$00
	db $00,$86,$86,$86,$00,$00,$88,$88
	db $8A,$8A,$8C,$8C,$00,$00,$90,$00
	db $00,$00,$00,$8E,$00,$00,$00,$00
	db $92,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00

	db $00,$00,$00,$00,$82,$82,$82,$00
	db $00,$00,$00,$00,$84,$00,$00,$00
	db $00,$86,$86,$86,$00,$00,$88,$88
	db $8A,$8A,$8C,$8C,$00,$00,$90,$00
	db $00,$00,$00,$8E,$00,$00,$00,$00
	db $92,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00

org $00DFDA|!base3			;8x8 DMAer code.
	db $00,$02,$80,$80		;[00-03]
	db $00,$02,!dmaer_tile,!dmaer_tile+$1	;[04-07]
	NOP #4
	NOP #4
	NOP #4
capetilehijack:
	LDA $0D
	CPX #$2B
	BCC +
	CPX #$40
	BCS +
	LDA $E1D7,x
+
	RTS

	db $FF,$FF			;[22-23]
	db $FF,$FF,$FF,$FF		;[24-27]
	db $00,$02,$02,$80		;[28-2B]	Balloon Mario
	db $04				;[2C]		Cape
	db !dmaer_tile,!dmaer_tile+$1	;[2D-2E]	Random Gliding tiles
	db $FF,$FF,$FF			;[2F-31]