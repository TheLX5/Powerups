;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Item Box Special - Version 1.1, by imamelia
;;
;; This patch allows you to do several things with the
;; item box.  See the readme for details.
;;
;; Credit to Kenny3900 for the original Item Box GFX Fix patch.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

incsrc ../powerup_defs.asm

if !SA1
	sa1rom
endif

!RAM_ItemDisable = $7F9678	; the RAM address that will be used for disabling dropping the item and other things

!ItemBoxSfx = $0C       ; play the item box drop sound effect
!PowerupSfx = $0B       ; play the powerup sound effect

!ItemPosX1 = $78	; the X position of the item on the screen
!ItemPosY1 = $0F	; the Y position of the item on the screen
!ItemPosX2 = $78	; the X position of the item when it spawns
!ItemPosY2 = $20	; the Y position of the item when it spawns
 
;org $00F5F8|!base3		; x77F8; disables the item falling automatically when you get hurt
;db $EA,$EA,$EA,$EA	; 22 08 80 02

org $01C540|!base3	; checks which item to put in the item box
autoclean JSL CheckItem	; don't overwrite the item box unless it is empty
LDA $19                 ; you can change "autoclean JSL CheckItem"
BEQ SkipSfx             ; to "BRA $02 NOP #2" if you don't want powerups to put anything in the item box at all
LDA #!PowerupSfx        ; \ sound effect
STA $1DFC|!base2               ; /

SkipSfx:


org $009095|!base3
autoclean JML ItemBoxFix	; execute custom code for item box graphics routine

org $028008|!base3
JML ItemBoxDrop		; execute custom code for item box item drop routine
dl ItemTilemap
db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; erase the entire original code
db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; you can use this area as freespace
db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; if you like - 0x66, or 102, bytes
db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; beginning at $02800C and ending
db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; at $028071
db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF	; 
db $FF,$FF,$FF,$FF,$FF,$FF					;

;NOP #102			; I decided to use $FF's instead of NOPs.

org $009F6F|!base3		; part of the overworld fade-in routine
autoclean JML ClearDisable	; clear the item disable flag automatically

freecode

Statuses:			; sprite statuses, 4 possible
db $08,$01,$09,$00	; normal, init, stunned, nonexistent

CheckItem:
	PHB	
	PHK	
	PLB	
	LDA	!190F,x
	BMI	.custom
	LDA	!9E,x
	SEC	
	SBC	#$74
	BRA	.next
.custom		
	LDA	!7FAB9E,x
	SEC	
	SBC.b	#!starting_slot
	CLC	
	ADC	#$05
.next		
	STA	$4202
	LDA	#!max_powerup+1
	STA	$4203
	LDA	#$00
	XBA	
	LDA	$19
	CLC	
	REP	#$30
	ADC	$4216
	TAY	
	SEP	#$20
	LDA.w	PutInBox,y
	BEQ	.noitem
	STA	$00
	CMP	#$01
	BNE	.store
	LDA	$0DC2|!base2
	BEQ	.store
	CMP	#$02
	BCS	.noitem
.store		
	LDA	$00
	STA	$0DC2|!base2
	LDA	#$0B
	STA	$1DFC|!base2
.noitem
	LDA.w	PowerIndex,y
	SEP	#$10
	PLB	
	CMP	#$06
	BCS	.notoriginal
.run_original
	CMP	#$01
	BEQ	+
	PHA	
	LDA	#$00
	STA	!clipping_flag
	STA	!collision_flag
	PLA	
+		
	JML	$01C550|!base3
.notoriginal	
	SEC	
	SBC	#$06
	PHA	
	CLC	
	ADC	#$04
	CMP	$19
	BNE	+
	JMP	GiveNothing
+		
	PLA	
	JSL	$0086DF|!base3

macro flower_item(num,sfx,port)
	LDA	#$20
	STA	$149B|!base2
	STA	$9D
	LDA	#$04
	STA	$71
	LDA	#<num>
	STA	$19
	LDA	#$00
	STA	!clipping_flag
	STA	!collision_flag
	LDA	#$04
	LDY	!1534,x
	BNE	+
	JSL	$02ACE5|!base3
