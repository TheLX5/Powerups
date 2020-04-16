;;;;;;;;;;;;;;;;;;;
;; Electric Flower (Custom)
;;;;;;;;;;;;;;;;;;;

!elec_flower_tile		= $0E	;Tile used by the Electric Flower item
!elec_flower_prop		= $04	;YXPPCCCT properties of the Electric Flower item
					;You may want to change the .cfg file too.
!elec_flower_dynamic_tile	= $02	;Tile used by this powerup.

!elec_flower_shoot_sfx		= $06	;SFX number that plays when Mario shoots an elecball.
!elec_flower_shoot_port		= $1DFC	;SFX Port.

!elec_flower_pose_timer		= $0B	;How many frames will the "shooting" pose will be shown.

!elecball_ext_num		= $19	;Extended sprite number for the elecball.

!elecball_y_speed		= $20	;Initial Y speed of the elecball
!elecball_shoot_up		= 1	;Flag to decide if elecballs can be thrown upwards
!elecball_base_x_speed		= $02	;Initial X speed.
					;Note that this number refers to the amount of pixels
					;that the elecball will move per frame.

!elecball_run_sprites		= 0	;If this is set to 0, the sprite will check contact with sprites every frame.
					;Otherwise, it will only check every other frame.
					;Set it to zero if you are using SA-1.
					
!elecball_prop			= $0A	;YXPPCCCT properties for the elecball

!elecball_pro_tile_1		= $00	;Frames of the elecball sprite.
!elecball_pro_tile_2		= $00	;These aren't used if using projectiles DMA.
!elecball_pro_tile_3		= $00
!elecball_pro_tile_4		= $00

!elecball_activate_delete	= 1	;Set to 1 to delete elecballs when activating the blocks below.

!elecball_activate_on_off	= 1	;Set to 1 to enable elecballs be able to active ON/OFF blocks on contact.

!elecball_activate_turn_block	= 0	;Set to 1 to enable elecballs be able to active turn blocks on contact.
					;Set to 2 to enable elecballs be able to break turn blocks on contact.

!elecball_activate_throw_block	= 0	;Set to 1 to enable elecballs be able to break throw blocks on contact.

!elecball_activate_glass_block	= 0	;Set to 1 to enable elecballs be able to active glass blocks on contact.

!elecball_collect_coins		= 0	;Set to 1 to enable elecballs be able to collect coins.


%powerup_number(elec_flower,13,Palette)	;Mandatory macro to get the powerup number.