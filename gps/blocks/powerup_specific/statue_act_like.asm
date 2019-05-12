db $37
JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireball
JMP TopCorner : JMP BodyInside : JMP HeadInside
JMP WallFeet : JMP WallBody

MarioAbove:
MarioBelow:
MarioSide:
TopCorner:
BodyInside:
HeadInside:
WallFeet:
WallBody:
	lda $19
	cmp #!tanooki_suit_powerup_num
	bne no_statue
	lda !power_ram+2
	cmp #$01
	bne no_statue
	rtl
no_statue:

MarioFireball:
SpriteV:
SpriteH:
MarioCape:
	ldy #$00
	lda #$25
	sta $1693|!addr
	rtl

print "Follows the Acts Like setting for Tanooki Mario in his statue form. Passable for anything else."