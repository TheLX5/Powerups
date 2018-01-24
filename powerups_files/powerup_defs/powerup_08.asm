;;;;;;;;;;;;;;;;;;;
;; Frog Suit (SMB3)
;;;;;;;;;;;;;;;;;;;

!frog_suit_tile		= $0E	;Tile used by the Frog suit item
!frog_suit_prop		= $0A	;YXPPCCCT properties of the Frog suit item
				;You may want to change the .cfg file too.
!frog_suit_ride_yoshi	= 0	;Change to 1 to make Frog Mario able to ride Yoshi.
!frog_suit_dynamic_tile	= $20	;Tile used by this powerup.

%powerup_number(frog_suit,08)	;Mandatory macro to get the powerup number.
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