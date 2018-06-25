;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; /				    \ ;
;|  Propeller Mushroom image engine  |;
; \				    / ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	lda $75
	ora $74
	bne .DrawPropellerTile
	lda $71
	sec : sbc #$05
	cmp #$02
	bcs +
	lda $89
	and #$03
	beq ++
	dec : bne +

++	ldx $13DB|!base2
	lda HorizontalPipeWalkingImages,x
	sta $13E0|!base2

+	lda !PropStatus
	and #$7F
	beq .DrawPropellerTile

	lda !PropPlayerFrame : tax
	and #$02
	lsr
	sta $76
	lda Images,x
	sta $13E0|!base2

;<  Draw the propeller tile >;

.DrawPropellerTile
	lda $13E0|!base2 : PhA
	cmp #$15		;\
	bcc +++			; |
	cmp #$26		; |
	beq ++			; |
	cmp #$33		; | Waste some CPU to make some calculations for not making
	beq +			; | the X offsets table too big.
	cmp #$4E
	bcs ++++
	lda #$1F		; |
+	sec : sbc #$1F		; |
	bra +++			; |
++	lda #$17		;/
	bra +++
++++	lda #$16
+++	asl			;\  Shift one bit to the left and combine with the head's X 
	ora $76			;/  flip to make the entries in the table be pairs of bytes,
				;   one when looking to the left and the other to the right.
	tax			;>  Transfer our index to X.

	lda #$00		;>  Load #$00 for the next routine.
	ldy XOffsets,x		;>  Load a low byte in Y to form a 16-bit value.
	jsr GetHighByte		;>  Get the 16-bit value according to data.
	sta !PropTileXOffset	;>  Store X offset.
	sep #$20		;>  Go back to 8-bit mode.

	plx
	lda #$00
	ldy YOffsets,x
	jsr GetHighByte
	sta !PropTileYOffset
	sep #$20

	lda $13			;\  If not time to update the propeller image's main
	and !PropFlipFrequency  ; | index...
;	ora $9D
	bne .DontUpdateFrame	;/  ...continue.
	lda $71
	dec
	cmp #$04
	bcc .DontUpdateFrame

	lda !PropTileAngle	;\
	inc			; |
	cmp #$04		; |
	bcc .DontReset		; | 
	lda #$00		; |
.DontReset			; |
	sta !PropTileAngle	;/
.DontUpdateFrame

	lda PropellerTileIndexes,x
	sta $00
	beq .NoXFlp
	cmp #$14
	beq .NoXFlp
	lda $76
	asl #6
.NoXFlp
	and #%01000000
	ora #%00000001
	sta !PropTileFlags

	lda !PropTileAngle
	ora $00
	asl
	sta !PropTileFrame

	rts

ClearTile:
	lda #%00000000
	sta !PropTileFlags
	rts

;<  Sets A to a 16-bit value in the range #$FF80 - #$007F  >;

;> Inputs:
; ¬ A must be #$00.
; ¬ Y must be the low byte of the final 16-bit value. Also it must be loaded after A.
;> Outputs:
; ¬ A will be 16-bit and his value will be in a range from #$FF80 - #$007F.
; ¬ X and Y won't be changed.

GetHighByte:
	bpl .NoNeg
	dec
.NoNeg	xba
	tya
	rep #$20
	rts

; /	   \ ;
;|  Tables  |;
; \	   / ;

Images:
	db $47,$46,$47,$48
	db $24,$49,$24,$4A
	db $4C,$4B,$4C,$4D
HorizontalPipeWalkingImages:
	db $4E,$4F,$50

PropellerTileIndexes:
	db $00,$00,$00,$04,$00,$00,$00,$00
	db $00,$00,$04,$00,$00,$00,$00,$00
	db $10,$04,$04,$04,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00
	db $14,$14,$00,$04,$00,$00,$00,$00
	db $00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00
	db $00
	db $00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00

YOffsets:
	db $F4,$F4,$F4,$04,$F4,$F4,$F4,$F4
	db $F4,$F4,$04,$F4,$F4,$F3,$F4,$F4
	db $FB,$01,$01,$01,$F4,$F4,$F4
	db $F4,$F4,$F4,$F4,$F3,$F4,$FB,$F4
	db $F4,$F4,$F4,$F4,$F4,$F1,$F4,$F4
	db $F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4
	db $FF,$F4,$F4,$F5,$03,$F4,$F7,$F5
	db $F8,$FC,$F4,$F8,$F8,$01
	db $FF,$FF,$F4,$FF,$FF,$FF,$F2,$F4
	db $F4
	db $F3,$F3,$F3,$F1,$F1,$F3,$F3,$F3
	db $F7,$F7,$F7

XOffsets:
	db $00,$00		;>  Walking 1
	db $00,$00		;>  Walking 2
	db $00,$00		;>  Walking 3
	db $10,$F0		;>  Looking up
	db $00,$00		;>  Running 1
	db $00,$00		;>  Running 2
	db $00,$00		;>  Running 3
	db $00,$00
	db $00,$00
	db $00,$00
	db $10,$F0		;>  Looking up with object
	db $00,$00		;>  
	db $00,$00		;>  
	db $00,$00		;>  
	db $00,$00
	db $00,$00
	db $07,$F9		;>  About to run up a wall.	
	db $0C,$F4
	db $0C,$F4
	db $0C,$F4
	db $01,$FF
				;>  Posing on Yoshi to Looking at castle poses are set to
				;   always be 0 to not make the table too big.
	db $0C,$F4		;>  $33 Looking at flying castle 1.
				;>  Here too.
	db $FD,$03
	db $FF,$01