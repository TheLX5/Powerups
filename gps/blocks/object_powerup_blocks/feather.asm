;Act as $025.

!powerup = $77
!custom = $00
!cape = 0

db $42 ; or db $37
JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireball
JMP TopCorner : JMP BodyInside : JMP HeadInside
; JMP WallFeet : JMP WallBody ; when using db $37

MarioBelow:
MarioAbove:
MarioSide:
TopCorner:
BodyInside:
HeadInside:
WallFeet:
WallBody:
	
	;MushroomHitbox:
	;.MarioCollision
	JSL $03B664					;>Get player clipping (hitbox/clipping B)
	
	;.MishroomCollision ;>Hitbox A settings
	;;Hitbox notes for mushroom clipping (tested via debugger to find the info):
	;; HitboxXpos = MushroomXPos + $02
	;; HitboxYPos = MushroomYPos + $03
	;; Width = $0C
	;; Height = $0A
	LDA $9A						;\X position
	AND #$F0					;|
	CLC						;|
	ADC #$02					;|
	STA $04						;|
	LDA $9B						;|
	ADC #$00					;|
	STA $0A						;/
	LDA $98						;\Y position
	AND #$F0					;|
	CLC						;|
	ADC #$03					;|
	STA $05						;|
	LDA $99						;|
	ADC #$00					;|
	STA $0B						;/
	LDA #$0C					;\Width
	STA $06						;/
	LDA #$0A					;\Height
	STA $07						;/
	
	;.CheckCollision
	JSL $03B72B					;>Check collision
	BCS +
	RTL
	+
	
	lda #!powerup
	sta $00
	lda #!custom
	sta $01
	%give_powerup()
FinishBlock:
	%erase_block()
	rtl


MarioCape:
if !cape == 1
	phy
	lda #!powerup
if !custom == $00
	clc
else	
	sec
endif	
	%spawn_sprite()
	tax
	%move_spawn_into_block()
	tax
	lda #$08
	sta !14C8,x
	lda #$0C
	sta !154C,x
	lda #$A0
	sta !AA,x
	lda $15E9|!addr
	pha
	stx $15E9|!addr	
	%init_item()
	pla
	sta $15E9|!addr
	ply
	bra FinishBlock
endif

SpriteV:
SpriteH:

MarioFireball:
	RTL

print "A feather."