;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; These values represent the custom GFX index of Mario when using the powerup.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

GFXData:
	;mario gfx
	db $00,$01,$01,$01,$02,$03,$04,$05		; powerups 0 - 7
	db $06,$01,$01,$07,$01,$08,$09,$0A		; powerups 8 - F
	db $0B,$01,$01					; powerups 10 - 12

	;luigi gfx
	db $00,$01,$01,$01,$02,$03,$04,$05		; powerups 0 - 7
	db $06,$01,$01,$07,$01,$08,$09,$0A		; powerups 8 - F
	db $0B,$01,$01					; powerups 10 - 12

ExtraGFXData:
	;mario extra gfx
	db $00,$00,$00,$00,$00,$00,$01,$01		; powerups 0 - 7
	db $00,$00,$00,$00,$00,$00,$02,$00		; powerups 8 - F
	db $00,$00,$00					; powerups 10 - 12

	;luigi extra gfx
	db $00,$00,$00,$00,$00,$00,$01,$01		; powerups 0 - 7
	db $00,$00,$00,$00,$00,$00,$02,$00		; powerups 8 - F
	db $00,$00,$00					; powerups 10 - 12