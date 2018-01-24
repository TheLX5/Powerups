;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SA-1 detection, ignore this.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

if read1($00FFD5) == $23
	!SA1 = 1
else	
	!SA1 = 0
endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Misc Defines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!i_read_the_readme	= 1	;Set it to 1 to be able to insert the patch.
				;I hope you did read the readme file.

!enable_projectile_dma	= 1	;Enable the ASM hacks to make possible use DMA to upload the projectile tiles
				;Note that this takes some v-blank time because this uses two DMA routines
				;to upload the tiles in $24 and $26
!projectile_dma_tile	= $24	;Upper left tile where two consecutive 16x16 graphics will be 
				;loaded to SP1.

!dynamic_items		= 1	;Enable the ASM hacks to make possible have dynamic powerup items. Freeing a lot of space in SP1/2.

!no_dynamic_item_box	= 0	;Disable the item box graphics being uploaded to tile $0E. Also tile $0E is free if this is 1.
				;Only works if !dynamic_items is 1

!starting_slot		= $00	;Starting slot of the powerup custom sprites.

!clear_7E2000		= 1	;Clear Mario GFX from RAM. Needs to be 0 if using Dynamic Z or the Mode 7 Game Over patch.
				;1 = enable, 0 = disable

!better_powerdown	= 0	;Set it to 1 if you have any plans on using Better Powerdown patch.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Number of possible powerups.
;; Increase this define chain if you need more (or less) powerups slots.
;; Pattern should be obvious.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!max_powerup		= $12	;How many powerups do you have.
				;Increasing this value means that you will need to increase some other pointers and tables.

!powerups_A = 00
!powerups_AA = 01
!powerups_AAA = 02
!powerups_AAAA = 03
!powerups_AAAAA = 04
!powerups_AAAAAA = 05
!powerups_AAAAAAA = 06
!powerups_AAAAAAAA = 07
!powerups_AAAAAAAAA = 08
!powerups_AAAAAAAAAA = 09
!powerups_AAAAAAAAAAA = 0A
!powerups_AAAAAAAAAAAA = 0B
!powerups_AAAAAAAAAAAAA = 0C
!powerups_AAAAAAAAAAAAAA = 0D
!powerups_AAAAAAAAAAAAAAA = 0E
!powerups_AAAAAAAAAAAAAAAA = 0F
!powerups_AAAAAAAAAAAAAAAAA = 10
!powerups_AAAAAAAAAAAAAAAAAA = 11
!powerups_AAAAAAAAAAAAAAAAAAA = 12

macro powerup_number(define_name,num)
	!<define_name>_powerup_num = $<num>
	!powerup_<num> = !<define_name>_powerup_num

	!dynamic_powerup_<num>_tile = !<define_name>_dynamic_tile

	!powerup_<num>_tile = !<define_name>_tile
	!powerup_<num>_prop = !<define_name>_prop
endmacro

;;;;;;;;;;;;;
; Taken from alcaro's Mario ExGFX patch
;;;;;;;;;;;;;

macro foreach_core(code1, code2, code3, code4, id)
!Id = !{powerups_<id>}
<code1>!{Id}<code2>!{Id}<code3>!{Id}<code4>
if $!Id < !max_powerup : %foreach_core("<code1>", "<code2>", "<code3>", "<code4>", <id>A)
endmacro
macro foreach(code1, code2)
%foreach_core("<code1>", "<code2> : if 0 : ", "x", "x", A)
endmacro
macro foreach2(code1, code2, code3)
%foreach_core("<code1>", "<code2>", "<code3> : if 0 : ", "x", A)
endmacro

	%foreach("incsrc powerups_files/powerup_defs/powerup_",".asm")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SP1 & SP2 remap options
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;
;; Shell-less koopa (green, red & yellow)
;;;;;;;;;;;;;;;;;;;

!remap_shell_less_koopa = 0	;This remap will make all of the shell-less koopas
				;use the tiles used by the blue shell-less koopas.
				;0 = don't do this & recover the old data
				;1 = do this

