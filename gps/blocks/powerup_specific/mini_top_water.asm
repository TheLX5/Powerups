db $37
JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireball
JMP TopCorner : JMP BodyInside : JMP HeadInside
JMP WallFeet : JMP WallBody

TopCorner:
MarioAbove:
	ldy #$00
	lda $19
	cmp #!mini_mushroom_powerup_num
	bne no_mini
	lda $15
	and #$04
	bne no_mini
	ldy #$01
no_mini:
	stz $1693|!addr
MarioSide:
MarioFireball:
MarioBelow:
BodyInside:
HeadInside:
WallFeet:
WallBody:
SpriteV:
SpriteH:
MarioCape:
	rtl

print "Mini Mario can walk at the top of this water tile, press down to dive in."