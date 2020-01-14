org $00A300|!base3			;Main DMA routines handler. Includes:
!a	JML PlrDMA			;Projectile DMA, 8x8 DMAer and Mario ExGFX
	RTS

org $0FFB9C|!base3
!a	JML skip_mario_gfx

org $0FFC94|!base3
!a	JML fix_mario_palette