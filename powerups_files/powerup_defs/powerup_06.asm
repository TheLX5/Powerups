;;;;;;;;;;;;;;;;;;;
;; Boomerang suit
;;;;;;;;;;;;;;;;;;;

!boomerang_suit_tile	= $22	;Tile used by the Boomerang suit item
!boomerang_suit_prop	= $0A	;YXPPCCCT properties of Boomerang suit item
				;You may want to change the .cfg file too.

!boomerang_suit_pro_tile_1	= $80	;Boomerang tile #1
!boomerang_suit_pro_tile_2	= $80	;Boomerang tile #2
				;Those aren't used if you are using the projectile DMA feature!

!boomerang_suit_ext_prop	= $0A	;YXPPCCCT properties of the boomerang projectile.

!boomerang_num			= $15
!boomerang_pro_props		= $0A

!boomerang_suit_extended	= $15

%powerup_number(boomerang_suit,06)	;Mandatory macro to get the powerup number.
	;Input: %powerup_number(<define>,<hex_num>)
	;<define>: Prefix of your defines in this file, must be unique.
	;<hex_num>: Actual powerup number, it must not repeat from another powerup
	;     	    And it must not exceed the value in !max_powerup.
	;Output: Various defines
	;!<define>_powerup_num: Complete define name, you could use it for something else
	;		        Its value would be <hex_num>
	;!powerup_<hex_num>: Complete define name, used within the patch in many tables
	;	             Its value will be !<define>_powerup_num
	;And a few other defines with prefix !powerup_<num>_ instead of !<define>_ such as:
	;!powerup_<num>_tile, !powerup_<num>_prop