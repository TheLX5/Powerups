;;;;;;;;;;;;;;;;;;;
;; Cat Suit (SM3DW)
;;;;;;;;;;;;;;;;;;;

!cat_suit_tile		= $0E	;Tile used by cat suit item
!cat_suit_prop		= $04	;YXPPCCCT properties of the cat suit item.
				;You may want to change the .cfg file too.

!cat_suit_no_move	= $48	;Time until being able to climb a wall again

!cat_suit_kick_x_speed	= $20
!cat_suit_kick_y_speed	= $B8

!cat_suit_climb_speed	= $DC
!cat_suit_time_to_stick	= $50	;How much frames is Mario able to climb

!cat_suit_dynamic_tile	= $4A	;Tile used by this powerup.

%powerup_number(cat_suit,12)	;Mandatory macro to get the powerup number.
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