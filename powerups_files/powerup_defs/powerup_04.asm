;;;;;;;;;;;;;;;;;;;
;; Hammer Suit
;;;;;;;;;;;;;;;;;;;

!hammer_suit_tile		= $0E	;Tile used by the Hammer Suit item
					;Unused if the Dynamic Powerups Items are disabled.
!hammer_suit_prop		= $08	;YXPPCCCT properties of Hammer Suit item
					;You may want to change the .cfg file too.

!hammer_suit_dynamic_tile	= $08	;Tile used by the Hammer Suit item.
					;Only used if the Dynamic Powerups Items are enabled.


!hammer_shoot_sfx		= $06	;SFX for throwing the boomerang.
!boomerang_shoot_port		= $1DFC	;SFX port for the SFX above.

!hammer_y_speed			= $C0	;Initial Y speed for hammers.

!hammer_shell_immunity		= 1	;If this is set to 1, SMW's enemy fireballs won't hurt Mario.

!hammer_projectile_block 	= 1	;If this is set to 0, the boomerang will check contact with blocks every frame.
					;Otherwise, it will only check every other frame.
					;Set it to zero if you are using SA-1.

!hammer_run_sprites		= 1	;If this is set to 0, the sprite will check contact with sprites every frame.
					;Otherwise, it will only check every other frame.
					;Set it to zero if you are using SA-1.

!hammer_ext_num			= $13	;Extended sprite number for Hammers.

!hammer_pose_timer		= $0A	;How many frames Mario will show the "Throw projectile" pose.

!hammer_pro_props		= $06	;Palette of the hammer projectile.

%powerup_number(hammer_suit,04,Smoke)	;Mandatory macro to get the powerup number.
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