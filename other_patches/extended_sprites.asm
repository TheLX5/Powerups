;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Extended Sprites Extender (Bad name)
;; 
;; Description: Adds several new (and modified) extended sprites to SMW.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

incsrc ../powerup_defs.asm

if !SA1
	sa1rom
endif

org $029B16|!base3
	autoclean JML ExtendedSpr

incsrc extended_sprites_addon.asm

;;;;;;;;;;;;;;;;;;;;;;;;;
;; Macros
;;;;;;;;;;;;;;;;;;;;;;;;;

macro prepare()
	SEP #$30
endmacro

macro give_coins(num)
	LDA #<num>
	JSL $05B329|!base3
endmacro

macro create_glitter()
	PHK	
	PEA.w	?glitter-1
	PEA.w	$84CF-1
	JML	$00FD5A
?glitter:	
endmacro

macro trigger_on_off()
	LDA	#$05
	STA	$04
	STZ	$05
	STZ	$06
	LDA	#$13
	STA	$07
	PHY	
	PHB	
	LDA	#$02
	PHA	
	PLB	
	JSL	$028792|!base3
	PLB	
	PLY	
endmacro

macro generate_smw_tile(value)
	PHY	
	LDA	#<value>
	STA	$9C
	JSL	$00BEB0|!base3
	PLY	
endmacro

macro generate_smoke()
	JSR	SubSmoke
endmacro

macro return()
	RTS	
endmacro

macro shatter_block(type)
	PHY	
	PHB	
	LDA	#$02
	PHA	
	PLB	
	LDA	#<type>
	JSL	$028663|!base3
	PLB	
	PLY	
endmacro

macro kill_hammer_boomerang()
	JSR	.ReleaseItemFromBoomerang
	TYX	
	LDA	!extra_extended_2,x
	ORA	#$80
	STA	!extra_extended_2,x
	LDA	#$10
	LDX	$1747|!base2,y
	BMI	?minus
	LDA	#$F0	
?minus:		
	STA	$1747|!base2,y
endmacro

macro generate_sound(sfx,port)
	LDA #<sfx>
	STA <port>|!base2
endmacro

macro release_item_from_boomerang()
	LDA	$170B|!base2,y
	CMP	#!boomerang_num		;check if boomerang
	BNE	?no
	PHY	
	TYX	
	LDA	!extra_extended_2,x
	AND	#$BF			;clear "carry sprite" bit
	STA	!extra_extended_2,x
	LDA	!extra_extended_3,x	;Get $1686 info.
	TAY	
	LDA	!extra_extended_4,x	;Get sprite index.
	PHX	
	TAX	
	TYA	
	STA	!1686,x			;make it interact with objects again
	LDA	#$00
	STA	!extra_sprites,x
	PLX	
	PLY	
?no:		
endmacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Freespace
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

freecode

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Code
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

power_dynamic_tiles:
		db !projectile_dma_tile+2,!projectile_dma_tile
PowerOAM:
		db $F8,$FC

ExtendedSpr:
	PHB	
	PHK	
	PLB	
	LDA	$170B|!base2,x
	BEQ	.ret		; return if sprite is #$00
	CMP	#$13
	BCS	+			; branch if sprite is #$13 or above.
	PLB	
	JML	$029B1B|!base3	; if not, reference original code
.ret	PLB	
	JML	$029B15|!base3	; return
+	LDA	$170B|!base2,x
	CMP	#!iceball_num
	BNE	+			; branch if sprite isn't #$13
++	PLB	
	JML	$029FAF|!base3	; if it is, reference original fireball code.
+	JSR	Pointer		;	 load pointer
	BRA	.ret		; branch to return.

Pointer:
	LDA	$170B|!base2,x	; handle the pointer by doing some math.
	SEC	
	SBC	#$14
	LDY	$9D
	BNE	+
	LDY	$176F|!base2,x
	BEQ	+
	DEC	$176F|!base2,x	; decrement the timer.
+	JSL	$0086DF|!base3
		
	incsrc extended_sprites_pointers.asm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Adapted from original routines.

;; original extended sprite -> sprite interaction.
Hit_Sprite:
	PHK
	PEA.w .hitspr-1
	PEA.w $B889-1
	JML $02A0AC|!base3
.hitspr	RTS

;; extended sprite -> mario interaction.
Hit_Mario:
	JSR ExtSprClip
	JSL $03B664|!base3
	JSL $03B72B|!base3
	BCC .hitmar
	PHB
	LDA #($02|!base3>>16)
	PHA
	PLB
	PHK
	PEA.w .retur-1
	PEA.w $B889-1
	JML $02A469|!base3
.retur	PLB 
.hitmar	RTS

SubSmoke:
	LDX #$03
-
	LDA $17C0|!base2,x
	BEQ +
	DEX
	BPL -
	RTS
+
	LDA #$01
	STA $17C0|!base2,x
	LDA #$1B    
	STA $17CC|!base2,x
	LDA $1715|!base2,y
	STA $17C4|!base2,x
	LDA $171F|!base2,y
	STA $17C8|!base2,x
	RTS

