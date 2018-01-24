;;;;;;;;;;;;;;;;;;;
;; Shell Suit
;;;;;;;;;;;;;;;;;;;

!shell_suit_tile		= $0E	;Tile used by the Shell Suit item
!shell_suit_prop		= $06	;YXPPCCCT properties of the Shell Suit item
					;You may want to change the .cfg file too.

!shell_suit_base_x_speed	= $28	;Base x speed when Mario is inside of the shell.
!shell_suit_dynamic_tile	= $44	;Tile used by this powerup.

%powerup_number(shell_suit,0F)	;Mandatory macro to get the powerup number.
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