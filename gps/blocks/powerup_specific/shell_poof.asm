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
	cmp #!shell_suit_powerup_num
	bne no_shell
	lda !flags
	cmp #$01
	bne no_shell
	ldy #$00
	lda #$25
	sta $1693|!addr
	lda #$0F
	trb $98
	trb $9A
	%erase_block()
	%create_smoke()
	%give_points()
no_shell:

MarioFireball:
MarioBelow:
MarioAbove:
WallFeet:
WallBody:
SpriteV:
SpriteH:
MarioCape:
	rtl

print "A block that disappears leaving a smoke cloud by Shell Mario in his shell form."