+		
	LDA	#$0A
	STA	$1DF9|!base2
	JMP	clean_ram
endmacro

macro cape_item(num,sfx,port)
	LDA	#$00
	STA	!clipping_flag
	STA	!collision_flag
	LDA	#<num>
	STA	$19
	LDA	#<sfx>
	STA	<port>|!base2
	LDA	#$04
	JSL	$02ACE5|!base3
	JSL	$01C5AE|!base3
	INC	$9D
	JMP	clean_ram
endmacro	

.PowerupPointers
	incsrc get_powerup_codes.asm

GiveNothing:	
Return:		
clean_ram:	
	LDA	#$00
	STA	!disable_spin_jump
	STA	!mask_15
	STA	!mask_17
	STA	!flags
	STA 	!timer
	STA 	!misc
	STA	!shell_immunity
	JML	$01C560|!base3

ItemBoxFix:

PHX			;
PHP			;
LDA !RAM_ItemDisable	; check the item disable RAM (duh)
AND #$02		; if bit 1 is set...
BNE NoDraw		; don't draw the item in the box
LDY $01			; $01, I guess, holds the OAM index for the item tile?
LDA #$00			; 00 --> A
XBA			; clear the high byte of A
LDA #!ItemPosX1		;
STA $0200|!base2,y	; set the X position of the item
LDA #!ItemPosY1		;
STA $0201|!base2,y	; set the Y position of the item
LDA $0DC2|!base2	; use the value of the item box to determine
REP #$30			; the item tile number and properties
ASL			; item number x2, because we're loading both bytes
TAX			; result into X
LDA.l ItemTilemap,x	; load the item tilemap and properties
STA $0202|!base2,y	; store to extended OAM
NoDraw:			;
PLP			;
PLX			;
JML $0090C7|!base3	; finish with original code

NoItem:			;
RTL			;

ActivateEffect:
;STA $7FB000		;
JSR ExecuteEffectPointer	;
JMP EndItemDrop

ItemBoxDrop:

LDA !RAM_ItemDisable	; if the item box drop is disabled...
AND #$01		; (i.e. bit 0 of the disable RAM is set)
BNE NoItem		; treat the item box as if it were empty
LDA $0DC2|!base2	; load the item box value
BEQ NoItem		; if it is zero, then the player has no item

PHX			;
PHY			; preserve registers
PHB			;
PHK			; change the data bank
PLB			;

LDY $0DC2|!base2	; index all tables by Y, since X will have our sprite index
LDA Settings,y		; check the settings table
BMI ActivateEffect		; if bit 7 is set, activate an effect instead of spawning a sprite

LDA #$0C			; play a sound effect
STA $1DFC|!base2	; item box drop sound

JSR FindFreeSlot		; find a free sprite slot

PHY			; preserve the table index
LDA Settings,y		; check the settings table
AND #$03		; use bits 0 and 1
TAY			; to determine the sprite status
LDA Statuses,y		;
STA !14C8,x		; set the spawned sprite status
PLY			; pull back the table index

LDA Settings,y		; check the settings table
AND #$10		; if bit 4 is set...
BNE SpawnCustom		; we're spawning a custom sprite

SpawnNormal:		;

LDA SpriteNumber,y		;
STA !9E,x			; set the sprite number
PHY			;
JSL $07F7D2|!base3		; reset sprite tables
PLY			;
LDA !9E,x
CMP #$19
BNE NotMessage
LDA #$09
STA !14C8,x
LDA #$3E
STA !9E,x
PHY			;
JSL $07F7D2|!base3		; reset sprite tables
PLY			;
LDA #$01
STA !151C,x
LDA $018467|!base3
STA !15F6,x
BRA FinishSpawn		; finish the spawning routine

NotMessage:
LDA !9E,x
CMP #$3E
BNE NotPSwitch
STZ !151C,x
LDA $018466|!base3
BRA FinishSpawn

