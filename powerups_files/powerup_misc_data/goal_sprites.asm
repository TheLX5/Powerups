;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; These values corresponds to the sprite number that a carriable sprite will
;; transform into after touching the goal tape.
;; 
;; * data00FADF contains the sprite number of every item sprite.
;; * data00FADF_settings purpose is to define if a item sprite should be a custom sprite
;; or a normal sprite
;; * data00FAFB has some values to check if the carried sprite should transform into
;; a item powerup or a 1-up mushroom.
;; 
;; Both data00FADF and data00FADF_settings are indexed by the current powerup ($7E0019),
;; this index can change depending on the carried sprite due to how SMW works.
;; data00FAFB is indexed by the current sprite in the item box ($7E0DC2).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

data00FADF:
	;any sprite
		db $74,$74,$77,$75
		db !starting_slot+$00,!starting_slot+$01,!starting_slot+$02
		db !starting_slot+$03,!starting_slot+$04,!starting_slot+$05
		db !starting_slot+$06,!starting_slot+$07,!starting_slot+$08
		db !starting_slot+$09,!starting_slot+$0A,!starting_slot+$0B
	;springboard & p-switch
		db $74,$74,$77,$75
		db !starting_slot+$00,!starting_slot+$01,!starting_slot+$02
		db !starting_slot+$03,!starting_slot+$04,!starting_slot+$05
		db !starting_slot+$06,!starting_slot+$07,!starting_slot+$08
		db !starting_slot+$09,!starting_slot+$0A,!starting_slot+$0B
	;key
		db $74,$78,$78,$78
		db $78,$78,$78
		db $78,$78,$78
		db $78,$78,$78
		db $78,$78,$78
	;baby yoshi
		db $78,$78,$78,$78
		db $78,$78,$78
		db $78,$78,$78
		db $78,$78,$78
		db $78,$78,$78
data00FADF_settings:
	;any sprite
		db $00,$00,$00,$00
		db $01,$01,$01
		db $01,$01,$01
		db $01,$01,$01
		db $01,$01,$01
	;springboard & p-switch
		db $00,$00,$00,$00
		db $01,$01,$01
		db $01,$01,$01
		db $01,$01,$01
		db $01,$01,$01
	;key
		db $00,$00,$00,$00
		db $00,$00,$00
		db $00,$00,$00
		db $00,$00,$00
		db $00,$00,$00
	;baby yoshi
		db $00,$00,$00,$00
		db $00,$00,$00
		db $00,$00,$00
		db $00,$00,$00
		db $00,$00,$00
data00FAFB:
		db $FF,$74,$75,$FF,$77
		db !starting_slot+$00,!starting_slot+$01,!starting_slot+$02
		db !starting_slot+$03,!starting_slot+$04,!starting_slot+$05
		db !starting_slot+$06,!starting_slot+$07,!starting_slot+$08
		db !starting_slot+$09,!starting_slot+$0A,!starting_slot+$0B