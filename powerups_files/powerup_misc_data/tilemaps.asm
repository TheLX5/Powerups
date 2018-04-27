;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; These values represent the tile indices for Mario's tiles.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
TileIndexData:
	db $00,$46,$83,$46,$46,$46,$46,$46		; powerups 0 - 7
	db $46,$46,$46,$00,$46,$46,$46,$46		; powerups 8 - F
	db $46,$46,$46					; powerups 10 - 12

TileAltTable:
	db $01,$02,$03,$02,$02,$02,$04,$04		; powerups 0 - 7
	db $05,$02,$02,$01,$02,$06,$07,$08		; powerups 8 - F
	db $02,$02,$02					; powerups 10 - 12

TileAltIndex:
	dw tilemap_small_mario
	dw tilemap_big_mario
	dw tilemap_cape_mario
	dw tilemap_raccoon_mario
	dw tilemap_frog_mario
	dw tilemap_penguin_mario
	dw tilemap_propeller_mario
	dw tilemap_shell_mario

;original tilemap 32x32, useful if you have a 64KiB .bin file.

excharactertilemap:
db $00,$01,$01,$03,$04,$05,$05,$07	;1
db $08,$08,$0A,$0B,$0C,$0D,$0E,$0F	;2
db $10,$11,$12,$12,$14,$15,$16,$17	;3
db $18,$19,$1A,$1B,$1C,$1D,$1E,$1F	;4
db $20,$21,$22,$23,$24,$25,$26,$27	;5
db $28,$29,$7F,$7F,$7F,$7F,$7F,$7F	;6
db $30,$31,$32,$33,$34,$35,$36,$37	;7
db $38,$39,$3A,$3B,$3C			;8
;misc
db $3D,$3E,$3F,$7F,$7F,$2A,$2B,$2C	;9
db $2D					;10
;big
db $40,$41,$42,$43,$44,$45,$46,$47	;1
db $48,$49,$4A,$4B,$4C,$4D,$4E,$4F	;2
db $50,$51,$52,$53,$54,$55,$56,$57	;3
db $58,$59,$5A,$5B,$5C,$5D,$5E,$5F	;4
db $60,$61,$62,$63,$64,$65,$66,$67	;5
db $68,$69,$6A,$6B,$6C,$6D,$6E,$6F	;6
db $70,$71,$72,$73,$74,$75,$76,$77	;7
db $78,$79,$7A,$7B,$7C			;8
;cape
db $00,$41,$42,$43,$44,$45,$46,$47	;1
db $08,$49,$4A,$4B,$4C,$4D,$4E,$4F	;2
db $50,$51,$52,$53,$54,$55,$56,$57	;3
db $58,$59,$5A,$5B,$5C,$5D,$5E,$5F	;4
db $60,$61,$62,$63,$64,$65,$66,$67	;5
db $68,$69,$6A,$6B,$6C,$6D,$6E,$6F	;6
db $70,$71,$72,$73,$74,$75,$76,$77	;7
db $78,$79,$7A,$7B,$7C			;8

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Small Mario
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

tilemap_small_mario:
db $00,$01,$01,$03,$04,$05,$05,$07	;1
db $08,$08,$0A,$0B,$0C,$0D,$0E,$0F	;2
db $10,$11,$12,$12,$14,$15,$16,$17	;3
db $18,$19,$1A,$1B,$1C,$1D,$1E,$1F	;4
db $20,$21,$22,$23,$24,$25,$26,$27	;5
db $28,$29,$7F,$7F,$7F,$7F,$7F,$7F	;6
db $30,$31,$32,$33,$34,$35,$36,$37	;7
db $38,$39,$3A,$3B,$3C			;8
;misc
db $3D,$3E,$3F,$7F,$7F,$2A,$2B,$2C	;9
db $2D					;10

