db $37
JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireball
JMP TopCorner : JMP BodyInside : JMP HeadInside
JMP WallFeet : JMP WallBody

MarioSide:
MarioBelow:
MarioAbove:
TopCorner:
BodyInside:
HeadInside:
WallFeet:
WallBody:
	lda $19
	cmp #!mini_mushroom_powerup_num
	bne no_mini
	ldy #$00
	lda #$25
	sta $1693|!addr
no_mini:

MarioFireball:
SpriteV:
SpriteH:
MarioCape:
	rtl

print "Passable if Mini Mario. Follows the acts like setting for everything else."