;;;;;;;;;;;;;;;;;;;
;; POW (or P-Switch)
;;;;;;;;;;;;;;;;;;;

!remap_pow		= 0	;Enable POW remapping.
!pow_tile		= $60	;16x16 tile of the POW sprite.
!flat_pow_tile		= $7F	;8x8 tile of the pressed POW sprite.
!blue_pow_yxppccct	= $07	;YXPPCCCT properties of the Blue POW
!silver_pow_yxppccct	= $03	;YXPPCCCT properties of the Silver POW

;;;;;;;;;;;;;;;;;;;
;; Squished koopa
;;;;;;;;;;;;;;;;;;;

!remap_squished_koopa	= 0	;Enable squished koopa remapping.
!squished_koopa_tile	= $4D	;8x8 tile of the squished koopa tile.

;;;;;;;;;;;;;;;;;;;
;; 8x8 bubble
;;;;;;;;;;;;;;;;;;;

!remap_little_bubble	= 1	;Enable little bubble remapping.
!little_bubble_tile	= $38	;8x8 tile of the little bubble.

;;;;;;;;;;;;;;;;;;;
;; Cheep-cheep
;;;;;;;;;;;;;;;;;;;

!remap_cheep_cheeps	= 0	;Enable cheep-cheep remapping.
!flopping_cheep_tile_1	= $08	;Cheep cheep tile #1
!flopping_cheep_tile_2	= $6D	;Cheep cheep tile #2
!cheep_cheep_page	= $01	;Select cheep-cheep GFX page.
				;#$00 Page 1 (SP1-SP2), #$01 Page 2 (SP3-SP4)

;;;;;;;;;;;;;;;;;;;
;; Hammers
;;;;;;;;;;;;;;;;;;;

!remap_hammers		= 0	;Enable hammer remapping.
!hammer_tile_1		= $08	;Hammer tile #1
!hammer_tile_2		= $6D	;Hammer tile #2
!hammer_palette_page	= $07	;This byte sets the YXPPCCCT properties

;;;;;;;;;;;;;;;;;;;
;; Coin sparkles
;;;;;;;;;;;;;;;;;;;

!remap_sparkles		= 0	;Enable little sparkles remapping.
!large_star_tile	= $5C	;Large star tile.
!medium_star_tile	= $6C	;Medium star tile.
!small_star_tile	= $6D	;Small star tile.

;;;;;;;;;;;;;;;;;;;
;; Spinjump star
;;;;;;;;;;;;;;;;;;;

!remap_spinjump_star	= 0	;Enable spinjump stars remapping
!spin_star_tile		= $6C	;Spinjump star tile

;;;;;;;;;;;;;;;;;;;
;; Smoke particles
;;;;;;;;;;;;;;;;;;;

!remap_smoke_particles	= 0	;Leaves free a 16x16 tile in SP1 (tile x66)

;;;;;;;;;;;;;;;;;;;
;; Bubble sprite
;;;;;;;;;;;;;;;;;;;

!remap_bubble_mushroom	= 1	;Enable fixing the mushroom sprite inside a bubble.
!bubble_mushroom_tile	= $E0
!bubble_mushroom_prop	= $09

;;;;;;;;;;;;;;;;;;;;
;; Fishing Lakitu
;;;;;;;;;;;;;;;;;;;;

!remap_lakitu_mushroom	= 1
!lakitu_mushroom_tile	= $E0
!lakitu_mushroom_prop	= $3B

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Other defines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!player_num		= $0DB3|!base2

