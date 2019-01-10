;;;;;;;;;;;;;;;;
;; Unused

!unused_16_tile		= $0E	;Tile used by this powerup item.
!unused_16_prop		= $04	;YXPPCCCT properties of this powerup item.
				;You may want to change the .cfg file too.

!unused_16_dynamic_tile	= $4A	;Dynamic tile used by this powerup item.

%powerup_number(unused_16,16,Smoke)	;Mandatory macro to get the powerup number.
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