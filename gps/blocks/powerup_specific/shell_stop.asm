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
	cmp #!shell_suit_powerup_num
	bne no_shell
	lda !flags
	cmp #$01
	bne no_shell
	lda #$00
	sta !flags
no_shell:

MarioFireball:
SpriteV:
SpriteH:
MarioCape:
	rtl

print "Stops Mario's ride on his shell if he's on a Shell Suit."