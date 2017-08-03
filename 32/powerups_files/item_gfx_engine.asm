;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Handle powerup item gfx
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PowerupTiles:
	LDA	!190F,x
	BPL	.original_code
	LDA	!166E,x
	AND	#$10
	BEQ	.no_stop_flip
	LDA	!15F6,x
	ORA	$64
	STA	$0303|!base2,y
.no_stop_flip	
	LDA	!7FAB9E,x
	SEC	
	SBC.b	#!starting_slot
	TAX	
	LDA.l	.powerup_tiles,x
	JML	$01C6DA|!base3
.original_code
	LDA	!9E,x
	SEC	
	SBC	#$74
	JML	$01C6D6|!base3
		
.powerup_tiles
	db !powerup_04_tile
	db !powerup_05_tile
	db !powerup_06_tile
	db !powerup_07_tile
	db !powerup_08_tile
	db !powerup_09_tile
	db !powerup_0A_tile
	db !powerup_0B_tile
	db !powerup_0C_tile
	db !powerup_0D_tile
	db !powerup_0E_tile
	db !powerup_0F_tile