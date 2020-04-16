db $37
JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireball
JMP TopCorner : JMP BodyInside : JMP HeadInside
JMP WallFeet : JMP WallBody



MarioFireball:
	lda !ext_sprite_num,x
if !fireball_activate_turn_block > 0
	cmp #$05
	bne +
	jmp .fireball_found
+	
endif	
if !iceball_activate_turn_block > 0
	cmp #!iceball_ext_num
	bne +
	jmp .iceball_found
+	
endif
if !superball_activate_turn_block > 0
	cmp #!superball_ext_num
	bne +
	jmp .superball_found
+	
endif
if !bubble_activate_turn_block > 0
	cmp #!bubble_ext_num
	bne +
	jmp .bubble_found
+	
endif
if !hammer_activate_turn_block > 0
	cmp #!hammer_ext_num
	bne +
	jmp .hammer_found
+	
endif
if !boomerang_activate_turn_block > 0
	cmp #!boomerang_ext_num
	bne +
	jmp .boomerang_found
+	
endif
if !elecball_activate_turn_block > 0
	cmp #!elecball_ext_num
	bne +
	jmp .elecball_found
+	
endif
	rtl



if !fireball_activate_turn_block > 0
.fireball_found
	stz !ext_sprite_num,x
	%create_smoke()
	if !fireball_activate_turn_block == 1
		jmp activate_block
	else
		jmp destroy_block
	endif
endif	



if !iceball_activate_turn_block > 0
.iceball_found
	lda !ext_sprite_table,x
	ora #$80
	sta !ext_sprite_table,x
	if !iceball_activate_turn_block == 1
		jmp activate_block
	else
		jmp destroy_block
	endif
endif



if !superball_activate_turn_block > 0
.superball_found
	if !superball_activate_delete == 1
		lda !ext_sprite_table,x
		ora #$80
		sta !ext_sprite_table,x
	endif	
	if !superball_activate_turn_block == 1
		jmp activate_block
	else
		jmp destroy_block
	endif
endif



if !bubble_activate_turn_block > 0
.bubble_found
	lda !ext_sprite_table,x
	ora #$80
	sta !ext_sprite_table,x
	if !bubble_activate_turn_block == 1
		jmp activate_block
	else
		jmp destroy_block
	endif
endif



if !hammer_activate_turn_block > 0
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
	if !hammer_activate_turn_block == 1
		jmp activate_block
	else
		jmp destroy_block
	endif
endif



if !boomerang_activate_turn_block > 0
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
	if !boomerang_activate_turn_block == 1
		jmp activate_block
	else
		jmp destroy_block
	endif
endif



if !elecball_activate_turn_block > 0
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
	if !elecball_activate_turn_block == 1
		jmp activate_block
	else
		jmp destroy_block
	endif
endif



activate_block:
	lda #$01
	sta $1DF9|!addr

	lda #$0F
	trb $98
	trb $9A
	
	phy
	lda #$05
	sta $9C
	jsl $00BEB0|!bank
	
	lda #$06
	sta $04
	stz $05
	stz $06
	lda #$0C
	sta $07
	phb
	lda #$02|!bank8
	pha
	plb
	jsl $028792|!bank
	plb
	ply
	rtl

destroy_block:
	lda #$0F
	trb $98
	trb $9A
	%shatter_block()
	%give_points()

SpriteH:
SpriteV:
MarioBelow:
WallFeet:
WallBody:
BodyInside:
HeadInside:
TopCorner:
MarioSide:
MarioCape:
MarioAbove:
return:
	rtl

print "Standard turn block. Projectiles can activate/destroy it."