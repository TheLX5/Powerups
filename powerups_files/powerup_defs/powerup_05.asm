;;;;;;;;;;;;;;;;;;;
;; Boomerang Suit
;;;;;;;;;;;;;;;;;;;

!boomerang_suit_tile		= $0E	;Tile used by the Boomerang Suit item
					;Unused if the Dynamic Powerups Items are disabled.
!boomerang_suit_dynamic_tile	= $0A	;Tile used by the Boomerang Suit item.
					;Only used if the Dynamic Powerups Items are enabled.
!boomerang_suit_prop		= $0A	;YXPPCCCT properties of Boomerang suit item
					;You may want to change the .cfg file too.

!boomerang_shoot_sfx		= $06	;SFX for throwing the boomerang.
!boomerang_shoot_port		= $1DFC	;SFX port for the SFX above.

!boomerang_pose_timer		= $0A	;How many frames Mario will show the "Throw projectile" pose.

!boomerang_catch_cooldown	= $10	;How many frames the boomerang will be "uncatchable"
					;Don't set it too low, otherwise Mario will catch these in an instant.

!boomerang_item_retrieve	= 1	;Set to 0 to make boomerangs not retrieve items.

!boomerang_y_speed		= $EC	;Base Y speed, it's used to calculate every Y speed.
					;It's based on Mario's X speed.

!boomerang_pro_tile_1		= $80	;Boomerang tile #1
!boomerang_pro_tile_2		= $80	;Boomerang tile #2
					;Those aren't used if you are using the projectile DMA feature!
!boomerang_ext_prop		= $0A	;YXPPCCCT properties of the boomerang projectile.

!boomerang_ext_num		= $14	;Extended sprite number for Boomerangs.

!boomerang_shell_immunity	= 1	;If this is set to 1, SMW's enemy fireballs won hurt mario.

!boomerang_run_sprites		= 1	;If this is set to 0, the sprite will check contact with sprites every frame.
					;Otherwise, it will only check every other frame.
					;Set it to zero if you are using SA-1.
					
!boomerang_run_blocks		= 0	;If this is set to 0, the boomerang will check contact with blocks every frame.
					;Otherwise, it will only check every other frame.
					;Set it to zero if you are using SA-1.

!boomerang_activate_on_off	= 1	;Set to 1 to enable boomerangs be able to active ON/OFF blocks on contact.

!boomerang_activate_turn_block	= 1	;Set to 1 to enable boomerangs be able to active turn blocks on contact.
					;Set to 2 to enable boomerangs be able to break turn blocks on contact.

!boomerang_activate_throw_block	= 0	;Set to 1 to enable boomerangs be able to break throw blocks on contact.

!boomerang_activate_glass_block	= 1	;Set to 1 to enable boomerangs be able to active glass blocks on contact.

!boomerang_collect_coins	= 0	;Set to 1 to enable boomerangs be able to collect coins.


%powerup_number(boomerang_suit,05,Smoke)	;Mandatory macro to get the powerup number.
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