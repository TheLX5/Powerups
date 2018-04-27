db $37
JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireball
JMP TopCorner : JMP BodyInside : JMP HeadInside
JMP WallFeet : JMP WallBody

MarioFireball:
	lda $170B|!addr,x
	cmp #!superball_ext_num
	bne no_superball
	lda $1765|!addr,x
	ora #$80
	sta $1765|!addr,x
	lda $0F
	pha
	%create_smoke()
	%shatter_block()
	%give_points()
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

print "Can be destroyed by a superball."