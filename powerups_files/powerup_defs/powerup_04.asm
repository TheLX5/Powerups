;;;;;;;;;;;;;;;;;;;
;; Hammer Suit
;;;;;;;;;;;;;;;;;;;

!hammer_shoot_sfx		= $06

!hammer_y_speed			= $C0

!hammer_shell_immunity		= 1

!hammer_projectile_block 	= 1

!hammer_run_sprites		= 1

!hammer_ext_num			= $13

!hammer_pose_timer		= $0A

!hammer_pro_props		= $06

!hammer_suit_tile		= $0E	;Tile used by the unused powerup E item
!hammer_suit_prop		= $08	;YXPPCCCT properties of unused powerup E item
				;You may want to change the .cfg file too.

!hammer_suit_dynamic_tile	= $08	;Tile used by this powerup.

%powerup_number(hammer_suit,04)	;Mandatory macro to get the powerup number.
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