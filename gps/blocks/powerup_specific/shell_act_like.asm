db $37
JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireball
JMP TopCorner : JMP BodyInside : JMP HeadInside
JMP WallFeet : JMP WallBody

MarioAbove:
MarioBelow:
MarioSide:
TopCorner:
BodyInside:
HeadInside:
WallFeet:
WallBody:
	lda $19
	cmp #!shell_suit_powerup_num
	bne no_shell
	lda !flags
	cmp #$01
	beq shell
no_shell:
SpriteV:
SpriteH:
MarioCape:
MarioFireball:
	ldy #$00
	lda #$25
	sta $1693|!addr
shell:
	rtl

print "Passable if Shell Mario isn't on his shell or if he isn't using a Shell Suit, uses the acts like number to determine its behavior when Mario is on his shell."