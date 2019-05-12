db $37
JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireball
JMP TopCorner : JMP BodyInside : JMP HeadInside
JMP WallFeet : JMP WallBody

TopCorner:
MarioSide:
BodyInside:
HeadInside:
	lda $19
	cmp #!penguin_suit_powerup_num
	bne no_ride
	lda !flags
	cmp #$01
	bne no_ride
	ldy #$00
	lda #$25
	sta $1693|!addr
	lda #$0F
	trb $98
	trb $9A
	%shatter_block()
	%give_points()
no_ride:

MarioFireball:
MarioBelow:
MarioAbove:
WallFeet:
WallBody:
SpriteV:
SpriteH:
MarioCape:
	rtl

print "A block that can be destroyed by Penguin Mario while he's sliding on his belly."