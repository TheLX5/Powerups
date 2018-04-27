db $37
JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireball
JMP TopCorner : JMP BodyInside : JMP HeadInside
JMP WallFeet : JMP WallBody

MarioFireball:
	lda $170B|!addr,x
	cmp #!superball_ext_num
	bne no_superball
	lda $0F
	pha
	jsl $05B34A|!bank
	%glitter()
	%erase_block()
	pla
	sta $0F
no_superball:

MarioBelow:
MarioAbove:
MarioSide:
TopCorner:
BodyInside:
HeadInside:
WallFeet:
WallBody:
SpriteV:
SpriteH:
MarioCape:
	rtl

print "Coin that can be collected by a superball."