NotPSwitch:
LDA !9E,x
CMP #$53
BNE NotThrowBlock
LDA #$FF
STA !1540,x

NotThrowBlock:
BRA FinishSpawn

SpawnCustom:		;

LDA SpriteNumber,y		;
STA !7FAB9E,x		; set the sprite number
PHY			;
JSL $07F7D2|!base3	; reset sprite tables
JSL $0187A7|!base3	; get new table values for custom sprites
PLY			;
LDA Settings,y		;
AND #$0C		; get bits 2 and 3 of the settings table
ORA #$80			;
STA !7FAB10,x		; store to sprite extra bit table

FinishSpawn:		;

LDA #!ItemPosX2		; base X position
CLC			;
ADC $1A			; add the screen position so that the sprite
STA !E4,x			; always spawns relative to the screen
LDA $1B			; screen position high byte
ADC #$00		; handle overflow
STA !14E0,x		;

LDA #!ItemPosY2		; base Y position
CLC			;
ADC $1C			; add the screen position so that the sprite
STA !D8,x		; always spawns relative to the screen
LDA $1D			; screen position high byte
ADC #$00		; handle overflow
STA !14D4,x		;

LDA Settings,y		; check the settings
AND #$20		; if bit 5 is set...
BEQ EndItemDrop		; then increment a certain sprite table so the sprite will flash as it drops
;INC !1534,x		; This was done in the original SMW only with the mushroom and flower.
EndItemDrop:		;

STZ $0DC2|!base2

PLB			;
PLY			; pull everything back
PLX			;
RTL			; end the item box drop routine

FindFreeSlot:	;

LDX #$0B		; 12 sprites to loop through
SlotLoop:		;
LDA !14C8,x	; check the sprite status of the sprite in this slot
BEQ FoundSlot	; if 00, then the slot is free
DEX		; decrement the index
BPL SlotLoop	; loop if there are more slots to check
DEC $1861|!base2	; if none of the 12 sprite slots are free, then decrement...something.
BPL FoundSlot	; I'm guessing $1861 has something to do with holding the oldest sprite index...
LDA #$01		; reset it if necessary
STA $1861|!base2	; The way this subroutine works, there will *always* be a sprite slot for the item,
FoundSlot:	; even if it means overwriting another one.
RTS		; That's why I couldn't just use $02A9DE or $02A9E4 to get a free slot.

ClearDisable:

LDA #$00			;
STA !RAM_ItemDisable	; clear all disable flags
DEC $0DB1|!base2	; restore
BPL EndOWCode		; hijacked code
JML $009F74|!base3		;
EndOWCode:		;
JML $009F6E|!base3		;

ExecuteEffectPointer:

LDA SpriteNumber,y		; load the sprite number (or, in this case, the effect number)
PHX			; preserve X, because there is a very likely chance that it is already being used
ASL A			; multiply the base value to get the desired index
TAX			; put the resulting value into X
REP #$20			; set A to 16-bit
LDA EffectPointers,x	; load value from effect pointer table
STA $0A			; and store that to scratch RAM
SEP #$20			; set A back to 8-bit
PLX			; pull X register back
JMP ($000A|!base1)	; jump to address that was stored

EffectPointers:		;
dw Effect00		;
dw Effect01		;
dw Effect02		;
dw Effect03		;
dw Effect04		;
dw Effect05		;
dw Effect06		;
dw Effect07		;
dw Effect08		;
dw Effect09		;
dw Effect0A		;
dw Effect0B		;
dw Effect0C		;
dw Effect0D		;
dw Effect0E		;
dw Effect0F		;

Effect00:			;
Effect01:			;
Effect02:			;
Effect03:			;
Effect04:			;
Effect05:			;
Effect06:			;
Effect07:			;
Effect08:			;
Effect09:			;
Effect0A:			;
Effect0B:			;
Effect0C:			;
Effect0D:			;
Effect0E:			;
Effect0F:			;
RTS

incsrc item_box_tables.asm