;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; These values represent the tile indices for Mario's tiles.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
TileIndexData:
	db $00,$46,$83,$46,$46,$46,$46,$46		; powerups 0 - 7
	db $46,$46,$46,$46,$46,$46,$46,$46		; powerups 8 - F

TileAltTable:
	db $00,$00,$00,$00,$00,$01,$01,$00		; powerups 0 - 7
	db $02,$02,$00,$03,$04,$00,$00,$00		; powerups 8 - F

TileAltIndexUpper:
	dw upper_hammer_suit_tilemap
	dw upper_raccoon_tilemap
	dw upper_shell_tilemap
	dw cat_tilemap

TileAltIndexLower:
	dw lower_hammer_suit_tilemap
	dw lower_raccoon_tilemap
	dw lower_shell_tilemap
	dw $FFFF


cat_tilemap:
db $00,$01,$02,$03,$04,$05,$06,$07	;1
db $08,$09,$0A,$0B,$0C,$0D,$0E,$0F	;2
db $10,$11,$12,$13,$14,$15,$16,$17	;3
db $18,$19,$1A,$1B,$1C,$1D,$1E,$1F	;4
db $20,$21,$22,$23,$24,$25,$26,$27	;5
db $28,$29,$2A,$2B,$2C,$2D,$2E,$2F	;6
db $30,$31,$32,$33,$34,$35,$36,$37	;7
db $38,$39,$3A,$3B,$3C			;8

db $3D,$3E,$3F,$7F,$7F,$2A,$2B,$2C	;9
db $2D					;10

;custom

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;; Custom tilemap tables.
;; $E00C & $E0CC
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

if !enable_E00C_editing == 1
pushpc
org $80E00C
upper_small_mario_tilemap:
db $50,$50,$50,$09,$50,$50,$50,$50	;1
db $50,$50,$09,$2B,$50,$2D,$50,$D5	;2
db $2E,$C4,$C4,$C4,$D6,$B6,$50,$50	;3
db $50,$50,$50,$50,$50,$C5,$D7,$2A	;4
db $E0,$50,$D5,$29,$2C,$B6,$D6,$28	;5
db $E0,$E0,$C5,$C5,$C5,$C5,$C5,$C5	;6
db $5C,$5C,$50,$5A,$B6,$50,$28,$28	;7
db $C5,$D7,$28,$70,$C5			;8

upper_misc_tilemap:
db $70,$1C,$93,$C5,$C5,$0B,$85,$90	;9
db $84					;10

upper_big_mario_tilemap:
db $70,$70,$70,$A0,$70,$70,$70,$70	;1
db $70,$70,$A0,$74,$70,$80,$70,$84	;2
db $17,$A4,$A4,$A4,$B3,$B0,$70,$70	;3
db $70,$70,$70,$70,$70,$E2,$72,$0F	;4
db $61,$70,$63,$82,$C7,$90,$B3,$D4	;5
db $A5,$C0,$08,$54,$0C,$0E,$1B,$51	;6
db $49,$4A,$48,$4B,$4C,$5D,$5E,$5F	;7
db $E3,$90,$5F,$5F,$C5			;8

upper_cape_mario_tilemap:
db $70,$70,$70,$A0,$70,$70,$70,$70	;1
db $70,$70,$A0,$74,$70,$80,$70,$84	;2
db $17,$A4,$A4,$A4,$B3,$B0,$70,$70	;3
db $70,$70,$70,$70,$70,$E2,$72,$0F	;4
db $61,$70,$63,$82,$C7,$90,$B3,$D4	;5
db $A5,$C0,$08,$64,$0C,$0E,$1B,$51	;6
db $49,$4A,$48,$4B,$4C,$5D,$5E,$5F	;7
db $E3,$90,$5F,$5F,$C5			;8

lower_small_mario_tilemap:
db $71,$60,$60,$19,$94,$96,$96,$A2	;1
db $97,$97,$18,$3B,$B4,$3D,$A7,$E5	;2
db $2F,$D3,$C3,$C3,$F6,$D0,$B1,$81	;3
db $B2,$86,$B4,$87,$A6,$D1,$F7,$3A	;4
db $F0,$F4,$F5,$39,$3C,$C6,$E6,$38	;5
db $F1,$F0,$C5,$C5,$C5,$C5,$C5,$C5	;6
db $6C,$4D,$71,$6A,$6B,$60,$38,$F1	;7
db $5B,$69,$F1,$F1,$4E			;8