!ext_sprite_num		= $170B|!base2
!ext_sprite_y_speed	= $173D|!base2
!ext_sprite_x_speed	= $1747|!base2
!ext_sprite_x_lo	= $171F|!base2
!ext_sprite_x_hi	= $1733|!base2
!ext_sprite_y_lo	= $1715|!base2
!ext_sprite_y_hi	= $1729|!base2
!ext_sprite_layer	= $1779|!base2
!ext_sprite_x_bits	= $1751|!base2
!ext_sprite_y_bits	= $175B|!base2
!ext_sprite_table	= $1765|!base2
!ext_sprite_timer	= $176F|!base2
!ext_sprite_gfx		= !ext_sprite_ram
!ext_sprite_flags	= !ext_sprite_ram+10
!ext_sprite_dir		= !ext_sprite_ram+20
!ext_sprite_prev	= !ext_sprite_ram+30
!extended_gfx		= !ext_sprite_ram
!extended_flags		= !ext_sprite_ram+10
!extended_dir		= !ext_sprite_ram+20
!extended_prev		= !ext_sprite_ram+30

!ItemBoxSfx = $0C       ; play the item box drop sound effect
!PowerupSfx = $0B       ; play the powerup sound effect

!ItemPosX1 = $78	; the X position of the item on the screen
!ItemPosY1 = $0F	; the Y position of the item on the screen
!ItemPosX2 = $78	; the X position of the item when it spawns
!ItemPosY2 = $20	; the Y position of the item when it spawns
 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Free RAMs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

if !SA1 == 0
;;;;;;;
;; Normal ROM defines, ignore if using SA-1 or Dynamic Z.

;;;;;;;
;; !gfx_pointer: 24-bit pointer that has the location of the current Mario GFX file.
	!gfx_pointer		= $7E2000
;;;;;;;
;; !gfx_bypass_flag: RAM that bypasses the code that selects the player GFX.
;; #$00 = use original code (not nintendo code), #$01 = bypass the original code.
	!gfx_bypass_flag	= $7E2003
;;;;;;;
;; !gfx_bypass_num: This RAM should contain the index of the graphics of the player.

	!gfx_bypass_num		= $7E2004	
;;;;;;;
;; !mask_15: Setting this disables bits from $15/$16.
	!mask_15		= $7E2005
;;;;;;;
;; !mask_17: Setting this disables bits from $17/$18.
	!mask_17		= $7E2006
;;;;;;;
;; !disable_spin_jump: Disable spin jump. #$00 = no, anything else = disable.
	!disable_spin_jump	= $7E2007	
;;;;;;;
;; !shell_immunity: Gives immunity to some extended sprites while crouching.
	!shell_immunity		= $7E2008
;;;;;;;
;; !flags: Misc RAM often used as a flag for some settings or the current powerup state.
	!flags			= $7E2009
;;;;;;;
;; !timer: Misc RAM often used as a timer.
	!timer			= $7E200A
;;;;;;;
;; !misc: Misc RAM, uses may vary per powerup
	!misc			= $7E200B
;;;;;;;
;; !pal_bypass: RAM that bypasses the palette upload code to upload your own palette.
	!pal_bypass		= $7E200D
;;;;;;;
;; !pal_pointer: This RAM should contain the 24-bit pointer of your custom palette.
	!pal_pointer		= $7E200E
;;;;;;;
;; !projectile_do_dma: RAM used as a flag to upload the projectile GFX
;; Format: ------21
;; 1 = Updates tile 1
;; 2 = Updates tile 2
;; - = Unused
	!projectile_do_dma	= $7E2017
;;;;;;;
;; !projectile_gfx_index: Used to determine which powerup should be uploaded with DMA, 8 bytes.
	!projectile_gfx_index	= $7E2018
;;;;;;;
;; !collision_flag: Enable custom Mario<->Layers interaction field, 1 byte.
;; $00 = run original code
;; $01-$7F values = use RAM tables
;; $80-$FF values = use indirect addressing
	!collision_flag		= $7E2020
;;;;;;;
;; !collision_index: Starting index that will be used in your data tables.
;; #$FF = use built-in routine to handle the index like in the vanilla game.
;; Handles Yoshi, crouching & wallrunning indexes.
	!collision_index	= $7E2021
;;;;;;;
;; !collision_loc_x: 24-bit address of the X coordinates of the collision data. 3 bytes.
	!collision_loc_x	= $7E2022
;;;;;;;
;; !collision_loc_y: 24-bit address of the Y coordinates of the collision data. 3 bytes.
	!collision_loc_y	= $7E2025
