;;;;;;;;;;;;;;;;;;;
;; Bubble flower
;;;;;;;;;;;;;;;;;;;

!bubble_flower_tile	= $CC	;Tile used by the Bubble flower item
!bubble_flower_prop	= $0A	;YXPPCCCT properties of Bubble flower item
				;You may want to change the .cfg file too.

!bubble_pro_tile_1	= $80	;Tile used by the smallest bubble projectile.
!bubble_pro_tile_2	= $80	;Tile used by the small bubble projectile.
!bubble_pro_tile_3	= $80	;Tile used by the large bubble projectile.
!bubble_pro_tile_4	= $80	;Tile used by the largest bubble projectile.
				;Those aren't used if you are using the projectile DMA feature!

!bubble_pro_props	= $06	;YXPPCCCT properties of the bubble projectile.

!big_bubble_tile	= $CA	;Tile number for the bubble sprite, 16x16.
!big_bubble_shine_tile	= $4D	;Tile for the bubble shine, 8x8.
!big_bubble_props	= $06	;YXPPCCCT properties of big bubble.
!big_bubble_shine_prop	= $02	;YXPPCCCT properties of the big bubble shine.

!bubble_ext_num		= $16	;Extended sprite number.

%powerup_number(bubble_flower,0A)	;Mandatory macro to get the powerup number.
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