lower_misc_tilemap:
db $E1,$1D,$A3,$C5,$C5,$1A,$95,$10	;9
db $07					;10

lower_big_mario_tilemap:
db $02,$01,$00,$02,$14,$13,$12,$30	;1
db $27,$26,$30,$03,$15,$04,$31,$07	;2
db $E7,$25,$24,$23,$62,$36,$33,$91	;3
db $34,$92,$35,$A1,$32,$F2,$73,$1F	;4
db $C0,$C1,$C2,$83,$D2,$10,$B7,$E4	;5
db $B5,$61,$0A,$55,$0D,$75,$77,$1E	;6
db $59,$59,$58,$02,$02,$6D,$6E,$6F	;7
db $F3,$68,$6F,$6F,$06			;8

lower_cape_mario_tilemap:
db $02,$01,$00,$02,$14,$13,$12,$30	;1
db $27,$26,$30,$03,$15,$04,$31,$07	;2
db $E7,$25,$24,$23,$62,$36,$33,$91	;3
db $34,$92,$35,$A1,$32,$F2,$73,$1F	;4
db $C0,$C1,$C2,$83,$D2,$10,$B7,$E4	;5
db $B5,$61,$0A,$55,$0D,$75,$77,$1E	;6
db $59,$59,$58,$02,$02,$6D,$6E,$6F	;7
db $F3,$68,$6F,$6F,$06			;8
pullpc

endif

excharactertilemap:
;32x32 small mario
db $00,$01,$01,$03,$04,$05,$05,$07	;1
db $08,$08,$0A,$0B,$0C,$0D,$0E,$0F	;2
db $10,$11,$12,$12,$14,$15,$16,$17	;3
db $18,$19,$1A,$1B,$1C,$1D,$1E,$1F	;4
db $20,$21,$22,$23,$24,$25,$26,$27	;5
db $28,$29,$7F,$7F,$7F,$7F,$7F,$7F	;6
db $30,$31,$32,$33,$34,$35,$36,$37	;7
db $38,$39,$3A,$3B,$3C			;8

;32x32 misc
db $3D,$3E,$3F,$7F,$7F,$2A,$2B,$2C	;9
db $2D					;10

;32x32 big/fire mario
db $40,$41,$42,$43,$44,$45,$46,$47	;1
db $48,$49,$4A,$4B,$4C,$4D,$4E,$4F	;2
db $50,$51,$52,$53,$54,$55,$56,$57	;3
db $58,$59,$5A,$5B,$5C,$5D,$5E,$5F	;4
db $60,$61,$62,$63,$64,$65,$66,$67	;5
db $68,$69,$6A,$6B,$6C,$6D,$6E,$6F	;6
db $70,$71,$72,$73,$74,$75,$76,$77	;7
db $78,$79,$7A,$7B,$7C			;8

;32x32 cape mario
db $40,$41,$42,$43,$44,$45,$46,$47	;1
db $48,$49,$4A,$4B,$4C,$4D,$4E,$4F	;2
db $50,$51,$52,$53,$54,$55,$56,$57	;3
db $58,$59,$5A,$5B,$5C,$5D,$5E,$5F	;4
db $60,$61,$62,$63,$64,$65,$66,$67	;5
db $68,$69,$6A,$6B,$6C,$6D,$6E,$6F	;6
db $70,$71,$72,$73,$74,$75,$76,$77	;7
db $78,$79,$7A,$7B,$7C			;8


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

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Upper tiles ($E00C)
;;;;;;;;;;;;;;;;;;;;;;;;;;

upper_hammer_suit_tilemap:
db $01,$01,$01,$00,$01,$01,$01,$01	;1
db $01,$01,$00,$03,$01,$04,$01,$05	;2
db $87,$43,$43,$43,$46,$72,$01,$01	;3
db $01,$01,$01,$01,$01,$27,$26,$82	;4
db $81,$01,$25,$05,$83,$06,$46,$80	;5
db $84,$95,$FF,$FF,$FF,$FF,$FF,$FF	;6
db $44,$53,$67,$63,$73,$64,$65,$66	;7
db $47,$06,$66,$66,$07			;8
db $01,$1C,$45,$07,$07,$FF,$70,$06	;9
db $05					;10

