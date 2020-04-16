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
	stz $176F|!addr,x
	lda #$05
	sta !extended_dir,x
	lda #$03
	sta !ext_sprite_flags,x
	lda #$01
	sta $1DF9|!addr

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

print "Immune to elecballs. Follows the Acts Like setting for everything else."