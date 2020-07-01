;;;;;;;;;;;;;;;;;;;
;; Cat Suit (SM3DW)
;;;;;;;;;;;;;;;;;;;

!cat_suit_tile		= $0E	;Tile used by cat suit item
!cat_suit_prop		= $04	;YXPPCCCT properties of the cat suit item.
				;You may want to change the .cfg file too.


!cat_ClimbSpeed			= $E8	; Y speed at which player climbs a wall
!cat_LedgePullYSpeed		= $C0	; Y speed at which player pulls up when climbing past top of ledge
!cat_LedgePullXSpeed		= $0A	; X speed at which player pulls up when climbing past top of ledge
!cat_KickYSpeed			= $B8	; Y speed with which player kicks off of a wall
!cat_KickXSpeed			= $20	; X speed with which player kicks off of a wall
!cat_DropYSpeed			= $00	; Y speed with which player drops off of a wall when pressing Down + B, or when otherwise detaching
!cat_DropXSpeed			= $10	; X speed with which player drops off of a wall when pressing Down + B, or when otherwise detaching
!cat_NoMoveTime			= $10	; How long to disable direction reversal following a wall kick (or when otherwise detaching if !sk_wallclimb = 1)
!cat_NoMoveDetach		= $03	; How long to disable direction reversal upon detaching from the wall (prevents rapid regrabbing in some scenarios)
!cat_NoMoveOut			= $07	; How long to disable direction reversal upon detaching from the wall (prevents rapid regrabbing in some scenarios)
!cat_climb_ani_rate		= 4	; Set 1 - 8 to adjust rapidness of climbing animation, lower = faster
!cat_suit_wall_attach_time	= 150	; How many frames is Mario able to cling to a wall
!cat_wallkick_penalization	= 25	; How many frames will be deducted after performing a wall jump/kick

!cat_suit_dynamic_tile	= $4A	;Tile used by this powerup.

%powerup_number(cat_suit,12,Smoke)	;Mandatory macro to get the powerup number.
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