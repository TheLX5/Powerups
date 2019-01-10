;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; These values represent whether or not Mario can spinjump with each powerup.
; #$00 is false, everything else is true
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
SpinJumpData:
	db $01,$01,$01,$01,$01,$01,$01,$01	; powerups 0 - 7
	db $00,$01,$01,$00,$01,$01,$01,$01	; powerups 8 - F
	db $01,$01,$00,$01,$01,$01,$01,$01	; powerups 10 - 17