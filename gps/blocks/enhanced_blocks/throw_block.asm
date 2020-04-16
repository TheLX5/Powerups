db $37
JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireball
JMP TopCorner : JMP BodyInside : JMP HeadInside
JMP WallFeet : JMP WallBody



MarioFireball:
	lda !ext_sprite_num,x
if !fireball_activate_throw_block == 1
	cmp #$05
	beq +
	jmp .fireball_found
+	
endif	
if !iceball_activate_throw_block == 1
	cmp #!iceball_ext_num
	bne +
	jmp .iceball_found
+	
endif
if !superball_activate_throw_block == 1
	cmp #!superball_ext_num
	bne +
	jmp .superball_found
+	
endif
if !bubble_activate_throw_block == 1
	cmp #!bubble_ext_num
	bne +
	jmp .bubble_found
+	
endif
if !hammer_activate_throw_block == 1
	cmp #!hammer_ext_num
	bne +
	jmp .hammer_found
+	
endif
if !boomerang_activate_throw_block == 1
	cmp #!boomerang_ext_num
	bne +
	jmp .boomerang_found
+	
endif	
if !elecball_activate_throw_block == 1
	cmp #!elecball_ext_num
	bne +
	jmp .elecball_found
+	
endif	
	rtl



if !fireball_activate_throw_block == 1
.fireball_found
	stz !ext_sprite_num,x
	lda #$01
	sta $1DF9|!addr
	%create_smoke()
	jmp destroy_block
endif	



if !iceball_activate_throw_block == 1
.iceball_found
	lda !ext_sprite_table,x
	ora #$80
	sta !ext_sprite_table,x
	lda #$01
	sta $1DF9|!addr
	jmp destroy_block
endif



if !superball_activate_throw_block == 1
.superball_found
	if !superball_activate_delete == 1
		lda !ext_sprite_table,x
		ora #$80
		sta !ext_sprite_table,x
		lda #$01
		sta $1DF9|!addr
	endif	
	jmp destroy_block
endif



if !bubble_activate_throw_block == 1
.bubble_found
	lda !ext_sprite_table,x
	ora #$80
	sta !ext_sprite_table,x
	jmp destroy_block
endif



if !hammer_activate_throw_block == 1
.hammer_found
	phy
	lda !ext_sprite_table,x
	ora #$80
	sta !ext_sprite_table,x
	lda #$10
	ldy !ext_sprite_x_speed,x
	bmi ..left
	lda #$F0
..left	
	sta !ext_sprite_x_speed,x
	ply
	jmp destroy_block
endif



if !boomerang_activate_throw_block == 1
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
	phy
	lda !ext_sprite_table,x
	ora #$80
	sta !ext_sprite_table,x
	lda #$10
	ldy !ext_sprite_x_speed,x
	bmi ..left
	lda #$F0
..left	
	sta !ext_sprite_x_speed,x
	ply
	jmp destroy_block
endif




if !elecball_activate_throw_block == 1
.elecball_found
	if !elecball_activate_delete == 1
		stz $176F|!addr,x
		lda #$05
		sta !extended_dir,x
		lda #$03
		sta !ext_sprite_flags,x
		lda #$01
		sta $1DF9|!addr
	endif	
	jmp destroy_block
endif



destroy_block:
	lda #$0F
	trb $98
	trb $9A
	%rainbow_shatter_block()
	%give_points()

MarioBelow:
WallFeet:
WallBody:
BodyInside:
HeadInside:
MarioAbove:
TopCorner:
MarioSide:
MarioCape:
SpriteV:
SpriteH:
return:
	rtl

print "Standard throw block. Projectiles can destroy it."