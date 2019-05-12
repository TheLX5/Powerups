db $37
JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireball
JMP TopCorner : JMP BodyInside : JMP HeadInside
JMP WallFeet : JMP WallBody

TopCorner:
MarioAbove:
	lda $19
	cmp #!PropSuit_powerup_num
	bne no_spin
	lda !flags
	and #$0F
	cmp #$04
	bne no_spin
	ldy #$00
	lda #$25
	sta $1693|!addr
	lda #$0F
	trb $98
	trb $9A
	%rainbow_shatter_block()
	%give_points()
no_spin:

MarioSide:
BodyInside:
HeadInside:
MarioFireball:
MarioBelow:
WallFeet:
WallBody:
SpriteV:
SpriteH:
MarioCape:
	rtl

print "A block that can be destroyed if hit by Propeller Mario while he's spin-attacking."