;;;;;;;;
;; Custom images
;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Lower tiles ($E0CC)
;;;;;;;;;;;;;;;;;;;;;;;;;;

lower_hammer_suit_tilemap:
db $10,$11,$12,$10,$20,$21,$22,$30	;1
db $31,$32,$30,$13,$24,$14,$33,$15	;2
db $85,$40,$41,$42,$91,$36,$50,$60	;3
db $52,$62,$51,$61,$23,$37,$86,$92	;4
db $95,$93,$35,$34,$02,$16,$56,$90	;5
db $94,$81,$FF,$FF,$FF,$FF,$FF,$FF	;6
db $54,$54,$77,$10,$10,$74,$75,$76	;7
db $57,$96,$76,$76,$17			;8
db $87,$FF,$55,$07,$07,$FF,$71,$16	;9
db $15					;10

;;;;;;;;
;; Custom images
;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Raccoon & Tanooki tilemaps
;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;
;; Upper tiles ($E00C)
;;;;;;;;;;;;;;;

upper_raccoon_tilemap:
db $01,$01,$01,$00,$01,$01,$01,$01	;1
db $01,$01,$00,$03,$01,$04,$01,$05	;2
db $87,$43,$43,$43,$46,$72,$01,$01	;3
db $01,$01,$01,$01,$01,$27,$26,$82	;4
db $81,$01,$25,$05,$83,$06,$46,$80	;5
db $84,$95,$FF,$FF,$FF,$FF,$FF,$FF	;6
db $44,$53,$67,$63,$73,$64,$65,$66	;7
db $47,$06,$66,$66,$07			;8
db $01,$1C,$45,$07,$07,$FF,$70,$06	;9
db $05					;10

;;;;;;;;
;; Custom images
;;;;;;;;

db $A3		; Statue (only used by the Tanooki suit)

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 32x32 tilemap
;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;
;; Lower tiles ($E0CC)
;;;;;;;;;;;;;;;

lower_raccoon_tilemap:

db $10,$11,$12,$10,$20,$21,$22,$30	;1
db $31,$32,$30,$13,$24,$14,$33,$15	;2
db $85,$40,$41,$42,$91,$36,$50,$60	;3
db $52,$62,$51,$61,$23,$37,$86,$92	;4
db $95,$93,$35,$34,$02,$16,$56,$90	;5
db $94,$81,$FF,$FF,$FF,$FF,$FF,$FF	;6
db $54,$54,$77,$10,$10,$74,$75,$76	;7
db $57,$96,$76,$76,$17			;8
db $87,$FF,$55,$07,$07,$FF,$71,$16	;9
db $15					;10

;;;;;;;;
;; Custom images
;;;;;;;;

db $B3		; Statue (only used by the Tanooki suit)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Shell suit tilemap
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Upper tiles ($E00C)
;;;;;;;;;;;;;;;;;;;;;;;;;;

upper_shell_tilemap:
db $01,$01,$01,$00,$01,$01,$01,$01	;1
db $01,$01,$00,$03,$01,$04,$01,$05	;2
db $87,$43,$43,$43,$46,$72,$01,$01	;3
db $01,$01,$01,$01,$01,$27,$26,$82	;4
db $81,$01,$25,$05,$83,$06,$46,$80	;5
db $84,$95,$FF,$FF,$FF,$FF,$FF,$FF	;6
db $44,$53,$67,$63,$73,$64,$65,$66	;7
db $47,$06,$66,$66,$07			;8
db $01,$1C,$45,$07,$07,$FF,$70,$06	;9
db $05					;10

;;;;;;;;
;; Custom images
;;;;;;;;

db $07,$07,$07,$07		; Blank tiles

;;;;;;;;;;;;;;;
;; Lower tiles ($E0CC)
;;;;;;;;;;;;;;;

lower_shell_tilemap:
db $10,$11,$12,$10,$20,$21,$22,$30	;1
db $31,$32,$30,$13,$24,$14,$33,$15	;2
db $85,$40,$41,$42,$91,$36,$50,$60	;3
db $52,$62,$51,$61,$23,$37,$86,$92	;4
db $95,$93,$35,$34,$02,$16,$56,$90	;5
db $94,$81,$FF,$FF,$FF,$FF,$FF,$FF	;6
db $54,$54,$77,$10,$10,$74,$75,$76	;7
db $57,$96,$76,$76,$17			;8

