CapeTailSpin:
	LDY	$19
	CPY	#$08
	BEQ	.Yes
	CPY	#$09
	BEQ	.Yes
	CPY	#$02
	BNE	.Nope
.Yes	
	JML	$00CF45|!base3
.Nope	
	JML	$00CF48|!base3

CapeTailGraphics:
	LDA	$19
	CMP	#$08
	BEQ	.Tail
	CMP	#$09
	BEQ	.Tail
	CMP	#$02
	BNE	.Nope
.Yes	
	JML	$00E401|!base3
.Nope	
	JML	$00E458|!base3
.Tail	
	PHB	
	PHK
	PLB	
	PHY	
	LDA	#$2C
	STA	$06
	LDX	$13E0|!base2
	LDA.w	TailData_00E18E,x
	TAX	
	LDA	$0D
	CPX	#$2B
	BCC	+
	CPX	#$40
	BCS	+
	LDA.w	TailData_00E1D7,x
+
	STA	$0D
	LDA.w	TailData_00E1D8,x
	STA	$0E
	LDA.w	TailData_00E1D5,x
	STA	$0C
	CMP	#$04
	BCS	.Code00E432
	LDA	$13DF|!base2
	ASL	#2
	ORA	$0C
	TAY	
	LDA.w	TailData_00E23A,y
	STA	$0C
	LDA.w	TailData_00E266,y
	BRA	.Code00E435
.Code00E432	
	LDA.w	TailData_00E1D6,x
.Code00E435	
	ORA	$76
	TAY	
	LDA.w	TailData_00E21A,y
	STA	$05
	PLY	
	PLB	
	LDA.l	TailData_00E1D4,x
	TSB	$78
	BMI	.Code00E448
	JML	$00E445|!base3
.Code00E448
	JML	$00E448|!base3

EnableFlying:
	LDA	$19
	CMP	#$08
	BEQ	.Yes
	CMP	#$09
	BEQ	.Yes
	CMP	#$02
	BNE	.Nope
.Yes	
	JML	$00D8ED|!base3
.Nope	
	JML	$00D928|!base3

NoInfiniteFlying:
	LDX	$19
	CPX	#$02
	BNE	.NoFly
	LDA	$7D
	BMI	.NoFly
	LDA	$149F|!base2
	BEQ	.NoFly
	JML	$00D814|!base3
.NoFly
	JML	$00D811|!base3

Force16AndSFX:
	LDA	$19
	CMP	#$08
	BEQ	.Raccoon
	CMP	#$09
	BEQ	.Raccoon
	LDA	$15,x
	BPL	.Return
	LDA	#$10
	STA	$14A5|!base2
	JML	$00D90D|!base3
.Return
	JML	$00D924|!base3
.Raccoon
	LDA	$16
	BPL	.Return
	PHY	
	LDY	#$04
	LDA	$77
	AND	#$04
	BEQ	.Sound
if read1($0E8000) != $40 && read1($0E8001) != $41 && read1($0E8002) != $4D && read1($0E8003) != $4B		; Check for @AMK
	LDY	#$35
.Sound	STY	$1DFC|!base2
else	
	LDY	#$01
	STY	$1DFA|!base2
	BRA	.Finish
.Sound	STY	$1DFC|!base2
endif
.Finish
	PLY	
	LDA	#$08
	STA	$14A5|!base2
	JML	$00D90D|!base3

FlightTime:
	PHY	
	LDY	#$50
	LDA	$19
	CMP	#$09
	BEQ	.Tanooki
	CMP	#$08
	BNE	.Store
.Tanooki	
	LDY	#$78
.Store	STY	$149F|!base2
	PLY	
	RTL	


TailData_00E18E:
	db $00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$0D,$00,$10
	db $13,$22,$25,$28,$00,$16,$00,$00
	db $00,$00,$00,$00,$00,$08,$19,$1C
	db $04,$1F,$10,$10,$00,$16,$10,$06
	db $04,$08,$2B,$30,$35,$3A,$3F,$43
	db $00,$00,$00,$00,$00,$00,$00,$00
	db $16,$16,$00,$00,$08,$00,$00,$00
	db $00,$00,$00,$10,$04,$00
TailData_00E1D4:
	db $06
TailData_00E1D5:
	db $00
TailData_00E1D6:
	db $06
TailData_00E1D7:
	db $00
TailData_00E1D8:
	db $86,$02,$06,$03,$06,$01,$06,$CE
	db $06,$06,$E8,$00,$06,$EC,$06,$06
	db $C8,$0E,$86,$EC,$06,$86,$EC,$E8
	db $86,$E8,$08,$06,$E8,$02,$06,$CC
	db $10,$06,$EC,$10,$06,$CC,$10,$00
	db $8C,$14,$14,$2E,$00,$CA,$16,$16
	db $00,$8E,$18,$18,$2E,$00,$EB,$1A
	db $1A,$2E,$04,$ED,$1C,$1C,$82,$06
	db $92,$1E 
TailData_00E21A:
	db $84,$86,$88,$8A,$8C,$8E,$90,$90
	db $92,$94,$96,$98,$9A,$9C,$9E,$A0
	db $A2,$A4,$A6,$A8,$AA,$B0,$B6,$BC
	db $C2,$C8,$CE,$D4,$DA,$DE,$E2,$E2
	
TailData_00E23A:		;tilemap
	db $E8,$E8,$E8,$E8,$E8,$E8,$E8,$E8
	db $E8,$E8,$E8,$E8,$C8,$C8,$C8,$C8
	db $EA,$EA,$EA,$EA,$E8,$E8,$E8,$E8
	db $EA,$EA,$EA,$EA,$E8,$E8,$E8,$E8
	db $CC,$CC,$CC,$CC,$EA,$EA,$EA,$EA
	db $EA,$EA,$EA,$EA

TailData_00E266:		;Offset
;	db $02,$02,$02,$0C,$00,$00,$00,$00
;	db $00,$00,$00,$00,$00,$00,$00,$00
;	db $00,$00,$00,$00,$00,$00,$00,$00
;	db $00,$00,$00,$00,$04,$12,$04,$04
;	db $04,$12,$04,$04,$04,$12,$04,$04
;	db $04,$12,$04,$04
	
	db $02,$02,$02,$02,$02,$02,$02,$02
	db $02,$02,$02,$02,$02,$02,$02,$02
	db $02,$02,$02,$02,$02,$02,$02,$02
	db $02,$02,$02,$02,$02,$02,$02,$02
	db $02,$02,$02,$02,$02,$02,$02,$02
	db $02,$02,$02,$02