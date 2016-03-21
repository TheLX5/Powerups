;;;;;;;;;;;;;;;;;;;
;; Hammer suit
;;;;;;;;;;;;;;;;;;;

!hammer_suit_tile	= $20	;Tile used by the Hammer suit item
!hammer_suit_prop	= $08	;YXPPCCCT properties of Hammer suit item
				;You may want to change the .cfg file too.

!hammer_pro_tile_1	= $80	;Hammer tile #1
!hammer_pro_tile_2	= $80	;Hammer tile #2
				;Those aren't used if you are using the projectile DMA feature!

!hammer_pro_props	= $06	;YXPPCCCT properties of the hammer projectile

!hammer_num		= $14	;Extended sprite number.

%powerup_number(hammer_suit,05)	;Mandatory macro to get the powerup number.
	;Input: %powerup_number(<define>,<hex_num>)
	;<define>: Prefix of your defines in this file, must be unique.
	;<hex_num>: Actual powerup number, it must not repeat from another powerup
	;     	    And it must not exceed the value in !max_powerup.
	;Output: Various defines
	;!<define>_powerup_num: Complete define name, you could use it for something else
	;		        Its value would be <hex_num>
	;!powerup_<hex_num>: Complete define name, used within the patch in some tables
	;	             Its value will be !<define>_powerup_num
	;And a few other defines with prefix !powerup_<num>_ instead of !<define>_ such as:
	;!powerup_<num>_tile, !powerup_<num>_prop