;; extended sprite clipping size.
ExtSprClip:
	LDA	$170B|!base2,x
	SEC	
	SBC	#$13
	TAY	
	LDA	$171F|!base2,x
	CLC	
	ADC.w	PosX,y
	STA	$04
	LDA	$1733|!base2,x
	ADC	#$00
	STA	$0A
	LDA.w	LengthX,y
	STA	$06
	LDA	$1715|!base2,x
	CLC	
	ADC.w	PosY,y
	STA	$05
	LDA	$1729|!base2,x
	ADC	#$00
	STA	$0B
	LDA.w	LengthY,y
	STA	$07
	RTS	
;special_treat:
;	LDA	!extra_extended,x
;	LDA	$171F|!base2,x
;	CLC	
;	RTS
PosX:
	db $02,$01,$01,$02,$01
LengthX:
	db $04,$06,$0E,$0C,$0D
PosY:
	db $01,$01,$01,$02,$01
LengthY:
	db $01,$06,$0E,$0C,$0D

;; sprite x + y speed handler; has gravity.
SpriteSpd:
	LDA $173D|!base2,x
	CMP #$40
	BPL SpriteSpdNoGravity
	CLC
	ADC #$03
	STA $173D|!base2,x

;; sprite x + y speed handler; no gravity.
SpriteSpdNoGravity:
	JSR SpriteYSpd

;; original sprite x speed handler.
SpriteXSpd:
	PHK
	PEA.w .donex-1
	PEA.w $B889-1
	JML $02B554|!base3
.donex	RTS

;; original sprite y speed handler.
SpriteYSpd:
	PHK
	PEA.w .doney-1
	PEA.w $B889-1
	JML $02B560|!base3
.doney	RTS

;; original extended sprite -> object routine.
ObjInteraction:
	PHK
	PEA.w .noobj-1
	PEA.w $B889-1
	JML $02A56E|!base3
.noobj	
	RTS

;; Gets the OAM index to be used, deletes when off screen, etc.
;; ExtGetDraw_NoIndex variation to be used if handling OAM through alternate methods.
OAMPtr:	db $90,$94,$98,$9C,$A0,$A4,$A8,$AC
ExtGetDrawInfo:
	LDY.w OAMPtr,x
ExtGetDraw_NoIndex:
	LDA $1747|!base2,x
	AND #$80
	EOR #$80
	LSR
	STA $00
	LDA $171F|!base2,x
	SEC
	SBC $1A
	STA $01
	LDA $1733|!base2,x
	SBC $1B
	BNE .erasespr
+	LDA $1715|!base2,x
	SEC
	SBC $1C
	STA $02
	LDA $1729|!base2,x
	ADC $1D
	BEQ .neg
	LDA $02
	CMP #$F0
	BCS .erasespr
	RTS
.neg	LDA $02
	CMP #$C0
	BCC .erasespr
	CMP #$E0
	BCC .hidespr
	RTS
.erasespr
	STZ	$170B|!base2,x	; delete sprite.
	LDA	!extra_extended_2,x
	AND	#$BF			;clear "carry sprite" bit
	STA	!extra_extended_2,x
	LDA	!extra_extended_3,x	;Get $1686 info.
	TAY	
	LDA	!extra_extended_4,x	;Get sprite index.
	PHX	
	TAX	
	TYA	
	STA	!1686,x			;make it interact with objects again
	LDA	#$00
	STA	!extra_sprites,x
	PLX	
	JSR	check_dma
.hidespr
	LDA #$F0	; prevent OAM flicker
	STA $02
 +	RTS

GetMap16:	
	LDA	$1715|!base2,x
	CLC	
	ADC	#$08
	STA	$00
	AND	#$F0
	STA	$98
	LDA	$1729|!base2,x
	ADC	#$00
	STA	$01
	STA	$99
	LDA	$171F|!base2,x
	CLC	
	ADC	#$08
	STA	$02
	AND	#$F0
	STA	$9A
	LDA	$1733|!base2,x
	ADC	#$00
	STA	$03
	STA	$9B
	PHX	
	JSR	Map16Interact
	PLX	
	LDA	[$05]
	XBA	
	INC	$07
	LDA	[$05]
	XBA	
if !use_map16_only == 0
	REP	#$30
	PHY	
	AND	#$3FFF
	ASL	
	TAY	
	LDA	$06F624|!base3
	STA	$0A
	LDA	$06F626|!base3
	STA	$0C
	LDA	[$0A],y
	PLY	
	SEP	#$30
endif
	RTS	

Map16Interact:
	LDA	$00 
	AND	#$F0
	STA	$06 
	LDA	$02 
	LSR	#4
	ORA	$06
	PHA	
	LDA	$5B 
	AND	#$01
	BEQ	.verticallvl
	PLA	
	LDX	$01 
	CLC	
	ADC	$00BA80|!base3,x
	STA	$05
	LDA	$00BABC|!base3,x
	ADC	$03
	STA	$06
	BRA	.setbank
.verticallvl	
	PLA	
	LDX	$03 
	CLC	
	ADC.l	$00BA60|!base3,x
	STA	$05 
	LDA.l	$00BA9C|!base3,x
	ADC	$01 
	STA	$06 
.setbank
if !SA1
	LDA.b	#$40
else	
	LDA.b	#$7E
endif
	STA	$07
	RTS	

check_dma:
	PHX 
	LDX #$09
.loop	
	LDA $170B|!base2,x
	BEQ .found_slot
	DEX 
	CPX #$07
	BNE .loop
	LDA #$00
	STA !projectile_do_dma
.found_slot
	PLX 
	RTS 

incsrc projectile_blocks.asm