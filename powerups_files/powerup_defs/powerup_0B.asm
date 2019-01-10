;;;;;;;;;;;;;;;;;;;
;; Mini Mushroom (NSMBWii)
;;;;;;;;;;;;;;;;;;;

!mini_mushroom_tile		= $0E	;Tile used by the mini mushroom item
!mini_mushroom_prop		= $06	;YXPPCCCT properties of the mini mushroom item
					;You may want to change the .cfg file too.

!mini_mushroom_crouch		= 0	;Set to 1 to disable jumping while crouching.
!mini_mushroom_carry		= 0	;Set to 1 to disable jumping while carrying items.

!mini_mushroom_dynamic_tile	= $26	;Tile used by the mini mushroom item

%powerup_number(mini_mushroom,0B,Kill)	;Mandatory macro to get the powerup number.
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