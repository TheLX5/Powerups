db $37
JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireball
JMP TopCorner : JMP BodyInside : JMP HeadInside
JMP WallFeet : JMP WallBody

MarioFireball:
	lda $170B|!addr,x
	cmp #$14
	bne no_boomerang
	lda $1765|!addr,x
	bmi no_boomerang
	lda $1765|!addr,x
	ora #$80
	sta $1765|!addr,x
	lda #$10
	ldy $1747|!addr,x
	bmi left
	lda #$F0
left:	
	sta $1747|!addr,x
	lda #$03
	sta $1DF9|!addr
no_boomerang:

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

print "Immune to boomerangs."