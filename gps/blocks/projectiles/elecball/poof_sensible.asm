db $37
JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireball
JMP TopCorner : JMP BodyInside : JMP HeadInside
JMP WallFeet : JMP WallBody

MarioFireball:
	lda !ext_sprite_num,x
	cmp #!elecball_ext_num
	beq .elecball_found
	rtl
	
.elecball_found

activate_block:
	lda #$0F
	trb $98
	trb $9A
	%erase_block()
	%create_smoke()
	%give_points()


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
	RTL

print "Elecballs will vanish this block and won't stop/disable them. Follows the Acts Like setting for everything else."