;;;;;;;
;; !collision_data_x: Collision data in RAM, X coordinates.
;; At least 108 bytes if using the built-in routine.
	!collision_data_x	= $7E2028
;;;;;;;
;; !collision_data_y: Collision data in RAM, Y coordinates.
;; At least 108 bytes if using the built-in routine.
	!collision_data_y	= $7E2094
;;;;;;;
;; !clipping_flag: Enable custom interaction field with sprites. 1 byte.
	!clipping_flag		= $7E2100
;;;;;;;
;; !clipping_width: Width of interaction field. 1 byte.
	!clipping_width		= $7E2101
;;;;;;;
;; !clipping_height: Height of interaction field. 1 byte.
	!clipping_height	= $7E2102
;;;;;;;
;; !clipping_disp_x: How many pixels will be shifted the interaction field
;; based on Mario's position. 1 byte.
	!clipping_disp_x	= $7E2103
;;;;;;;
;; !clipping_disp_y: How many pixels will be shifted the interaction field
;; based on Mario's position. 1 byte.
	!clipping_disp_y	= $7E2104
;;;;;;;
;; !cape_settings: Reset every frame.
;; bits:
;; 0 - Can capespin flag.
;; 1 - Can fly flag.
;; 2 - Disable infinite fly flag (cape).
;; 3 - Use !flight_timer instead of a set timer.
;; 4 - Show cape.
;; 5 - Enable tap to fly.
	!cape_settings		= $7E2105
;;;;;;;
;; !flight_timer: How many frames you will keep ascending with a Raccoon-like powerup. Not used on Cape-like powerups. Never reset.
	!flight_timer		= $7E2106
;;;;;;;
;; !extra_tile_flags: Enables the usage of a 5th tile. 1 byte. Reset every frame.
;; format: yx-pccce
;; e = Enable the usage of a 5th tile. Overwrites the cape image.
;; ccc = Tile palette. YXPPCCCT format.
;; p = Give priority over Mario
;; x = Flip the tile in the X axis.
;; y = Flip the tile in the Y axis.
	!extra_tile_flag	= $7E2107
;;;;;;;
;; !extra_tile_offset_x: How many pixels the tile is going to be offset from Mario's X position. 2 bytes.
;; Reset every frame.
	!extra_tile_offset_x	= $7E2108
;;;;;;;
;; !extra_tile_offset_y: How many pixels the tile is going to be offset from Mario's Y position. 2 bytes.
;; Reset every frame.
	!extra_tile_offset_y	= $7E210A
;;;;;;;
;; !extra_tile_frame: Frame number of the 5th tile.
;; Reset every frame.
	!extra_tile_frame	= $7E210C
;;;;;;;
;; !extra_tile_pointer: 24-bit pointer of the 5th tile GFX location. 3 bytes.
	!extra_tile_pointer	= $7E210D
;;;;;;
;; !extra_gfx_bypass_num: This RAM should contain the index of the graphics of the player.
;; Only used if !gfx_bypass_flag is set.
	!extra_gfx_bypass_num	= $7E2110
;;;;;;;
;; !item_gfx_refresh: Refreshes stuff on sprite tiles 0A,0C,0E
;; format: -----i21
;; 1 = refreshes dynamic tilemap 1
;; 2 = refreshes dynamic tilemap 2
;; i = refreshes item box dynamic tilemap
;; 1 byte.
	!item_gfx_refresh	= $7E2111
;;;;;;;
;; !item_gfx_pointer: 16-bit pointer used to locate the GFX for the extra item graphics.
;; 12 bytes
	!item_gfx_pointer	= $7E2112
;;;;;;;
;; !item_box_disable: Disables item box and other stuff.
;; format ------sd
;; d = Disable item box dropping.
;; s = Disable item box from being shown on VANILLA status bar.
	!item_box_disable	= $7E211E
;;;;;;;
;; !ride_yoshi_flag: Disables riding yoshi.
;; 1 byte
	!ride_yoshi_flag	= $7E211F
