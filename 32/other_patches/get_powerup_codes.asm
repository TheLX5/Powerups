;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; These pointers are indexed by the value that you got from PowerIndex table.
;; That table gets its index by getting the (custom) sprite number,
;; multiply by !max_powerup+1 and then adding your current powerup number ($19)
;;	if it is a normal sprite...
;;		((sprite_num-#$74)*(!max_powerup+1))+powerup_number
;;	if it is a custom sprite...
;;		((sprite_num+#$05)*(!max_powerup+1))+powerup_number
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Starts at #$06
;; vvvv ---- Here goes your pointers ---- vvvv

	dw GiveIceFlower
	dw GiveHammerSuit
	dw GiveBoomerangSuit
	dw GiveRocketBoots
	dw GiveRaccoonLeaf
	dw GiveTanookiSuit
	dw GiveBubbleFlower
	dw GiveShellSuit
	dw GiveCatSuit

;; ^^^^ ---- Here goes your pointers ---- ^^^^
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Order doesn't matter
;; vvvv ---- Here goes your codes/incsrc ---- vvvv

	incsrc get_powerup/ice_flower.asm
	incsrc get_powerup/hammer_suit.asm
	incsrc get_powerup/boomerang_suit.asm
	incsrc get_powerup/rocket_boots.asm
	incsrc get_powerup/raccoon_leaf.asm
	incsrc get_powerup/tanooki_suit.asm
	incsrc get_powerup/bubble_flower.asm
	incsrc get_powerup/shell_suit.asm
	incsrc get_powerup/cat_suit.asm

;; ^^^^ ---- Here goes your codes/incsrc ---- ^^^^
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
