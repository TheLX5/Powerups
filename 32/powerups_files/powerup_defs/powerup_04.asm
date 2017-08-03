;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Ice flower
;; by LX5
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!ice_flower_tile	= $26	;Tile used by the Ice flower item
!ice_flower_prop	= $06	;YXPPCCCT properties of Ice flower item
				;You may want to change the .cfg file too.

!ice_block_tile		= $20	;Tile used by the ice block.
!ice_block_prop		= $0A	;YXPPCCCT properties of the ice block.

!ice_tile_ul		= $22	;Tile used by the up left shattered ice block piece
!ice_tile_ur		= $23	;Tile used by the up right shattered ice block piece
!ice_tile_dl		= $32	;Tile used by the down left shattered ice block piece
!ice_tile_dr		= $33	;Tile used by the down right shattered ice block piece

!iceball_tile_1		= $D2	;Tile used by the iceball, first and third frame.
!iceball_tile_2		= $D3	;Tile used by the iceball, second and fourth frame.
				;Those aren't used if you are using the projectile DMA feature!

!ice_piece_num		= $0D	;Minor extended sprite number of the broken ice piece.

!iceball_prop		= $0A	;YXPPCCCT properties of the iceball.

!iceball_num		= $13	;Extended sprite number.

%powerup_number(ice_flower,04)	;Mandatory macro to get the powerup number.
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