tilemap_big_mario:
db $00,$01,$02,$03,$04,$05,$06,$07	;1
db $08,$09,$0A,$0B,$0C,$0D,$0E,$0F	;2
db $10,$11,$12,$13,$14,$15,$16,$17	;3
db $18,$19,$1A,$1B,$1C,$1D,$1E,$1F	;4
db $20,$21,$22,$23,$24,$25,$26,$27	;5
db $28,$29,$2A,$2B,$2C,$2D,$2E,$2F	;6
db $30,$31,$32,$33,$34,$35,$36,$37	;7
db $38,$39,$3A,$3B,$3C			;8
;misc
db $3D,$3E,$3F,$7F,$7F,$2A,$3B,$25	;9
db $3A					;10

tilemap_cape_mario:
db $00,$01,$02,$03,$04,$05,$06,$07	;1
db $08,$09,$0A,$0B,$0C,$0D,$0E,$0F	;2
db $10,$11,$12,$13,$14,$15,$16,$17	;3
db $18,$19,$1A,$1B,$1C,$1D,$1E,$1F	;4
db $20,$21,$22,$23,$24,$25,$26,$27	;5
db $28,$29,$2A,$2B,$2C,$2D,$2E,$2F	;6
db $30,$31,$32,$33,$34,$35,$36,$37	;7
db $38,$39,$3A,$3B,$3C			;8
;misc
db $3D,$3E,$3F,$7F,$7F,$2A,$3B,$25	;9
db $3A					;10

tilemap_raccoon_mario:
db $00,$01,$02,$03,$04,$05,$06,$07	;1
db $08,$09,$0A,$0B,$0C,$0D,$0E,$0F	;2
db $10,$11,$12,$13,$14,$15,$16,$17	;3
db $18,$19,$1A,$1B,$1C,$1D,$1E,$1F	;4
db $20,$21,$22,$23,$24,$25,$26,$27	;5
db $28,$29,$2A,$2B,$2C,$2D,$2E,$2F	;6
db $30,$31,$32,$33,$34,$35,$36,$37	;7
db $38,$39,$3A,$3B,$3C			;8
;misc
db $3D,$3E,$3F,$7F,$7F,$2A,$3B,$25	;9
db $3A					;10
;custom
db $2A



tilemap_penguin_mario:
db $00,$01,$02,$03,$04,$05,$06,$07	;1
db $08,$09,$0A,$0B,$0C,$0D,$0E,$0F	;2
db $10,$11,$12,$13,$14,$15,$16,$17	;3
db $18,$19,$1A,$1B,$1C,$1D,$1E,$1F	;4
db $20,$21,$22,$23,$24,$25,$26,$27	;5
db $28,$29,$2A,$2B,$2C,$2D,$2E,$2F	;6
db $30,$31,$32,$33,$34,$35,$36,$37	;7
db $38,$39,$3A,$3B,$3C			;8
;misc
db $3D,$3E,$3F,$7F,$7F,$2A,$3B,$25	;9
db $3A					;10
;custom
db $00

tilemap_shell_mario:
db $00,$01,$02,$03,$04,$05,$06,$07	;1
db $08,$09,$0A,$0B,$0C,$0D,$0E,$0F	;2
db $10,$11,$12,$13,$14,$15,$16,$17	;3
db $18,$19,$1A,$1B,$1C,$1D,$1E,$1F	;4
db $20,$21,$22,$23,$24,$25,$26,$27	;5
db $28,$29,$2A,$2B,$2C,$2D,$2E,$2F	;6
db $30,$31,$32,$33,$34,$35,$36,$37	;7
db $38,$39,$3A,$3B,$3C			;8
;misc
db $3D,$3E,$3F,$7F,$7F,$2A,$3B,$25	;9
db $3A					;10
;custom
db $2C,$2D,$2E,$2F


; /			    \ ;
;|  Propeller Mario tilemap  |;
; \			    / ;

