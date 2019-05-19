db $42

JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH
JMP Cape : JMP Fireball
JMP MarioCorner : JMP MarioInside : JMP MarioHead

!Sprite = $0E	; sprite number
!IsCustom = SEC ; CLC for normal, SEC custom sprite
!State = $08	; $08 for normal, $09 for carryable sprites
!1540_val = $3E	; If you use powerups, this should be $3E
				; Carryable sprites uses it as the stun timer

!ExtraByte1 = $00	; First extra byte (only applyable if extra bytes in GIEPY are enabled)
!ExtraByte2 = $00	; Second extra byte
!ExtraByte3 = $00	; Third extra byte
!ExtraByte4 = $00	; Fourth extra byte

!XPlacement = $00	; Remember: $01-$7F moves the sprite to the right and $80-$FF to the left.
!YPlacement = $00	; Remember: $01-$7F moves the sprite to the bottom and $80-$FF to the top.

!SoundEffect = $02
!APUPort = $1DFC|!addr

!bounce_num			= $03	; See RAM $1699 for more details. If set to 0, the block changes into the Map16 tile directly
!bounce_direction	= $00	; Should be generally $00
!bounce_block		= $0D	; See RAM $9C for more details. Can be set to $FF to change the tile manually
!bounce_properties	= $00	; YXPPCCCT properties

; If !bounce_block is $FF.
!bounce_Map16 = $0132		; Changes into the Map16 tile directly (also used if !bounce_num is 0x00)
!bounce_tile = $2A			; The tile number (low byte) if BBU is enabled

!item_memory_dependent = 0	; Makes the block stay collected
!InvisibleBlock = 0			; Not solid, doesn't detect sprites, can only be hit from below
!ActivatePerSpinJump = 0	; Activatable with a spin jump (doesn't work if invisible)
; 0 for false, 1 for true

if !ActivatePerSpinJump
MarioCorner:
MarioAbove:
	LDA $140D|!addr
	BEQ Return
	LDA $7D
	BMI Return
	LDA #$D0
	STA $7D
	BRA Cape
else
MarioCorner:
MarioAbove:
endif

Return:
MarioSide:
Fireball:
MarioInside:
MarioHead:

if !InvisibleBlock
SpriteH:
SpriteV:
Cape:
RTL


MarioBelow:
	LDA $7D
	BPL Return
else
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

MarioBelow:
Cape:
endif

SpawnItem:
	PHX
	PHY
if !bounce_num
	if !bounce_block == $FF
		LDA #!bounce_tile
		STA $02
		LDA.b #!bounce_Map16
		STA $03
		LDA.b #!bounce_Map16>>8
		STA $04
	endif
	LDA #!bounce_num
	LDX #!bounce_block
	LDY #!bounce_direction
	%spawn_bounce_sprite()
	LDA #!bounce_properties
	STA $1901|!addr,y
else
	REP #$10
	LDX #!bounce_Map16
	%change_map16()
	SEP #$10
endif

if !item_memory_dependent == 1
	PHK
	PEA .jsl_2_rts_return-1
	PEA $84CE
	JML $00C00D|!bank
.jsl_2_rts_return
	SEP #$10
endif

	LDA #!SoundEffect
	STA !APUPort

	LDA #!Sprite
	!IsCustom

	%spawn_sprite_block()
	TAX
	if !XPlacement
		LDA #!XPlacement
		STA $00
	else
		STZ $00
	endif
	if !YPlacement
		LDA #!YPlacement
		STA $01
	else
		STZ $01
	endif
	TXA
	%move_spawn_relative()

	LDA #!State
	STA !14C8,x
	LDA #!1540_val
	STA !1540,x
	LDA #$D0
	STA !AA,x
	LDA #$2C
	STA !154C,x

	LDA #!ExtraByte1
	STA !sprite_extra_byte1,x
	LDA #!ExtraByte2
	STA !sprite_extra_byte2,x
	LDA #!ExtraByte3
	STA !sprite_extra_byte3,x
	LDA #!ExtraByte4
	STA !sprite_extra_byte4,x

	lda #$01
	sta $02
	lda $15E9|!addr
	pha
	stx $15E9|!addr	
	%init_item()
	pla
	sta $15E9|!addr
	lda #$00
	sta !7FAB10,x

	LDA !190F,x
	BPL Return2
	LDA #$2C
	STA !15AC,x

Return2:
	PLY
	PLX
RTL

print "A block which spawns a cat bell."