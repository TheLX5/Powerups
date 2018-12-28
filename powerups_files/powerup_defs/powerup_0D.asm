;;;;;;;;;;;;;;;;;;;
;; Penguin Suit (Unfinished)
;;;;;;;;;;;;;;;;;;;

!penguin_suit_tile		= $0E	;Tile used by the penguin suit item
!penguin_suit_prop		= $06	;YXPPCCCT properties of the penguin suit item
					;You may want to change the .cfg file too.
!penguin_suit_dynamic_tile	= $2A	;Tile used by this powerup.

!penguin_suit_ride_yoshi	= 0

!penguin_suit_shoot_sfx		= $06	;SFX number that plays when Mario shoots an iceball.
!penguin_suit_shoot_port	= $1DFC	;SFX Port.

!penguin_suit_base_x_speed	= $28	;Base x speed when Mario is sliding.

!penguin_suit_pose_timer	= $0A	;How many frames will the "shooting" pose will be shown.

%powerup_number(penguin_suit,0D)	;Mandatory macro to get the powerup number.
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