;;;;;;;
;; !insta_kill_flag: Check if Mario should get insta killed when being hit from an enemy.
;; 1 byte
	!insta_kill_flag	= $7E2120
;;;;;;;
;; !ext_sprite_ram: Reserved for 4 extended sprites tables.
;; 40 bytes.
	!ext_sprite_ram		= $7E2121
;;;;;;;
;; !power_ram: Reserved for powerups.
;; 16 bytes.
	!power_ram		= $7E2149
;;;;;;;
;; !projectile_gfx_bank: RAM that should contain the projectile GFX bank byte.
;; 2 bytes.
	!projectile_gfx_bank	= $7E2159
;;;;;;;
;; !ducking_flag: Disables ducking if set.
;; 1 byte.
	!ducking_flag		= $7E215B
;;;;;;;
;; !slide_flag: Disables sliding on slopes if set.
;; 1 byte.
	!slide_flag		= $7E215C
;;;;;;;
;; !extra_tile_index: Which set of GFX is the extra tile using.
;; If it is a negative value, the tile won't upload its graphics to SP1. Applies to both cape and extra tiles.
;; 1 byte.
	!extra_tile_index	= $7E215D
;;;;;;;
;; !gfx_index: Which set of GFX is the player using.
;; 1 byte.
	!gfx_index		= $7E215E
	
;;;;;;:
;; !init_item_pos: Cover-up tile for items position (unused)
	!cover_up_flag		= $7E2159+$B*0
	!init_item_x_lo		= $7E2159+$B*1
	!init_item_x_hi		= $7E2159+$B*2
	!init_item_y_lo		= $7E2159+$B*3
	!init_item_y_hi		= $7E2159+$B*4

	else


;;;;;;;
;; SA-1 Defines, ignore if not using SA-1.

;;;;;;;
;; !gfx_pointer: 24-bit pointer that has the location of the current Mario GFX file.
	!gfx_pointer		= $404100
;;;;;;;
;; !gfx_bypass_flag: RAM that bypasses the code that selects the player GFX.
;; #$00 = use original code (not nintendo code), #$01 = bypass the original code.
	!gfx_bypass_flag	= $404103
;;;;;;;
;; !gfx_bypass_num: This RAM should contain the index of the graphics of the player.

	!gfx_bypass_num		= $404104	
;;;;;;;
;; !mask_15: Setting this disables bits from $15/$16.
	!mask_15		= $404105
;;;;;;;
;; !mask_17: Setting this disables bits from $17/$18.
	!mask_17		= $404106
;;;;;;;
;; !disable_spin_jump: Disable spin jump. #$00 = no, anything else = disable.
	!disable_spin_jump	= $404107	
;;;;;;;
;; !shell_immunity: Gives immunity to some extended sprites while crouching.
	!shell_immunity		= $404108
;;;;;;;
;; !flags: Misc RAM often used as a flag for some settings or the current powerup state.
	!flags			= $404109
;;;;;;;
;; !timer: Misc RAM often used as a timer.
	!timer			= $40410A
;;;;;;;
;; !misc: Misc RAM, uses may vary per powerup
	!misc			= $40410B
;;;;;;;
;; !projectile_gfx_bank: RAM that should contain the projectile GFX bank byte.
	!projectile_gfx_bank	= $40410C
;;;;;;;
;; !pal_bypass: RAM that bypasses the palette upload code to upload your own palette.
	!pal_bypass		= $40410D
;;;;;;;
;; !pal_pointer: This RAM should contain the 24-bit pointer of your custom palette.
	!pal_pointer		= $40410E
;;;;;;;
;; !projectile_do_dma: RAM used as a flag to upload the projectile GFX
	!projectile_do_dma	= $404117
;;;;;;;
;; !projectile_gfx_index: Used to determine which powerup should be uploaded with DMA, 8 bytes.
	!projectile_gfx_index	= $404118
;;;;;;;
;; !collision_flag: Enable custom Mario<->Layers interaction field, 1 byte.
;; $00 = run original code
;; $01-$7F values = use RAM tables
;; $80-$FF values = use indirect addressing
	!collision_flag		= $404120
