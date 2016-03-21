;;;;;;;;;;;;;;;;;;;
;; Cloud Flower
;;;;;;;;;;;;;;;;;;;

!cloud_flower_tile	= $C2	;Tile used by the unused powerup D item
!cloud_flower_prop	= $06	;YXPPCCCT properties of unused powerup D item
				;You may want to change the .cfg file too.

!cloud_tile_frame_1	= $20	;Cloud animation tile 1.
!cloud_tile_frame_2	= $22	;Cloud animation tile 2.

!cloud_prop		= $06	;YXPPCCCT properties of the cloud sprite.

!cloud_ammount		= $03	;Ammount of clouds per powerup item.

!cloud_num		= $17	;Cloud extended sprite number.

%powerup_number(cloud_flower,0D)	;Mandatory macro to get the powerup number.
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