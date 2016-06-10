CapeTailSpin:
	LDA	!cape_settings
	LSR	
	BCC	.Nope
.Yes		
	JML	$00CF45|!base3
.Nope		
	JML	$00CF48|!base3

CapeTailGraphics:
	LDA	!cape_settings
	BIT	#$20
	BNE	.Nope
	AND	#$10
	BNE	.Tail
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
	LDA	!cape_settings
	AND	#$02
	BEQ	.Nope
.Yes	
	JML	$00D8ED|!base3
.Nope	
	JML	$00D928|!base3

NoInfiniteFlying:
	LDA	!cape_settings
	AND	#$04
	BEQ	.Nofly
	LDA	$7D
	BMI	.NoFly
	LDA	$149F|!base2
	BEQ	.NoFly
	JML	$00D814|!base3
.NoFly
	JML	$00D811|!base3

Force16AndSFX:
	LDA	!cape_settings
	AND	#$08
	BNE	.Raccoon
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
.Sound	STY	$1DFC|!base2		;gotta search a better code for this.
else	
	LDY	#$01			;maybe later
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
	LDA	!cape_settings
	AND	#$04
	BEQ	.Store
.Tanooki	
	LDA	!flight_timer
	TAY	
.Store	STY	$149F|!base2
	PLY	
	RTL	

incsrc powerup_misc_data/raccoon_tables.asm