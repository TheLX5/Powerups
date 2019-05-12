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
	cmp #!cloud_flower_powerup_num
	bne no_cloud
	lda !flags
	bne no_cloud
	sta !timer
	inc
	sta !flags
	lda #$0F
	trb $98
	trb $9A
	%erase_block()
	%create_smoke()
no_cloud:

MarioFireball:
SpriteV:
SpriteH:
MarioCape:
	rtl

print "Refills Cloud Mario's cloud once."