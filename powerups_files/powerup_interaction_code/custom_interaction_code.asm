;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  - Pointer table - 
;; Here goes your pointers for your custom interaction code, just put:
;; 	dw .your_label_name
;; and write that label into sprites_custom_interaction.asm
;; DO NOT MOVE THIS POINTER TABLE TO ANOTHER PLACE IN THIS FILE

	dw .tanooki
	dw .mini
	dw .shell_suit
	;dw .pointer_01		;uncomment and rename (if needed) for your own purposes.
	;dw .pointer_02		;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; vvvv ---- Here goes your custom code ---- vvvv

	incsrc tanooki.asm
	incsrc mini.asm
	incsrc shell_suit.asm

;; ^^^^ ---- Here goes your custom code ---- ^^^^
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  - Index table - 
;; This table determines which index should we use for the above table.
;; Note that using values that aren't in the table are likely to cause a crash.

force_hit_sprites_powerups:
	db $00,$00,$00,$00,$00,$00,$00,$01		;powerups 0-7
	db $00,$00,$00,$02,$00,$00,$00,$03		;powerups 8-F