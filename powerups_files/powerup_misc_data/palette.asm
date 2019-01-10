PalettePointers:
	dw MarioPalettes,LuigiPalettes

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; These values represent the palette of Mario when he has each powerup.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MarioPalettes:
; Small
	%insert_palette(small_mario)			; powerup 0
; Big
	%insert_palette(big_mario)			; powerup 1
; Feather
	%insert_palette(cape_mario)			; powerup 2
; Fire flower
	%insert_palette(fire_flower_mario)		; powerup 3
; Hammer suit (SMB3)
	%insert_palette(hammer_suit_mario)		; powerup 4
; Boomerang suit
	%insert_palette(boomerang_suit_mario)		; powerup 5
; Super leaf (SMB3)
	%insert_palette(super_leaf_mario)		; powerup 6
; Tanooki suit (SMB3)
	%insert_palette(tanooki_suit_mario)		; powerup 7
; Frog suit (SMB3)
	%insert_palette(frog_suit_mario)		; powerup 8
; Superball flower (SML)
	%insert_palette(superball_flower_mario)		; powerup 9
; Rocket boots (Terraria)
	%insert_palette(rocket_boots_mario)		; powerup A
; Mini mushroom (NSMBWii)
	%insert_palette(mini_mushroom_mario)		; powerup B
; Ice flower (NSMBWii)
	%insert_palette(ice_flower_mario)		; powerup C
; Penguin suit (NSMBWii)
	%insert_palette(penguin_suit_mario)		; powerup D
; Propeller suit (NSMBWii)
	%insert_palette(propeller_suit_mario)		; powerup E
; Shell suit (NSMBDS)
	%insert_palette(shell_suit_mario)		; powerup F
; Bubble flower
	%insert_palette(bubble_flower_mario)		; powerup 12
; Cloud flower (SMG)
	%insert_palette(cloud_flower_mario)		; powerup 11
; Cat Suit (SM3DW)
	%insert_palette(cat_suit_mario)			; powerup 12

	%insert_palette(small_mario)			; powerup 13
	%insert_palette(small_mario)			; powerup 14
	%insert_palette(small_mario)			; powerup 15
	%insert_palette(small_mario)			; powerup 16
	%insert_palette(small_mario)			; powerup 17

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; These values represent the palette of Luigi when he has each powerup.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

LuigiPalettes:
; Small
	%insert_palette(small_luigi)			; powerup 0
; Big
	%insert_palette(big_luigi)			; powerup 1
; Feather
	%insert_palette(cape_luigi)			; powerup 2
; Fire flower
	%insert_palette(fire_flower_luigi)		; powerup 3
; Hammer suit (SMB3)
	%insert_palette(hammer_suit_luigi)		; powerup 4
; Boomerang suit
	%insert_palette(boomerang_suit_luigi)		; powerup 5
; Super leaf (SMB3)
	%insert_palette(super_leaf_luigi)		; powerup 6
; Tanooki suit (SMB3)
	%insert_palette(tanooki_suit_luigi)		; powerup 7
; Frog suit (SMB3)
	%insert_palette(frog_suit_luigi)		; powerup 8
; Superball flower (SML)
	%insert_palette(superball_flower_luigi)		; powerup 9
; Rocket boots (Terraria)
	%insert_palette(rocket_boots_luigi)		; powerup A
; Mini mushroom (NSMBWii)
	%insert_palette(mini_mushroom_luigi)		; powerup B
; Ice flower (NSMBWii)
	%insert_palette(ice_flower_luigi)		; powerup C
; Penguin suit (NSMBWii)
	%insert_palette(penguin_suit_luigi)		; powerup D
; Propeller suit (NSMBWii)
	%insert_palette(propeller_suit_luigi)		; powerup E
; Shell suit (NSMBDS)
	%insert_palette(shell_suit_luigi)		; powerup F
; Bubble flower
	%insert_palette(bubble_flower_luigi)		; powerup 10
; Cloud flower (SMG)
	%insert_palette(cloud_flower_luigi)		; powerup 11
; Cat Suit (SM3DW)
	%insert_palette(cat_suit_luigi)			; powerup 12

	%insert_palette(small_luigi)			; powerup 13
	%insert_palette(small_luigi)			; powerup 14
	%insert_palette(small_luigi)			; powerup 15
	%insert_palette(small_luigi)			; powerup 16
	%insert_palette(small_luigi)			; powerup 17

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; These values represent the palette of Mario OR Luigi when he has a Star.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

FlashPalettes:
	%insert_palette(small_mario)			; frame 1
	%insert_palette(small_luigi)			; frame 2
	%insert_palette(fire_flower_mario)		; frame 3
	%insert_palette(fire_flower_luigi)		; frame 4