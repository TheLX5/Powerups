;;;;;;;;;;;;;;;;;;;;;;;;
;; Bubble Flower
;;;;;;;;;;;;;;;;;;;;;;;;

!bubble_flower_tile		= $0E	;Tile used by the bubble flower item
!bubble_flower_prop		= $0A	;YXPPCCCT properties of the bubble flower item
					;You may want to change the .cfg file too.

!bubble_flower_dynamic_tile	= $48	;Tile used by this powerup.

!bubble_run_sprites		= 1	;If this is set to 0, the sprite will check contact with sprites every frame.
					;Otherwise, it will only check every other frame.
					;Set it to zero if you are using SA-1.
!bubble_flower_shoot_sfx	= $02
!bubble_flower_shoot_port	= $1DFC
!bubble_flower_pose_timer	= $0A

!bubble_ext_num			= $17

!bubble_pro_tile_1		= $80	;Tile used by the smallest bubble projectile.
!bubble_pro_tile_2		= $80	;Tile used by the small bubble projectile.
!bubble_pro_tile_3		= $80	;Tile used by the large bubble projectile.
!bubble_pro_tile_4		= $80	;Tile used by the largest bubble projectile.
				;Those aren't used if you are using the projectile DMA feature!

!bubble_pro_props		= $06	;YXPPCCCT properties of the bubble projectile.

!big_bubble_tile		= $66	;Tile number for the bubble sprite, 16x16.
!big_bubble_shine_tile		= $7F	;Tile for the bubble shine, 8x8.
!big_bubble_props		= $06	;YXPPCCCT properties of big bubble.
!big_bubble_shine_prop		= $02	;YXPPCCCT properties of the big bubble shine.


%powerup_number(bubble_flower,10,Palette)	;Mandatory macro to get the powerup number.
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