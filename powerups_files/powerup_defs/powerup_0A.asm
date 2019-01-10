;;;;;;;;;;;;;;;;;;;
;; Unused A
;;;;;;;;;;;;;;;;;;;

!rocket_boots_tile		= $0E	;Tile used by the Hammer Suit item
					;Unused if the Dynamic Powerups Items are disabled.
!rocket_boots_prop		= $02	;YXPPCCCT properties of Hammer Suit item
					;You may want to change the .cfg file too.

!rocket_boots_dynamic_tile	= $24	;Tile used by the Hammer Suit item.
					;Only used if the Dynamic Powerups Items are enabled.

!rocket_boots_time		= $44	;How many frames Mario will be able to fly with the boots.
!rocket_boots_boost_sfx		= $27	;Which SFX will play when going up.
!rocket_boots_boost_port	= $1DFC	;SFX port of above.

%powerup_number(rocket_boots,0A,Palette)	;Mandatory macro to get the powerup number.
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