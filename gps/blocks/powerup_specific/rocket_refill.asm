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
	cmp #!rocket_boots_powerup_num
	bne no_boots
	lda !power_ram
	beq no_boots
	lda #!rocket_boots_time
	sta !misc
	lda #$01
	sta !power_ram
no_boots:

MarioFireball:
SpriteV:
SpriteH:
MarioCape:
	rtl

print "Refills Rocket boots Mario's hover time."