tilemap_propeller_mario:
	db $00,$01,$02,$03,$04,$05,$06,$07
	db $08,$09,$0A,$0B,$0C,$0D,$0E,$0F
	db $10,$11,$12,$13,$14,$15,$16,$17
	db $18,$19,$1A,$1B,$1C,$1D,$1E,$1F
	db $20,$21,$22,$23,$24,$25,$26,$27
	db $28,$20,$0B,$0B,$0B,$0B,$0B,$0B
	db $2D,$2E,$2F,$30,$31,$32,$33,$34
	db $35,$36,$34,$34,$37
	db $00,$00,$38,$7F,$7F,$0F,$29,$25
	db $0F
	db $39,$3A,$3B,$3C,$3D,$3E,$3F,$3C
	db $2A,$2B,$2C


tilemap_frog_mario:
db $00,$01,$02,$03,$04,$05,$06,$07	;1
db $08,$09,$0A,$02,$1C,$02,$0E,$0F	;2
db $10,$11,$12,$13,$14,$15,$16,$17	;3
db $18,$19,$1A,$1B,$1C,$1D,$1E,$1F	;4
db $20,$21,$22,$23,$02,$25,$26,$27	;5
db $28,$29,$FF,$FF,$FF,$FF,$0C,$0D	;6
db $30,$31,$32,$33,$34,$35,$36,$37	;7
db $38,$39,$3A,$3B,$3C			;8
;misc
db $3D,$3E,$3F,$7F,$7F,$2A,$3B,$25	;9
db $3A					;10

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;For Above:
;
;1 - Walking 1/Standing, Walking 2, Walking 3, Looking Up, Running 1, Running 2, Running 3, Carrying Item 1
;
;2 - Carrying Item 2, Carrying Item 3, Looking Up with Item, Jumping, Flying/Taking Off, Skidding, Kicking Item, Going Down Pipe/Turning with Item
;
;3 - About to Run Up Wall, Running Up Wall 1, Running Up Wall 2, Running Up Wall 3, Posing on Yoshi, Climbing, Swimming 1, Swimming with Item 1
;
;4 - Swimming 2, Swimming with Item 2, Swimming 3, Swimming with Item 3, Sliding Downhill, Ducking with Item/Ducking on Yoshi, Punching net, Net Turning 1
;
;5 - Riding Yoshi/Net Turning 2, Turning on Yoshi/Net Turning 3, Climbing Behind, Punching Net Behind, Falling, Spinjump Back (Small Mario)/Brushing 1, Posing, About to use Yoshi Tongue
;
;6 - Use Yoshi Tongue, Unused, Gliding 1, Gliding 2, Gliding 3, Gliding 4, Gliding 5, Gliding 6
;
;7 - Burned (Open eyes), Burned (Closed eyes), Looking at Castle, Looking at Flying Castle 1, Looking at Flying Castle 2, Lean Back with Hammer, Hammer in Mid-Air, Smash Hammer
;
;8 - Brushing 3, Brushing 2, Smash Hammer Again (?), Unused (?), Ducking
;
;9 - Growing/shrinking, Dying, Throwing fireball, Unused (?), Unused (?), Balloon small, Balloon big, Spinjump back
;
;10 - Spinjump front
;
;(Mainly copied the descriptions from Smallhacker's Player Tilemap Editor)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;,
;;Misc shit

PosPointPointer:
db $00,$00,$00,$00,$00,$00,$00,$00	;00-07	\
db $00,$00,$00,$00,$00,$00,$00,$00	;08-0F	|
db $04,$02,$02,$02,$00,$00,$00,$00	;10-17	|
db $00,$00,$00,$00,$00,$00,$00,$00	;18-1F	|
db $00,$00,$00,$00,$00,$00,$00,$00	;20-27	|Mario's pose number
db $00,$00,$00,$00,$00,$00,$00,$00	;28-2F	|
db $00,$00,$00,$00,$00,$00,$00,$00	;30-37	|
db $00,$00,$00,$00,$00,$00,$00,$00	;38-3F	|
db $00,$00,$00,$00,$00,$00		;40-45	/

PosPoint:
db $00,$08,$10,$18,$20,$28,$00,$00	;00-07
db $00,$00,$00,$00,$00,$00,$00,$00	;08-0F
db $00,$00,$00,$00,$00,$00,$00,$00	;10-17
db $00,$00,$00,$00			;18-1B