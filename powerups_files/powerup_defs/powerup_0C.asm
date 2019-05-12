;;;;;;;;;;;;;;;;;;;
;; Ice Flower (NSMBWii)
;;;;;;;;;;;;;;;;;;;

!ice_flower_tile		= $0E	;Tile used by the Ice Flower item
!ice_flower_prop		= $0A	;YXPPCCCT properties of the Ice Flower item
					;You may want to change the .cfg file too.
!ice_flower_dynamic_tile	= $28	;Tile used by this powerup.

!ice_flower_shoot_sfx		= $06	;SFX number that plays when Mario shoots an iceball.
!ice_flower_shoot_port		= $1DFC	;SFX Port.

!ice_flower_pose_timer		= $0A	;How many frames will the "shooting" pose will be shown.

!iceball_ext_num		= $16	;Extended sprite number for the iceball.

!iceball_y_speed		= $38	;Initial Y speed of the iceball
!iceball_shoot_up		= 1	;Flag to decide if Iceballs can be thrown upwards
!iceball_base_x_speed		= $02	;Initial X speed.
					;Note that this number refers to the amount of pixels
					;that the iceball will move per frame.

!iceball_run_sprites		= 1	;If this is set to 0, the sprite will check contact with sprites every frame.
					;Otherwise, it will only check every other frame.
					;Set it to zero if you are using SA-1.

!iceball_activate_on_off	= 0	;Set to 1 to enable fireballs be able to active ON/OFF blocks on contact.

!iceball_activate_turn_block	= 0	;Set to 1 to enable fireballs be able to active turn blocks on contact.
					;Set to 2 to enable fireballs be able to break turn blocks on contact.

!iceball_activate_throw_block	= 0	;Set to 1 to enable fireballs be able to break throw blocks on contact.

!iceball_activate_glass_block	= 0	;Set to 1 to enable fireballs be able to active glass blocks on contact.

!iceball_collect_coins		= 0	;Set to 1 to enable fireballs be able to collect coins.
				
!iceball_prop			= $0A	;YXPPCCCT properties for the iceball

!iceball_pro_tile_1		= $00	;Frames of the iceball sprite.
!iceball_pro_tile_2		= $00	;These aren't used if using projectiles DMA.
!iceball_pro_tile_3		= $00
!iceball_pro_tile_4		= $00

!ice_block_rainbow		= $01	;Set to 0 if you wanna disable the rainbow effect from the ice block debris.

!ice_block_num			= $0F	;Number of the ice block sprite.
!ice_block_break_sfx		= $07	;SFX that plays when the ice block breaks.
!ice_block_break_port		= $1DFC	;Port of the SFX


%powerup_number(ice_flower,0C,Palette)	;Mandatory macro to get the powerup number.
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