;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; These values represent the custom GFX index of Mario when using the powerup.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

GFXData:
	;mario gfx
	db $00,$01,$01,$01,$02,$03,$04,$05		; powerups 0 - 7
	db $06,$01,$01,$07,$01,$08,$09,$0A		; powerups 8 - F
	db $01,$01,$0B,$01,$01,$01,$01,$01		; powerups 10 - 17

	;luigi gfx
	db $00,$01,$01,$01,$02,$03,$04,$05		; powerups 0 - 7
	db $06,$01,$01,$07,$01,$08,$09,$0A		; powerups 8 - F
	db $01,$01,$0B,$01,$01,$01,$01,$01		; powerups 10 - 12

.compressed_flag
	;mario gfx
	db $01,$01,$01,$01,$01,$01,$01,$01		; powerups 0 - 7
	db $01,$01,$01,$01,$01,$01,$01,$01		; powerups 8 - F
	db $01,$01,$01,$01,$01,$01,$01,$01		; powerups 10 -17

	;luigi gfx
	db $01,$01,$01,$01,$01,$01,$01,$01		; powerups 0 - 7
	db $01,$01,$01,$01,$01,$01,$01,$01		; powerups 8 - F
	db $01,$01,$01,$01,$01,$01,$01,$01		; powerups 10 -17

ExtraGFXData:
	;mario extra gfx
	db $FF,$FF,$00,$FF,$FF,$FF,$01,$01		; powerups 0 - 7
	db $FF,$FF,$FF,$FF,$FF,$FF,$02,$FF		; powerups 8 - F
	db $FF,$03,$04,$FF,$FF,$FF,$FF,$FF		; powerups 10 - 17

	;luigi extra gfx
	db $FF,$FF,$00,$FF,$FF,$FF,$01,$01		; powerups 0 - 7
	db $FF,$FF,$FF,$FF,$FF,$FF,$02,$FF		; powerups 8 - F
	db $FF,$03,$04,$FF,$FF,$FF,$FF,$FF		; powerups 10 - 17

.compressed_flag
	;mario extra gfx
	db $01,$01,$01,$01,$01,$01,$01,$01		; powerups 0 - 7
	db $01,$01,$01,$01,$01,$01,$01,$01		; powerups 8 - F
	db $01,$01,$01,$01,$01,$01,$01,$01		; powerups 10 -17

	;luigi extra gfx
	db $01,$01,$01,$01,$01,$01,$01,$01		; powerups 0 - 7
	db $01,$01,$01,$01,$01,$01,$01,$01		; powerups 8 - F
	db $01,$01,$01,$01,$01,$01,$01,$01		; powerups 10 -17