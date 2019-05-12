db $37
JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireball
JMP TopCorner : JMP BodyInside : JMP HeadInside
JMP WallFeet : JMP WallBody


MarioFireball:
	lda !ext_sprite_num,x
if !fireball_collect_coins == 1
	cmp #$05
	beq .fireball_found
endif	
if !iceball_collect_coins == 1
	cmp #!iceball_ext_num
	beq .iceball_found
endif
if !superball_collect_coins == 1
	cmp #!superball_ext_num
	beq .superball_found
endif
if !bubble_collect_coins == 1
	cmp #!bubble_ext_num
	beq .bubble_found
endif
if !hammer_collect_coins == 1
	cmp #!hammer_ext_num
	beq .hammer_found
endif
if !boomerang_collect_coins == 1
	cmp #!boomerang_ext_num
	beq .boomerang_found
endif
	rtl

.superball_found
.fireball_found
.iceball_found
.bubble_found
.hammer_found
.boomerang_found

collect_coin:
	lda $14AD|!addr
	beq return
if !superball_collect_coins == 1
	lda !ext_sprite_num,x
	cmp #!superball_ext_num
	bne +
	lda !ext_sprite_flags,x
	ora #$80
	sta !ext_sprite_flags,x
+
endif
	lda #$0F
	trb $98
	trb $9A
	phy
	lda #$01
	jsl $05B329
	%erase_block()
	%glitter()
	ply

return:
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
	rtl

print "Standard p-switch coin. Projectiles can collect it if the blue P-switch is active."