;;;;;;;
;; !collision_index: Starting index that will be used in your data tables.
;; #$FF = use built-in routine to handle the index like in the vanilla game.
;; Handles Yoshi, crouching & wallrunning indexes.
	!collision_index	= $404121
;;;;;;;
;; !collision_loc_x: 24-bit address of the X coordinates of the collision data. 3 bytes.
	!collision_loc_x	= $404122
;;;;;;;
;; !collision_loc_y: 24-bit address of the Y coordinates of the collision data. 3 bytes.
	!collision_loc_y	= $404125
;;;;;;;
;; !collision_data_x: Collision data in RAM, X coordinates.
;; At least 108 bytes if using the built-in routine.
	!collision_data_x	= $404128
;;;;;;;
;; !collision_data_y: Collision data in RAM, Y coordinates.
;; At least 108 bytes if using the built-in routine.
	!collision_data_y	= $404194
;;;;;;;
;; !clipping_flag: Enable custom interaction field with sprites. 1 byte.
	!clipping_flag		= $404200
;;;;;;;
;; !clipping_width: Width of interaction field. 1 byte.
	!clipping_width		= $404201
;;;;;;;
;; !clipping_height: Height of interaction field. 1 byte.
	!clipping_height	= $404202
;;;;;;;
;; !clipping_disp_x: How many pixels will be shifted the interaction field
;; based on Mario's position. 1 byte.
	!clipping_disp_x	= $404203
;;;;;;;
;; !clipping_disp_y: How many pixels will be shifted the interaction field
;; based on Mario's position. 1 byte.
	!clipping_disp_y	= $404204
;;;;;;;
;; !cape_settings: Reset every frame.
;; bits:
;; 0 - Can capespin flag.
;; 1 - Can fly flag.
;; 2 - Disable infinite fly flag (cape).
;; 3 - Use !flight_timer instead of a set timer.
;; 4 - Show cape.
	!cape_settings		= $404205
;;;;;;;
;; !flight_timer: How many frames you will keep ascending with a Raccoon-like powerup. Not used on Cape-like powerups. Never reset.
	!flight_timer		= $404206
;;;;;;;
;; !extra_tile_flags: Enables the usage of a 5th tile. 1 byte. Reset every frame.
;; format: yx-pccce
;; e = Enable the usage of a 5th tile. Overwrites the cape image.
;; ccc = Tile palette. YXPPCCCT format.
;; p = Give priority over Mario
;; x = Flip the tile in the X axis.
;; y = Flip the tile in the Y axis.
	!extra_tile_flag	= $404207
;;;;;;;
;; !extra_tile_offset_x: How many pixels the tile is going to be offset from Mario's X position. 2 bytes.
;; Reset every frame.
	!extra_tile_offset_x	= $404208
;;;;;;;
;; !extra_tile_offset_y: How many pixels the tile is going to be offset from Mario's Y position. 2 bytes.
;; Reset every frame.
	!extra_tile_offset_y	= $40420A
;;;;;;;
;; !extra_tile_frame: Frame number of the 5th tile.
;; Reset every frame.
	!extra_tile_frame	= $40420C
;;;;;;;
;; !extra_tile_pointer: 24-bit pointer of the 5th tile GFX location. 3 bytes.
	!extra_tile_pointer	= $40420D
;;;;;;
;; !extra_gfx_bypass_num: This RAM should contain the index of the graphics of the player.
;; Only used if !gfx_bypass_flag is set.
	!extra_gfx_bypass_num	= $404210
;;;;;;;
;; !item_gfx_refresh: Refreshes stuff on sprite tiles 0A,0C,0E
;; format: ------dr
;; r = refresh tilemap
;; d = handles item tile
;; 1 byte.
	!item_gfx_refresh	= $404211
;;;;;;;
;; !item_gfx_pointer: 16-bit pointer used to locate the GFX for the extra item graphics.
;; 12 bytes
	!item_gfx_pointer	= $404212