db $87,$FF,$55,$07,$07,$FF,$71,$16	;9
db $15					;10

;;;;;;;;
;; Custom images
;;;;;;;;

db $A0,$A1,$A2,$A3		; Shell tiles

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

mario_8x8:
db $00,$20,$02,$22

mario_x_pos:
dw $FFF8,$FFF8,$0008,$0008	;[00]	Normal (facing left)
dw $0008,$0008,$FFF8,$FFF8	;[08]	Normal (facing right)
dw $0007,$0007,$0017,$0017	;[10]	Wall running offsets (wall on left)
dw $FFFA,$FFFA,$FFEA,$FFEA	;[18]	Wall running offsets (wall on right)
dw $0005,$0005,$0015,$0015	;[20]	Wall triangle offsets (^ <-)
dw $FFFC,$FFFC,$FFEC,$FFEC	;[28]	Wall triangle offsets (-> ^)
;below are free to use
dw $FFF8,$FFF8,$0008,$0008	;[30]
dw $0008,$0008,$FFF8,$FFF8	;[38]
dw $FFF8,$FFF8,$0008,$0008	;[40]
dw $0008,$0008,$FFF8,$FFF8	;[48]
dw $FFF8,$FFF8,$0008,$0008	;[50]
dw $0008,$0008,$FFF8,$FFF8	;[58]
dw $FFF8,$FFF8,$0008,$0008	;[60]
dw $0008,$0008,$FFF8,$FFF8	;[68]
dw $FFF8,$FFF8,$0008,$0008	;[70]
dw $0008,$0008,$FFF8,$FFF8	;[78]
dw $0000,$0000			;[80]
;;;Cape X positions;;;
dw $000A,$FFF6			;[84]
dw $0008,$FFF8,$0008,$FFF8
dw $0000,$0004,$FFFC,$FFFE
dw $0002,$000B,$FFF5,$0014
dw $FFEC,$000E,$FFF3,$0008
dw $FFF8,$000C,$0014,$FFFD
dw $FFF4,$FFF4,$000B,$000B
dw $0003,$0013,$FFF5,$0005
dw $FFF5,$0009,$0001,$0001
dw $FFF7,$0007,$0007,$0005
dw $000D,$000D,$FFFB,$FFFB
dw $FFFB,$FFFF,$000F,$0001
dw $FFF9,$0000

mario_y_pos:
dw $0001,$0011,$0001,$0011	;[00]	Normal (facing left)
dw $0001,$0011,$0001,$0011	;[08]	Normal (facing right)
dw $000F,$001F,$000F,$001F	;[10]	Wall running offsets (wall on left)
dw $000F,$001F,$000F,$001F	;[18]	Wall running offsets (wall on right)
dw $0005,$0015,$0005,$0015	;[20]	Wall triangle offsets (^ <-)
dw $0005,$0015,$0005,$0015	;[28]	Wall triangle offsets (-> ^)
;below are free to use
dw $0001,$0011,$0001,$0011	;[30]
dw $0001,$0011,$0001,$0011	;[38]
dw $0001,$0011,$0001,$0011	;[40]
dw $0001,$0011,$0001,$0011	;[48]
dw $0001,$0011,$0001,$0011	;[50]
dw $0001,$0011,$0001,$0011	;[58]
dw $0001,$0011,$0001,$0011	;[60]
dw $0001,$0011,$0001,$0011	;[68]
dw $0001,$0011,$0001,$0011	;[70]
dw $0001,$0011,$0001,$0011	;[78]
dw $0000,$0000			;[80]
;;;Cape Y positions;;;
dw $000B,$000B			;[84]
dw $0011,$0011,$FFFF,$FFFF
dw $0010,$0010,$0010,$0010
dw $0010,$0010,$0010,$0015
dw $0015,$0025,$0025,$0004
dw $0004,$0004,$0014,$0014
dw $0004,$0014,$0014,$0004
dw $0004,$0014,$0004,$0004
dw $0014,$0000,$0008,$0000
dw $0000,$0008,$0000,$0000
dw $0010,$0018,$0000,$0010
dw $0018,$0000,$0010,$0000
dw $0010,$FFF8