db $37
JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireball
JMP TopCorner : JMP BodyInside : JMP HeadInside
JMP WallFeet : JMP WallBody

MarioFireball:
	lda !ext_sprite_num,x
	cmp #$05
	beq .fireball_found
	rtl
	

.fireball_found
	stz !ext_sprite_num,x
	%create_smoke()

activate_block:
	lda #$0F
	trb $98
	trb $9A
	%shatter_block()
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

print "Fireballs will break this block. Follows the Acts Like setting for everything else."