;;;;;;;
;; !item_box_disable: Disables item box and other stuff.
;; format ------sd
;; d = Disable item box dropping.
;; s = Disable item box from being shown on VANILLA status bar.
	!item_box_disable	= $40421E
;;;;;;;
;; !ride_yoshi_flag: Disables riding yoshi.
;; 1 byte
	!ride_yoshi_flag	= $40421F
;;;;;;;
;; !insta_kill_flag: Check if Mario should get insta killed when being hit from an enemy.
	!insta_kill_flag	= $404220
;;;;;;;
;; !ext_sprite_ram: Reserved for 4 extended sprites tables.
;; 40 bytes.
	!ext_sprite_ram		= $404221

endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SA-1 compatibility defines.
;; You can ignore this, everything is handled automatically
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

if !SA1 = 1
	!base1	= $3000			;$0000-$00FF addresses
	!base2	= $6000			;$0100-$1FFF addresses
	!base3	= $000000		;FastROM addresses
					;Sprite addresses remap
	!AA	= $9E
	!B6	= $B6
	!C2	= $D8
	!9E	= $3200
	!D8	= $3216
	!E4	= $322C
	!14C8	= $3242
	!14D4	= $3258
	!14E0	= $326E
	!151C	= $3284
	!1528	= $329A
	!1534	= $32B0
	!1540	= $32C6
	!154C	= $32DC
	!1558	= $32F2
	!1564	= $3308
	!1570	= $331E
	!157C	= $3334
	!1588	= $334A
	!1594	= $3360
	!15A0	= $3376
	!15AC	= $338C
	!15EA	= $33A2
	!15F6	= $33B8
	!1602	= $33CE
	!160E	= $33E4
	!163E	= $33FA
	!187B	= $3410
	!14EC	= $74C8
	!14F8	= $74DE
	!1504	= $74F4
	!1510	= $750A
	!15B8	= $7520
	!15C4	= $7536
	!15D0	= $754C
	!15DC	= $7562
	!161A	= $7578
	!1626	= $758E
	!1632	= $75A4
	!190F	= $7658
	!1FD6	= $766E
	!1FE2	= $7FD6
	!164A	= $75BA
	!1656	= $75D0
	!1662	= $75EA
	!166E	= $7600
	!167A	= $7616
	!1686	= $762C
	!186C	= $7642
	!7FAB10 = $400040
	!7FAB28 = $400057
	!7FAB34 = $40006D
	!7FAB9E	= $400083
else
	!base1	= $0000
	!base2	= $0000
	!base3	= $800000
	
	!AA	= $AA
	!B6	= $B6
	!C2	= $C2
	!9E	= $9E
	!D8	= $D8
	!E4	= $E4
	!14C8	= $14C8
	!14D4	= $14D4
	!14E0	= $14E0
	!151C	= $151C
	!1528	= $1528
	!1534	= $1534
	!1540	= $1540
	!154C	= $154C
	!1558	= $1558
	!1564	= $1564
	!1570	= $1570
	!157C	= $157C
	!1588	= $1588
	!1594	= $1594
	!15A0	= $15A0
	!15AC	= $15AC
	!15EA	= $15EA
	!15F6	= $15F6
	!1602	= $1602
	!160E	= $160E
	!163E	= $163E
	!187B	= $187B
	!14EC	= $14EC
	!14F8	= $14F8
	!1504	= $1504
	!1510	= $1510
	!15B8	= $15B8
	!15C4	= $15C4
	!15D0	= $15D0
	!15DC	= $15DC
	!161A	= $161A
	!1626	= $1626
	!1632	= $1632
	!190F	= $190F
	!1FD6	= $1FD6
	!1FE2	= $1FE2
	!164A	= $164A
	!1656	= $1656
	!1662	= $1662
	!166E	= $166E
	!167A	= $167A
	!1686	= $1686
	!186C	= $186C
	
	!7FAB10 = $7FAB10
	!7FAB28 = $7FAB28
	!7FAB34 = $7FAB34
	!7FAB9E	= $7FAB9E
endif