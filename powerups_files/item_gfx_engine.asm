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
	db !ice_flower_tile
	db !hammer_suit_tile
	db !boomerang_suit_tile
	db !rocket_boots_tile
	db !raccoon_leaf_tile
	db !tanooki_suit_tile
	db !bubble_flower_tile
	db !shell_suit_tile
	db !tiny_mushroom_tile
	db !cloud_flower_tile
	db !unused_e_tile
	db !unused_f_tile