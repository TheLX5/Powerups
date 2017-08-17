;;;;;;;;;;;;;;;;;;;
;; Unused 9
;;;;;;;;;;;;;;;;;;;

!unused_9_tile		= $0E	;Tile used by the unused powerup E item
!unused_9_prop		= $00	;YXPPCCCT properties of unused powerup E item
				;You may want to change the .cfg file too.

!unused_9_dynamic_tile	= $00	;Tile used by this powerup.

%powerup_number(unused_9,09)	;Mandatory macro to get the powerup number.
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