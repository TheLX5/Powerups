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
	stz !ext_sprite_num,x
	%create_smoke()
	bra activate_block



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

.iceball_found
.superball_found
.bubble_found
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

print "Any projectile will break this block (with rainbow particles). Follows the Acts Like setting for everything else."