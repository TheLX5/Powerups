db $37
JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireball
JMP TopCorner : JMP BodyInside : JMP HeadInside
JMP WallFeet : JMP WallBody

MarioAbove:
	lda $19
	cmp #!mini_mushroom_powerup_num
	beq mini
	%shatter_block()
	%give_points()
mini:

MarioSide:
MarioFireball:
MarioBelow:
TopCorner:
BodyInside:
HeadInside:
WallFeet:
WallBody:
SpriteV:
SpriteH:
MarioCape:
	rtl

print "A ledge that gets destroyed if Mario steps on it, except if he's on his mini form."