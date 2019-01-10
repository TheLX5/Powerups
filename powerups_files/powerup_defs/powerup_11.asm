!cloud_flower_tile		= $0E	;Tile used by the unused powerup E item
!cloud_flower_prop		= $0A	;YXPPCCCT properties of unused powerup E item
				;You may want to change the .cfg file too.

!cloud_flower_dynamic_tile	= $46	;Tile used by this powerup.

!spawn_cloud_sfx		= $04
!spawn_cloud_port		= $1DFC
!cloud_ext_num			= $18

!cloud_flower_smoke		= 1

!cloud_prop			= $02

%powerup_number(cloud_flower,11,Palette)	;Mandatory macro to get the powerup number.
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