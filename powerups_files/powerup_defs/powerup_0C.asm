;;;;;;;;;;;;;;;;;;;
;; Ice Flower (NSMBWii)
;;;;;;;;;;;;;;;;;;;

!ice_flower_tile		= $0E	;Tile used by the unused powerup E item
!ice_flower_prop		= $0A	;YXPPCCCT properties of unused powerup E item
					;You may want to change the .cfg file too.
!ice_flower_dynamic_tile	= $28	;Tile used by this powerup.

!ice_flower_shoot_sfx		= $06
!ice_flower_shoot_port		= $1DFC
!ice_flower_pose_timer		= $0A
!iceball_ext_num		= $16
!iceball_y_speed		= $38
!iceball_shoot_up		= 1
!iceball_base_x_speed		= $02
!iceball_run_sprites		= 1
!iceball_prop			= $0A
!ice_block_rainbow		= $01
!ice_block_tile			= $48
!ice_block_prop			= $0A
%powerup_number(ice_flower,0C)	;Mandatory macro to get the powerup number.
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