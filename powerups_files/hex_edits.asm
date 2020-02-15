; Remap sprite stuff.

org $019B8C|!base3
if !remap_shell_less_koopa == 1
			db $E0,$E2,$E2,$E6,$CC,$86,$4E
else
			db $C8,$CA,$CA,$CE,$CC,$86,$4E
endif

if !remap_little_bubble == 1
	org $029F5B|!base3	;remap bubble sprite to 5up graphic.
		LDA #!little_bubble_tile
endif

if !remap_cheep_cheeps == 1
	org $01B117|!base3	;make cheep cheeps use SP3/SP4
		ORA #!cheep_cheep_page

	org $019C0F|!base3	;remap flopping cheep cheeps
		db !flopping_cheep_tile_1,!flopping_cheep_tile_2
endif

if !remap_hammers == 1
	org $02A2DF|!base3	;remap hammers
		db !hammer_tile_1,!hammer_tile_2,!hammer_tile_2,!hammer_tile_1
		db !hammer_tile_1,!hammer_tile_2,!hammer_tile_2,!hammer_tile_1
	org $02A2E7|!base3
		db !hammer_palette_page+$40,!hammer_palette_page+$40
		db !hammer_palette_page,!hammer_palette_page
		db !hammer_palette_page+$80,!hammer_palette_page+$80
		db !hammer_palette_page+$C0,!hammer_palette_page+$C0
endif

if !remap_pow == 1
	org $01A221|!base3	;remap pow
		db !pow_tile
	org $018466|!base3
		db !blue_pow_yxppccct,!silver_pow_yxppccct
endif

if !remap_squished_koopa == 1
	org $01E729|!base3		;remap squished koopa
		db !squished_koopa_tile
endif

if !remap_sparkles == 1
	org $028ECC|!base3		;remap star sparkle tiles
		db !small_star_tile,!small_star_tile,!medium_star_tile
		db !medium_star_tile,!large_star_tile,!large_star_tile
endif

if !remap_spinjump_star == 1
	org $029C94|!base3		;remap spinjump star
		db !spin_star_tile
endif

; vv -- Remap smoke particles -- vv ;

if !remap_smoke_particles == 1
org $00FBA4|!base3
        db $64,$64,$62,$60,$E8,$EA,$EC,$EA
org $01E985|!base3
        db $64,$64,$62,$60
org $028C6A|!base3
        db $64,$64,$62,$60
org $028D42|!base3
        db $68,$68,$6A,$6A,$6A,$62,$62,$62
        db $64,$64,$64,$64,$64
org $0296D8|!base3
        db $64,$62,$64,$62,$60,$62,$60
org $029922|!base3
        db $64,$62,$64,$62,$62
org $029922|!base3
        db $64,$62,$64,$62,$62
org $029C33|!base3
        db $64,$64,$62,$60,$60,$60,$60,$60
org $02A347|!base3
        db $64,$64,$60,$62
endif

if !remap_bubble_mushroom == 1
org $02D8A4|!base3
	db !bubble_mushroom_tile
org $02D8A8
	db !bubble_mushroom_tile
org $02D8AC
	db !bubble_mushroom_prop
endif

if !remap_lakitu_mushroom == 1
org $02E6AD|!base3
	db !lakitu_mushroom_tile
org $02E6B7|!base3
	db !lakitu_mushroom_prop
endif

org $00DCEC|!base3	;PosPointPointer
db $00,$00,$00,$00,$00,$00,$00,$00	;00-07	\
db $00,$00,$00,$00,$00,$00,$00,$00	;08-0F	|
db $04,$02,$02,$02,$00,$00,$00,$00	;10-17	|
db $00,$00,$00,$00,$00,$00,$00,$00	;18-1F	|
db $00,$00,$00,$00,$00,$00,$00,$00	;20-27	|Mario's pose number
db $00,$00,$00,$00,$00,$00,$00,$00	;28-2F	|
db $00,$00,$00,$00,$00,$00,$00,$00	;30-37	|
db $00,$00,$00,$00,$00,$00,$00,$00	;38-3F	|
db $00,$00,$00,$00,$00,$00		;40-45	/

org $00DD32|!base3	;PosPoint
db $00,$08,$10,$18,$20,$28,$00,$00	;00-07
db $00,$00,$00,$00,$00,$00,$00,$00	;08-0F
db $00,$00,$00,$00,$00,$00,$00,$00	;10-17
db $00,$00,$00,$00			;18-1B

