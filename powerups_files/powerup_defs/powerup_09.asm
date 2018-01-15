;;;;;;;;;;;;;;;;;;;
;; Unused 9
;;;;;;;;;;;;;;;;;;;

!superball_dynamic_tile	= $22	;Tile used by this powerup.
				;Only used if the Dynamic Powerups Items are enabled.
!superball_tile		= $0E	;Tile used by the Superball flower item
				;Unused if the Dynamic Powerups Items are disabled.
!superball_prop		= $06	;YXPPCCCT properties of the Superball flower item
				;You may want to change the .cfg file too.

!superball_ext_num	= $15	;Extended sprite used by superballs

!superball_pose_timer	= $0A	;How many frames Mario will show the "Throw projectile" pose.

!superball_y_speed	= $30	;Initial Y speed for superballs
!superball_x_speed	= $03	;Initial X speed/$10 for superballs

!superball_shoot_sfx	= $06	;SFX for throwing the superball.
!superball_shoot_port	= $1DFC	;SFX port for the SFX above.

!superball_time		= $F0	;How much time will the superball be on screen.
				;4 seconds.

!superball_shoot_one	= 1	;Set this to 0 if you don't want to limit the amount of superballs on screen.
				;SML only had 1 superball on screen.

!superball_run_sprites	= 1	;If this is set to 0, the sprite will check contact with sprites every frame.
				;Otherwise, it will only check every other frame.
				;Set it to zero if you are using SA-1.

!superball_shoot_up	= 1	;If this is set to 1, Mario will be able to shoot upwards the superballs.

!superball_pro_prop_1	= $02	;
!superball_pro_prop_2	= $02	;YXPPCCCT properties for superballs
!superball_pro_prop_3	= $02	;
!superball_pro_prop_4	= $02	;

				;These are unused if using projectile DMA.
!superball_pro_tile_1	= $00	;
!superball_pro_tile_2	= $00	;Animation for superballs
!superball_pro_tile_3	= $00	;
!superball_pro_tile_4	= $00	;


%powerup_number(superball,09)	;Mandatory macro to get the powerup number.
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