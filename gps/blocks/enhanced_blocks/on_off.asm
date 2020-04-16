db $37
JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireball
JMP TopCorner : JMP BodyInside : JMP HeadInside
JMP WallFeet : JMP WallBody



MarioFireball:
	lda !ext_sprite_num,x
if !fireball_activate_on_off == 1
	cmp #$05
	bne +
	jmp .fireball_found
+	
endif	
if !iceball_activate_on_off == 1
	cmp #!iceball_ext_num
	bne +
	jmp .iceball_found
+	
endif
if !superball_activate_on_off == 1
	cmp #!superball_ext_num
	bne +
	jmp .superball_found
+	
endif
if !bubble_activate_on_off == 1
	cmp #!bubble_ext_num
	bne +
	jmp .bubble_found
+	
endif	
if !hammer_activate_on_off == 1
	cmp #!hammer_ext_num
	bne +
	jmp .hammer_found
+	
endif
if !boomerang_activate_on_off == 1
	cmp #!boomerang_ext_num
	bne +
	jmp .boomerang_found
+	
endif	
if !elecball_activate_on_off == 1
	cmp #!elecball_ext_num
	bne +
	jmp .elecball_found
+	
endif	
	rtl



if !fireball_activate_on_off == 1
.fireball_found
	stz !ext_sprite_num,x
	lda #$01
	sta $1DF9|!addr
	%create_smoke()
	jmp activate_block
endif	



if !iceball_activate_on_off == 1
.iceball_found
	lda !ext_sprite_table,x
	ora #$80
	sta !ext_sprite_table,x
	lda #$01
	sta $1DF9|!addr
	jmp activate_block
endif



if !superball_activate_on_off == 1
.superball_found
	if !superball_activate_delete == 1
		lda !ext_sprite_table,x
		ora #$80
		sta !ext_sprite_table,x
		lda #$01
		sta $1DF9|!addr
	endif	
	jmp activate_block
endif



if !bubble_activate_on_off == 1
.bubble_found
	lda !ext_sprite_table,x
	ora #$80
	sta !ext_sprite_table,x
	jmp activate_block
endif



if !hammer_activate_on_off == 1
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
	jmp activate_block
endif



if !boomerang_activate_on_off == 1
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
	jmp activate_block
endif

if !elecball_activate_on_off == 1
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
	jmp activate_block
endif


activate_block:
	lda #$0F
	trb $98
	trb $9A
	
	phy
	lda #$09
	sta $9C
	jsl $00BEB0|!bank
	
	lda #$05
	sta $04
	stz $05
	stz $06
	lda #$13
	sta $07
	phb
	lda #$02|!bank8
	pha
	plb
	jsl $028792|!bank
	plb
	ply

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

print "Standard ON/OFF block. Projectiles can activate it."