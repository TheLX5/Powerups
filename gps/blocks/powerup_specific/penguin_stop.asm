db $37
JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireball
JMP TopCorner : JMP BodyInside : JMP HeadInside
JMP WallFeet : JMP WallBody

MarioBelow:
MarioSide:
TopCorner:
BodyInside:
HeadInside:
WallFeet:
WallBody:
MarioAbove:
	lda $19
	cmp #!penguin_suit_powerup_num
	bne no_ride
	lda !flags
	cmp #$01
	bne no_ride
	lda #$00
	sta !flags
no_ride:

MarioFireball:
SpriteV:
SpriteH:
MarioCape:
	rtl

print "Stops Mario's ride on his belly if he's on a Penguin Suit."