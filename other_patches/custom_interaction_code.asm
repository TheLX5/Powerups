;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  - Pointer table - 
;; Here goes your pointers for your custom interaction code, just put:
;; 	dw .your_label_name
;; and write that label into sprites_custom_interaction.asm
;; DO NOT MOVE THIS POINTER TABLE TO ANOTHER PLACE IN THIS FILE

	;dw .pointer_00		;uncomment and rename (if needed) for your own purposes.
	;dw .pointer_01		;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  - Index table - 
;; This table determines which index should we use for the above table.
;; Note that using values that aren't in the table are likely to cause a crash.

force_hit_sprites_powerups:
	db $00,$00,$00,$00,$00,$00,$00,$00		;powerups 0-7
	db $00,$00,$00,$00,$00,$00,$00,$00		;powerups 8-F

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; vvvv ---- Here goes your custom code ---- vvvv



;; ^^^^ ---- Here goes your custom code ---- ^^^^
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;