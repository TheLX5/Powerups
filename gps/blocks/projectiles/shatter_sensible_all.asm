db $37
JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireball
JMP TopCorner : JMP BodyInside : JMP HeadInside
JMP WallFeet : JMP WallBody

MarioFireball:
	lda !ext_sprite_num,x
	cmp #$05
	beq .fireball_found
	cmp #!iceball_ext_num
	beq .iceball_found
	cmp #!superball_ext_num
	beq .superball_found
	cmp #!bubble_ext_num
	beq .bubble_found
	cmp #!hammer_ext_num
	beq .hammer_found
	cmp #!boomerang_ext_num
	beq .boomerang_found
	rtl
	

.fireball_found
.boomerang_found
.hammer_found
.iceball_found
.superball_found
.bubble_found

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

print "Any projectile will break this block and won't stop/disable them. Follows the Acts Like setting for everything else."