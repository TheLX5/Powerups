db $37
JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireball
JMP TopCorner : JMP BodyInside : JMP HeadInside
JMP WallFeet : JMP WallBody

MarioFireball:
	lda !ext_sprite_num,x
	cmp #!hammer_ext_num
	beq .hammer_found
	rtl
	

.hammer_found
	phy
	lda #$10
	ldy !ext_sprite_x_speed,x
	bmi ..left
	lda #$F0
..left	
	sta !ext_sprite_x_speed,x
	ply

	lda #$01
	sta $1DF9|!addr
	lda !ext_sprite_table,x
	ora #$80
	sta !ext_sprite_table,x

activate_block:
	lda #$0F
	trb $98
	trb $9A
	%rainbow_shatter_block()
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

print "Hammers will break this block and will spawn rainbow particles. Follows the Acts Like setting for everything else."