db $37
JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireball
JMP TopCorner : JMP BodyInside : JMP HeadInside
JMP WallFeet : JMP WallBody

MarioFireball:
	lda !ext_sprite_num,x
	cmp #!boomerang_ext_num
	beq .boomerang_found
	rtl


.boomerang_found
	lda !ext_sprite_table,x
	and #$DF
	sta !ext_sprite_table,x
	lda !ext_sprite_flags,x
	tay
	lda !ext_sprite_index,x
	bmi +
	phx
	tax
	tya
	sta !1686,x
	lda #$00
	sta !sprite_ram,x
	plx
+	

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

print "Boomerangs will vanish this block. Follows the Acts Like setting for everything else."