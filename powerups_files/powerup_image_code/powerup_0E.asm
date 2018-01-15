;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; /				    \ ;
;|  Propeller Mushroom image engine  |;
; \				    / ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	lda $75
	ora $74
	bne .DrawPropellerTile
	LdA $71
	SeC : SbC #$05
	Cmp #$02
	BCS +
	LdA $89
	AND #$03
	BEq ++
	Dec : BNE +

++	LdX $13DB|!base2
	LdA HorizontalPipeWalkingImages,x
	StA $13E0|!base2

+	LdA !PropStatus
	AND #$7F
	BEq .DrawPropellerTile

	LdA !PropPlayerFrame : TAX
	AND #$02
	LSR
	StA $76
	LdA Images,x
	StA $13E0|!base2

;<  Draw the propeller tile >;

.DrawPropellerTile
	LdA $13E0|!base2 : PhA
	Cmp #$15		;\
	BCC +++			; |
	Cmp #$26		; |
	BEq ++			; |
	Cmp #$33		; | Waste some CPU to make some calculations for not making
	BEq +			; | the X offsets table too big.
	Cmp #$4E
	BCS ++++
	LdA #$1F		; |
+	SeC : SbC #$1F		; |
	Bra +++			; |
++	LdA #$17		;/
	Bra +++
++++	LdA #$16
+++	ASL			;\  Shift one bit to the left and combine with the head's X 
	ORA $76			;/  flip to make the entries in the table be pairs of bytes,
				;   one when looking to the left and the other to the right.
	TAX			;>  Transfer our index to X.

	LdA #$00		;>  Load #$00 for the next routine.
	LdY XOffsets,x		;>  Load a low byte in Y to form a 16-bit value.
	JSr GetHighByte		;>  Get the 16-bit value according to data.
	StA !PropTileXOffset	;>  Store X offset.
	SeP #$20		;>  Go back to 8-bit mode.

	PlX
	LdA #$00
	LdY YOffsets,x
	JSr GetHighByte
	StA !PropTileYOffset
	SeP #$20

	LdA $13			;\  If not time to update the propeller image's main
	AND !PropFlipFrequency  ; | index...
;	ORA $9D
	BNE .DontUpdateFrame	;/  ...continue.
	LdA $71
	Dec
	Cmp #$04
	BCC .DontUpdateFrame

	LdA !PropTileAngle	;\
	Inc			; |
	Cmp #$04		; |
	BCC .DontReset		; | 
	LdA #$00		; |
.DontReset			; |
	StA !PropTileAngle	;/
.DontUpdateFrame

	LdA PropellerTileIndexes,x
	StA $00
	BEq .NoXFlp
	Cmp #$14
	BEq .NoXFlp
	LdA $76
	ASL #6
.NoXFlp
	AND #%01000000
	ORA #%00010001
	StA !PropTileFlags

	LdA !PropTileAngle
	ORA $00
	ASL
	StA !PropTileFrame

	RtS

ClearTile:
	LdA #%00000000
	StA !PropTileFlags
	RtS

;<  Sets A to a 16-bit value in the range #$FF80 - #$007F  >;

;> Inputs:
; ¬ A must be #$00.
; ¬ Y must be the low byte of the final 16-bit value. Also it must be loaded after A.
;> Outputs:
; ¬ A will be 16-bit and his value will be in a range from #$FF80 - #$007F.
; ¬ X and Y won't be changed.

GetHighByte:
	BPl .NoNeg
	Dec
.NoNeg	XBA
	TYA
	ReP #$20
	RtS

; /	   \ ;
;|  Tables  |;
; \	   / ;

Images:
	db $47,$46,$47,$48\
	  ,$24,$49,$24,$4A\
	  ,$4C,$4B,$4C,$4D
HorizontalPipeWalkingImages:
	db $4E,$4F,$50

PropellerTileIndexes:
	db $00,$00,$00,$04,$00,$00,$00,$00\
	  ,$00,$00,$04,$00,$00,$00,$00,$00\
	  ,$10,$04,$04,$04,$00,$00,$00,$00\
	  ,$00,$00,$00,$00,$00,$00,$00,$00\
	  ,$00,$00,$00,$00,$00,$00,$00,$00\
	  ,$00,$00,$00,$00,$00,$00,$00,$00\
	  ,$14,$14,$00,$04,$00,$00,$00,$00\
	  ,$00,$00,$00,$00,$00\
	  ,$00,$00,$00,$00,$00,$00,$00,$00\
	  ,$00\
	  ,$00,$00,$00,$00,$00,$00,$00,$00\
	  ,$00,$00,$00

YOffsets:
	db $F4,$F4,$F4,$04,$F4,$F4,$F4,$F4\
	  ,$F4,$F4,$04,$F4,$F4,$F3,$F4,$F4\
	  ,$FB,$01,$01,$01,$F4,$F4,$F4\
	  ,$F4,$F4,$F4,$F4,$F3,$F4,$FB,$F4\
	  ,$F4,$F4,$F4,$F4,$F4,$F1,$F4,$F4\
	  ,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4\
	  ,$FF,$F4,$F4,$F5,$03,$F4,$F7,$F5\
	  ,$F8,$FC,$F4,$F8,$F8,$01\
	  ,$FF,$FF,$F4,$FF,$FF,$FF,$F2,$F4\
	  ,$F4\
	  ,$F3,$F3,$F3,$F1,$F1,$F3,$F3,$F3\
	  ,$F7,$F7,$F7

XOffsets:
	db $00,$00\		;>  Walking 1
	  ,$00,$00\		;>  Walking 2
	  ,$00,$00\		;>  Walking 3
	  ,$10,$F0\		;>  Looking up
	  ,$00,$00\		;>  Running 1
	  ,$00,$00\		;>  Running 2
	  ,$00,$00\		;>  Running 3
	  ,$00,$00\
	  ,$00,$00\
	  ,$00,$00\
	  ,$10,$F0\		;>  Looking up with object
	  ,$00,$00\		;>  
	  ,$00,$00\		;>  
	  ,$00,$00\		;>  
	  ,$00,$00\
	  ,$00,$00\
	  ,$07,$F9\		;>  About to run up a wall.	
	  ,$0C,$F4\
	  ,$0C,$F4\
	  ,$0C,$F4\
	  ,$01,$FF
				;>  Posing on Yoshi to Looking at castle poses are set to
				;   always be 0 to not make the table too big.
	db $0C,$F4		;>  $33 Looking at flying castle 1.
				;>  Here too.
	db $FD,$03\
	  ,$FF,$01