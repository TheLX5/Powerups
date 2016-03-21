;; Ripped from Custom Other Sprites by imamelia and adapted to Asar.

incsrc ../powerup_defs.asm

if !SA1
	sa1rom
endif

org $028B6C|!base3
	autoclean JML MinorExSprite

freecode

MinorExSprite:
	BEQ	.Return
	STX	$1698|!base2
	CMP	#$0C
	BCC	.NoCustomSprites
	SEC	
	SBC	#$0C
	ASL	
	TAY	
	PHB	
	PHK	
	PLB	
	REP	#$30
	LDA	MinorExtendedPtrs,y
	STA	$00
	SEP	#$30
	PHK	
	PLA	
	STA	$02
	PHA	
	PLB	
	PHK	
	PEA.w	.FinishPointer-1
	JML	[$0000|!base1]
.FinishPointer	
	PLB		
.Return		
	JML	$028B74|!base3
.NoCustomSprites
	JML	$028B71|!base3

MinorExtendedPtrs:
dw MinorExSprite0C
dw MinorExSprite0D
dw MinorExSprite0E
dw MinorExSprite0F
;dw MinorExSprite10
;...
;dw MinorExSpriteFF

incsrc MinorExtendedSpritesCode.asm