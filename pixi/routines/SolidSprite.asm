; input:
; A = area size, format yyyyxxxx ; xxxx gets multiplied by 16.
;	Carry = Crush > CLC = Don't Crush, SEC = Crush
; return value in $8A:
; yx--rlbt
; t = touching top, b = touching bottom, l = touching left side, r = touching right side, m = in middle
; - 00 - no contact
; - 01 - touching top
; - 02 - touching bottom
; - 04 - touching left side
; - 08 - touching right side
; - 40 - in the middle X range
; - 80 - in the middle Y range

; Scratch ram $00-$0F will not be restored.

PlayerInteractRt:
	PHP
	STA $8A
	JSR SubSetInteractBounds
	LDA $45
	CMP $08
	BCC .SetLeft
	CMP $0C
	BCC .SetMiddleX
.SetRight
	LDY #$08
	BRA .SetXBits
.SetLeft
	LDY #$04
	BRA .SetXBits
.SetMiddleX
	LDY #$80
.SetXBits
	STY $8B
	LDA $47
	CMP $0A
	BCC .SetTop
	CMP $0E
	BCC .SetMiddleY
.SetBottom
	LDY #$02
	BRA .SetYBits
.SetTop
	LDY #$01
	BRA .SetYBits
.SetMiddleY
	LDY #$40
.SetYBits
	STY $8C
	SEP #$20
	LDA $8B
	ORA $8C
	STA $8A
	TAY
	LDA !190F,x
	LSR
	BCS .Platform
	CPY #$C0
	BEQ .CrushInMiddle
	TYA
	LSR
	BCS .PosTop
	LSR
	BCS .PosBottom
.TryAgain
	LSR
	BCS .PosLeft
	LSR
	BCS .PosRight
	PLP : RTL
.CrushInMiddle
	PLP : BCC .Return
	JSL $00F606|!BankB
.Return
	RTL
.Platform
	TYA
	LSR
	BCS .PosTop
	PLP : RTL
.PosBottom
	AND #$03
	BNE .TryAgain
	LDA #$10
	CLC
	ADC !AA,x
	STA $7D
	LDA #$01
	STA $1DF9|!Base2
	PLP : RTL
.PosLeft
	LDA !E4,x
	SEC
	SBC #$0E
	STA $94
	LDA !14E0,x
	SBC #$00
	STA $95
	LDA $7B
	BEQ ..Enough
	BMI ..Enough
	STZ $7B
..Enough
..Return
	PLP : RTL
.PosRight
	LDA $0C
	SEC
	SBC #$02
	STA $94
	LDA $0D
	SBC #$00
	STA $95
	LDA $7B
	BEQ ..Enough
	BPL ..Enough
	STZ $7B
..Enough
..Return
	PLP : RTL
.PosTop
	LDA $7D
	BMI ..Return
	LDA $77
	AND #$08
	BNE ..Return
	
	LDA #$E0
	LDY $187A|!Base2
	BEQ $03
	SEC
	SBC #$10
	LDY.w !AA,x
	BEQ $05
	BMI $03
	CLC
	ADC #$02
	CLC
	ADC !D8,x
	STA $96
	LDA !14D4,x
	ADC #$FF
	STA $97
	LDY #$00
	LDA $1491|!Base2
	BPL ..MovingRight
	DEY
..MovingRight
	CLC
	ADC $94
	STA $94
	TYA
	ADC $95
	STA $95
	
	LDA #$01
	STA $1471|!Base2
	LDA #$10
	STA $7D
	LDA #$80
	STA $1406|!Base2
..Return
	PLP : RTL