org $00DD4E|!base3	;X positions
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

org $00DE32|!base3	;Y positions
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

org $00DFDA|!base3	;Mario8x8Tiles
db $00,$20,$02,$22

org $00E18E|!base3
db $00,$00,$00,$00,$00,$00,$00,$00	;[00-07]
db $00,$00,$00,$00,$00,$0D,$00,$10	;[08-0F]
db $13,$22,$25,$28,$00,$16,$00,$00	;[10-17]
db $00,$00,$00,$00,$00,$08,$19,$1C	;[18-1F]
db $04,$1F,$10,$10,$00,$16,$10,$06	;[20-27]
db $04,$08,$FF,$FF,$FF,$FF,$FF,$43	;[28-2F]
db $00,$00,$00,$00,$00,$00,$00,$00	;[30-37]
db $16,$16,$00,$00,$08			;[38-3C]
db $00,$00,$00,$00,$00,$00,$10,$04	;[3D-44]
db $00					;[45]

org $0485B2|!base3	;OW Border Mario Y Position
dw $0007

org $04EBDA|!base3	;OW Sparkles
db $26,$27,$36,$37,$36,$27,$26

org $00E1D4|!base3			;cape data, only DYNAMIC was modified.
db $06,$00,$06,$00,$86,$02,$06,$03	;MASK,DYNAMIC,MASK,DYNAMIC,MASK,DYNAMIC,MASK,DYNAMIC
db $06,$01,$06,$42,$06,$06,$02,$00	;MASK,DYNAMIC,MASK,DYNAMIC,POSITION,MASK,DYNAMIC,POSITION
db $06,$0A,$06,$06,$06,$0E,$86,$0A	;MASK,DYNAMIC,POSITION,MASK,DYNAMIC,POSITION,MASK,DYNAMIC
db $06,$86,$0A,$0A,$86,$20,$08,$06	;POSITION,MASK,DYNAMIC,POSITION,MASK,DYNAMIC,POSITION,MASK
db $00,$02,$06,$2C,$10,$06,$40,$10	;DYNAMIC,POSITION,MASK,DYNAMIC,POSITION,MASK,DYNAMIC,POSITION
db $06,$2E,$10,$FF,$FF,$FF,$FF,$FF	;MASK,DYNAMIC,POSITION,MASK,DYNAMIC,POSITION,TILE1,TILE2
db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	;MASK,DYNAMIC,POSITION,TILE1,TILE2,MASK,DYNAMIC,POSITION
db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	;TILE1,TILE2,MASK,DYNAMIC,POSITION,TILE1,TILE2,MASK
db $FF,$FF,$FF,$06,$0E,$1E		;DYNAMIC,POSITION,TILE1,MASK,DYNAMIC,POSITION

org $00E23A|!base3			;other cape tiles.
db $00,$00,$20,$00,$24,$24,$24,$24
db $26,$26,$26,$26,$06,$06,$06,$06
db $04,$04,$04,$04,$02,$02,$02,$02
db $08,$08,$08,$08,$28,$28,$28,$28
db $2A,$2A,$2A,$2A,$22,$22,$22,$22
db $0C,$0C,$0C,$0C

if !dynamic_items == 1
org $01DEE3|!base3
db $FA,$FB,$D2,$D2
db $EA,$EB,$FA,$FB
db $D2,$D2,$EA,$EB
db $DE,$DF,$D2,$D2
db $CE,$CF,$DE,$DF
db $D2,$D2,$CE,$CF
db $FE,$FF,$D2,$D2
db $EE,$EF,$FE,$FF
db $D2,$D2,$EE,$EF
 
db $05,$05,$05
db $09,$09,$09
db $0B,$0B,$0B

org $02FE5E|!base3
	db $CE
org $02FE63|!base3
	db $3B

org $07F47B|!base3	;pballoon
	db $20
endif

org $00CCB5|!base3
backup77:
       LDA $77
       STA !ram_77_backup
org $00C599|!base3
       dw backup77

org $00D1AE|!base3	;Animation frame for Mario entering horizontal pipe on Yoshi
	db $1D		;Remapped from $29 to $1D (Ducking with Item/Ducking on Yoshi)