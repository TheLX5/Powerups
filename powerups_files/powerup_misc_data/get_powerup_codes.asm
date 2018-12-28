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
	
	dw give_mushroom
	dw give_nothing
	dw give_star
	dw give_cape
	dw give_fire_flower
	dw give_1up
	dw give_hammer_suit
	dw give_boomerang_suit
	dw give_super_leaf
	dw give_tanooki_suit
	dw give_frog_suit
	dw give_superball_flower
	dw give_rocket_boots
	dw give_mini_mushroom
	dw give_ice_flower
	dw give_penguin_suit
	dw give_propeller_suit
	dw give_shell_suit
	dw give_bubble_flower
	dw give_cloud_flower
	dw give_cat_suit

;; ^^^^ ---- Here goes your pointers ---- ^^^^
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Order doesn't matter
;; vvvv ---- Here goes your codes/incsrc ---- vvvv

	incsrc get_powerup/mushroom.asm
	incsrc get_powerup/nothing.asm
	incsrc get_powerup/star.asm
	incsrc get_powerup/feather.asm
	incsrc get_powerup/fire_flower.asm
	incsrc get_powerup/1up.asm
	incsrc get_powerup/hammer_suit.asm
	incsrc get_powerup/boomerang_suit.asm
	incsrc get_powerup/super_leaf.asm
	incsrc get_powerup/tanooki_suit.asm
	incsrc get_powerup/frog_suit.asm
	incsrc get_powerup/superball_flower.asm
	incsrc get_powerup/rocket_boots.asm
	incsrc get_powerup/mini_mushroom.asm
	incsrc get_powerup/ice_flower.asm
	incsrc get_powerup/penguin_suit.asm
	incsrc get_powerup/propeller_suit.asm
	incsrc get_powerup/shell_suit.asm
	incsrc get_powerup/bubble_flower.asm
	incsrc get_powerup/cloud_flower.asm
	incsrc get_powerup/cat_suit.asm

;; ^^^^ ---- Here goes your codes/incsrc ---- ^^^^
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

