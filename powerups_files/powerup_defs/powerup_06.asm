;;;;;;;;;;;;;;;;;;;
;; Super Leaf (Super Mario Bros. 3)
;; 
;; Gives Mario a pair of ears and a raccoon tail
;; You can fly for a short period of time.
;;;;;;;;;;;;;;;;;;;

!super_leaf_dynamic_tile	= $0C	;Tile used by this powerup.
!super_leaf_tile		= $0E	;Tile used by the unused powerup E item
!super_leaf_prop		= $00	;YXPPCCCT properties of unused powerup E item
					;You may want to change the .cfg file too.

!super_leaf_spin_sfx		= $04	;SFX that plays when Mario does a spin
!super_leaf_spin_port		= $1DFC	;SFX port of the above define.
!super_leaf_spin_timer		= $14	;How many frames Mario will be spinning
					;$14 = max value

!super_leaf_settings		= $2A	;Settings for !cape_settings

!super_leaf_flight_timer	= $78	;How many frames Mario will be able to ascend.

%powerup_number(super_leaf,06,Smoke)	;Mandatory macro to get the powerup number.
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