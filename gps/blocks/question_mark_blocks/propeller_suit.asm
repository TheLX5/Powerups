db $42

JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH
JMP Cape : JMP Fireball
JMP MarioCorner : JMP MarioInside : JMP MarioHead

!SoundEffect = $02
!APUPort = $1DFC
				
!bounce_num		= $03	; See RAM $1699 for more details
!bounce_direction	= $00	; Should be generally $00
!bounce_block		= $0D	; See RAM $9C for more details
!bounce_properties	= $00	; YXPPCCCT properties

!RAM = $19	; This determines which item it spawns whether it is to the zero or not.
		; See the RAM map for more details

!Placement = %move_spawn_into_block()
		; Use %move_spawn_above_block() if the sprites should appear above the block
		; Note: Affects both sprites!

!item_memory_dependant = 0	; 0 for false, 1 for true

; The first argument is if Mario is small, the second for big
SpriteNumber:
db $74,$0A

IsCustom:
db $00,$01	; $00 (or any other even number) for normal, $01 (or any other odd number) for custom

State:
db $08,$08	; Should be either $08 or $09

RAM_1540_vals:
db $3E,$3E	; If you use powerups, this should be $3E
	; Carryable sprites uses it as the stun timer

Return:
MarioAbove:
MarioSide:
Fireball:
MarioCorner:
MarioInside:
MarioHead:
RTL

SpriteH:
	%check_sprite_kicked_horizontal()
	BCS SpriteShared
RTL

SpriteV:
	LDA !14C8,x
	CMP #$09
	BCC Return
	LDA !AA,x
	BPL Return
	LDA #$10
	STA !AA,x

SpriteShared:
	%sprite_block_position()

Cape:
MarioBelow:
SpawnItem:
	lda $15E9|!addr
	pha
	PHX
	PHY
	LDA #!bounce_num
	LDX #!bounce_block
	LDY #!bounce_direction
	%spawn_bounce_sprite()
if !item_memory_dependant == 1
	PHK
	PEA .jsl_2_rts_return-1
	PEA $84CE
	JML $00C00D
.jsl_2_rts_return
	SEP #$10
endif
	LDA #!SoundEffect
	STA !APUPort
	LDY #$00
	LDA !RAM
	BEQ +
	LDY #$01
+	LDA IsCustom,y
	LSR
	php
	LDA SpriteNumber,y

	%spawn_sprite_block()
	TAX
	plp
	bcs above
	%move_spawn_into_block()
	bra cont
above:
	%move_spawn_above_block()
cont:
	LDA.w State,y
	STA !14C8,x
	LDA.w RAM_1540_vals,y
	STA !1540,x
	LDA #$D0
	STA !AA,x
	LDA #$2C
	STA !154C,x
	lda #$01
	sta $02
	stx $15E9|!addr	
	%init_item()
	LDA !190F,x
	BPL Return2
	LDA #$2C
	STA !15AC,x
Return2:
	PLY
	PLX
	pla
	sta $15E9|!addr
RTL

print "A block which spawns by default a mushroom if Mario is small, else a propeller suit."