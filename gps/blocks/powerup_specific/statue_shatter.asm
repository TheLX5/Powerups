db $37
JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireball
JMP TopCorner : JMP BodyInside : JMP HeadInside
JMP WallFeet : JMP WallBody

MarioAbove:
	lda $19
	cmp #!tanooki_suit_powerup_num
	bne no_statue
	lda !power_ram+2
	cmp #$01
	bne no_statue
	lda #$0F
	trb $98
	trb $9A
	%shatter_block()
	%give_points()
no_statue:

MarioFireball:
MarioBelow:
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

print "A block that can be destroyed by Tanooki Mario in his statue form."