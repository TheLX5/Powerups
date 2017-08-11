@includefrom raccoon_engine.asm

cape_pose_indexes:
	dl original_cape_pose_indexes
	dl original_cape_pose_indexes
	dl original_cape_pose_indexes
	dl original_cape_pose_indexes
	dl original_cape_pose_indexes
	dl original_cape_pose_indexes
	dl original_cape_pose_indexes
	dl original_cape_pose_indexes
	dl original_cape_pose_indexes
	dl original_cape_pose_indexes
	dl original_cape_pose_indexes
	dl original_cape_pose_indexes
	dl original_cape_pose_indexes
	dl original_cape_pose_indexes
	dl original_cape_pose_indexes
	dl original_cape_pose_indexes

cape_data_indexes:
	dl original_cape_data
	dl original_cape_data
	dl original_cape_data
	dl original_cape_data
	dl original_cape_data
	dl original_cape_data
	dl original_cape_data
	dl original_cape_data
	dl original_cape_data
	dl original_cape_data
	dl original_cape_data
	dl original_cape_data
	dl original_cape_data
	dl original_cape_data
	dl original_cape_data
	dl original_cape_data

cape_position_pointers:
	dl original_cape_pos
	dl original_cape_pos
	dl original_cape_pos
	dl original_cape_pos
	dl original_cape_pos
	dl original_cape_pos
	dl original_cape_pos
	dl original_cape_pos
	dl original_cape_pos
	dl original_cape_pos
	dl original_cape_pos
	dl original_cape_pos
	dl original_cape_pos
	dl original_cape_pos
	dl original_cape_pos
	dl original_cape_pos
	
original_cape_pose_indexes:
	db $00,$00,$00,$00,$00,$00,$00,$00	;[00-07]
	db $00,$00,$00,$00,$00,$14,$00,$19	;[08-0F]
	db $13,$32,$37,$3C,$00,$1E,$00,$00	;[10-17]
	db $00,$00,$00,$00,$00,$0F,$23,$28	;[18-1F]
	db $05,$2D,$19,$19,$00,$1E,$19,$0A	;[20-27]
	db $05,$0F,$FF,$FF,$FF,$FF,$FF,$41	;[28-2F]
	db $00,$00,$00,$00,$00,$00,$00,$00	;[30-37]
	db $1E,$1E,$00,$00,$0F			;[38-3C]
	db $00,$00,$00,$00,$00,$00,$19,$05	;[3D-44]
	db $00					;[45]

original_cape_data:
	db $06,$00,$00,$00,$00,$06,$00,$00,$00,$00
	db $06,$00,$00,$00,$00,$06,$00,$00,$00,$00
	db $06,$00,$00,$00,$00,$06,$00,$00,$00,$00
	db $06,$00,$00,$00,$00,$06,$00,$00,$00,$00
	db $06,$00,$00,$00,$00,$06,$00,$00,$00,$00
	db $06,$00,$00,$00,$00,$06,$00,$00,$00,$00
	db $06,$00,$00,$00,$00,$06,$00,$00,$00,$00
	db $06,$00,$00,$00,$00,$06,$00,$00,$00,$00

original_cape_pos:
	db $02,$02,$02,$0C,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$04,$12,$04,$04
	db $04,$12,$04,$04,$04,$12,$04,$04
	db $04,$12,$04,$04 