; after this:
; - $00-$01 = X position of player hitbox left boundary
; - $02-$03 = Y position of player hitbox top boundary
; - $04-$05 = X position of player hitbox right boundary
; - $06-$07 = Y position of player hitbox bottom boundary
; - $08-$09 = X position of sprite hitbox left boundary
; - $0A-$0B = Y position of sprite hitbox top boundary
; - $0C-$0D = X position of sprite hitbox right boundary
; - $0E-$0F = Y position of sprite hitbox bottom boundary
; - $45-$46 = X position of player hitbox middle boundary
; - $47-$48 = Y position of player hitbox middle boundary
; - $49-$4A = X position of sprite hitbox middle boundary
; - $4B-$4C = Y position of sprite hitbox middle boundary
SubSetInteractBounds:
	STZ $08
	STZ $09

	LDA #$FE
	STA $0A
	LDA #$FF
	STA $0B
	STZ $0D
	STZ $0F
	LDA $8A
	AND #$0F
	ASL #4
	CLC
	ADC #$10
	STA $0C
	BCC $02
	INC $0D
	LDA $8A
	AND #$F0
	CLC
	ADC #$14
	STA $0E
	BCC $02
	INC $0F

	JSR SetSpriteClipping2Main
	JSR SetPlayerClipping2Main
	JSR CheckForContact2Main
	BCC .ReturnNoContact
	REP #$20
	LDA $04
	LSR
	CLC
	ADC $00
	STA $45
	LDA $00
	CLC
	ADC $04
	STA $04
	LDA $06
	LSR
	CLC
	ADC $02
	STA $47
	LDA $02
	CLC
	ADC $06
	STA $06
	LDA $0C
	LSR
	CLC
	ADC $08
	STA $49
	LDA $08
	CLC
	ADC $0C
	STA $0C
	LDA $0E
	LSR
	CLC
	ADC $0A
	STA $4B
	LDA $0A
	CLC
	ADC $0E
	STA $0E
	RTS
.ReturnNoContact
	PLA
	PLA
	LDA #$00
	PLP : RTL

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;
; custom sprite clipping routine
;
; - Sets up a sprite's interaction field with 16-bit values
; - Input:
;	- $08-$09 = X displacement
;	- $0A-$0B = Y displacement
;	- $0C-$0D = width
;	- $0E-$0F = height
; - Output: None
; - Note: This should be used in conjunction with the following two routines.
;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SetSpriteClipping2Main:
	LDA !14E0,x
	XBA
	LDA !E4,x
	REP #$20
	CLC
	ADC $08
	STA $08
	SEP #$20
	LDA !14D4,x
	XBA
	LDA !D8,x
	REP #$20
	CLC
	ADC $0A
	STA $0A
	SEP #$20
	RTS

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;
; custom player clipping routine
;
; - Sets up the player's interaction field with 16-bit values
; - Input: None
; - Output: None
;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SetPlayerClipping2Main:
	PHX
	REP #$20
	LDA $94
	CLC
	ADC #$0002
	STA $00
	LDA #$000C
	STA $04
	SEP #$20
	LDX #$00
	LDA $73
	BNE .Inc1
	LDA $19
	BNE .Next1
.Inc1
	INX
.Next1
	LDA $187A|!Base2
	BEQ .Next2
	INX #2
.Next2
	LDA.l $03B660|!BankB,x
	STA $06
	STZ $07
	LDA.l $03B65C|!BankB,x
	REP #$20
	AND #$00FF
	CLC
	ADC $96
	STA $02
	SEP #$20
	PLX
	RTS

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;
; custom contact check routine
;
; - Checks for contact between whatever two things were set up previously
; - Input: $00-$07 = clipping set 1, $08-$0F = clipping set 2
; - Output: Carry clear = no contact, carry set = contact
;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

CheckForContact2Main:
	REP #$20
.CheckX
	LDA $00
	CMP $08
	BCC .CheckXSub2
.CheckXSub1
	SEC
	SBC $08
	CMP $0C
	BCS .ReturnNoContact
	BRA .CheckY
.CheckXSub2
	LDA $08
	SEC
	SBC $00
	CMP $04
	BCS .ReturnNoContact
.CheckY
	LDA $02
	CMP $0A
	BCC .CheckYSub2
.CheckYSub1
	SEC
	SBC $0A
	CMP $0E
	BCS .ReturnNoContact
.ReturnContact
	SEP #$21
	RTS
.CheckYSub2
	LDA $0A
	SEC
	SBC $02
	CMP $06
	BCC .ReturnContact
.ReturnNoContact
	CLC
	SEP #$20
	RTS