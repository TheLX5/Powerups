;;;;;;;;;;;;;;;;;;;
;; 
;; Edits the shatter block routine.
;; 

NewEffect:
		LDA	!9E,x
		CMP	#$53		;If not Throw block, use original.
		BNE	.Shatter
		LDA	!1686,x
		CMP	#$22		;If not Ice block, use original.
		BNE	.Shatter
		JSL	SetUpBrokenIce	;New effect
		BRA	.Finish		
.Shatter	PHB	
		LDA	#$02		;Old effect
		PHA	
		PLB	
		TYA	
		JSL	$028663|!base3
		PLB	
.Finish		JML	$019A03|!base3

;;;;;;;;;;;;;;;;;;;
;; 
;; Throw block state #$08 edit.
;; 

IceBlock:	LDA	!1686,x		;!1622,x
		CMP	#$22		;If not Ice block, do not run throw block main code.
		BNE	+
		LDA	!14C8,x
		CMP	#$07
		BNE	++
		LDA	#$FF
		STA	!1540,x
++		PHB	 
		PHK	
		PLB	
		JSR	IceBlockMain
		PLB	
+		RTL	

IceBlockMain:	LDA	!1540,x
		BEQ	+
		JSL	GetDrawInfo
		BCC	++
		LDA	$00
		STA	$0300|!base2,y
		LDA	$01
		STA	$0301|!base2,y
		LDA	#!ice_block_tile
		STA	$0302|!base2,y
		LDA	#!ice_block_prop
		ORA	$64
		STA	$0303|!base2,y
		PHY	
		LDA	#$00
		LDY	#$02
		JSL	$01B7B3|!base3
		PLY	
+		LDA	$9D
		BNE	++
		LDA	!14C8,x		;If not state 08, do nothing.
		CMP	#$08
		BEQ	.RealMain
++		RTS	
.RealMain	PHY	
		PHK	
		PEA.w	.suboffscreen-1
		PEA.w	$80CA-1
		JML	$01AC2B|!base3
.suboffscreen	PLY	
		LDA	!154C,x		;$154C = Time to fall down if the Ice block was created in air.
		CMP	#$21
		BCS	.Nomove		;Less than 21, make the ice to shake. if 0, stop shaking.
		CMP	#$00
		BEQ	.Nomove
		LDA	$14
		LSR	#2
		AND	#$01		;from Falling Spike sprite.
		CLC	
		ADC	$0300|!base2,y
		STA	$0300|!base2,y
.Nomove		LDA	#$A9		;Force some tweaker bits.
		STA	!167A,x
		LDA	!154C,x
		BNE	+
		JSL	$01802A|!base3	;Normal gravity
+		JSR	.Interaction	;Run some interaction code.
		LDA	!1540,x		;$1540 = Holds a timer with the lifespan of the block.
		BEQ	.ShatPls
		LDA	!1588,x
		AND	#$0B
		BNE	.ShatPls
		LDA	$13
		AND	#$1F
		ORA	$9D		;Use the original "Goal Question Sphere" sparkle effect
		PHK	
		PEA.w 	.iceblockspark-1
		PEA.w	$80CA-1
		JML	$01B152|!base3
.iceblockspark	JSL	$01B44F|!base3
+		LDA	!164A,x		;Check if the sprite is in water to run some physics code.
		BEQ	.NoWater
		JSR	Water
.NoWater	LDA	!154C,x		;Check if the sprite should fall.
		BEQ	.fall
		STZ	!AA,x		;No gravity.
		JSL	$01802A|!base3
		RTS	
.fall		LDA	!1588,x
		AND	#$0C		;The block has touched the floor?
		BEQ	.NoFloor
		LDA	!C2,x		; $C2 = Prevent shattering when the sprite state was #$09 or #$0B.
		BNE	.NoFloor
.ShatPls
		JSL	SetUpBrokenIce	; Run new shatter effect routine.
.NoFloor	RTS	

.Shatter	CPY	#$01		;Check if Mario is above or below of the sprite. Y=#$01 = Above, Y=#$00 = Below
		BEQ	.CheckControl
		LDA	$7D		;If Mario speed is minus, shatter the ice block, if not, do nothing.
		BPL	.NoFloor	
		BRA	.ShatPls

.Interaction	JSL	$018032|!base3
		JSL	$01A7DC|!base3	;Run Mario-Sprite contact
		BCC	.NoContact
		PHK	
		PEA.w	.SubVertPos-1	;Original SubVertPos
		PEA.w	$80CA-1
		JML	$01AD42|!base3
.SubVertPos	LDA	$0E
		CMP	#$E1		;Get distance between Mario and the Ice block.
		BPL	.Shatter
.CheckControl	LDA	$15
		AND	#$40		;If pressing X or Y spawn a new ice block with state #$0B.
		BEQ	.RideSprite
.SpawnNew	LDA	#$0B
		STA	!14C8,x
.NoContact	RTS	
.RideSprite	LDA	$0E
		CMP	#$EF
		BPL	.NoContact
		LDA	$7D
		BMI	.NoContact
		LDA	#$01
		STA	$1471|!base2
		STZ	$7D
		LDA	#$E0
		LDY	$187A|!base2
		BEQ	.NoYoshi
		LDA	#$D0
.NoYoshi	CLC	
		ADC	!D8,x
		STA	$96
		LDA	!14D4,x
		ADC	#$FF
		STA	$97
		LDY	#$00
		LDA	$1491|!base2
		BPL	.Right
		DEY	
.Right		CLC	
		ADC	$94
		STA	$94
		TYA	
		ADC	$95
		STA	$95
		RTS	

Water:		DEC	!AA,x		
		LDA	$14
		AND	#$08
		BEQ	+
		DEC	!AA,x
+	;	LDA	!AA,x
	;	BEQ	+++
		LDA	!B6,x
		BEQ	+
		BMI	++		;Run a minor friction routine.
		DEC	!B6,x
		BRA	+
++		INC	!B6,x
+		JSL	$01A7DC|!base3
		BCC	+++
		PHK	
		PEA.w	.SubVertPos-1	;Do another interaction check again
		PEA.w	$80CA-1
		JML	$01AD42|!base3
.SubVertPos	CPY	#$01		;If mario is standing in the ice block, make it to sink.
		BNE	+++
		LDA	$0E
		CMP	#$10
		BPL	+++
		INC	!AA,x
		INC	!AA,x
	;	INC	!AA,x
+++		RTS	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Throw block state #$09 edit
;;

IceBlockRt:	LDA	!1686,x		;Ice block?
		CMP	#$22
		BEQ	+++
		LDA	!1540,x		;If throw block run original code.
		CMP	#$40
		BCS	+
		LSR	
		BCS	++
+		LDA	!15F6,x
		INC	#2
		AND	#$0F
		STA	!15F6,x
++		JML	$01A1E8|!base3
+++		PHK			;Code for states 09 and 0B (0A too) for the Ice block and this prevents the flashing palette.
		PEA.w 	.iceblockgfx-1
		PEA.w	$80CA-1
		JML	$019F0D|!base3
.iceblockgfx	LDY	!15EA,x
		LDA	#!ice_block_tile		;Run original GFX routine and force tile and properties.
		STA	$0302|!base2,y
		LDA	#!ice_block_prop
		ORA	$64
		STA	$0303|!base2,y
		LDA	#$09		;Set some tweaker bits.
		STA	!167A,x
		LDA	!1540,x
		BEQ	.JMPToShatPls
		LDA	!164A,x		;Sprite in water?
		BEQ	.NoWater
		LDA	!14C8,x
		CMP	#$0B		;Is being carried?
		BEQ	.NoWater
		BRA	+		;If the two checks fail (not carried and sprite in water), spawn a new ice block with state #$08.
.NoWater	LDA	$14
		AND	#$0F
		ORA	$9D
		PHK			;Goal sphere sparkle routine.
		PEA.w 	.iceblockspark-1
		PEA.w	$80CA-1
		JML	$01B152|!base3
.iceblockspark	LDA	!1588,x
		AND	#$04		;Is on air?
		BEQ	.Finish
		LDA	!B6,x
		BMI	.Minus
		SEC	
		SBC	#$08
		BPL	.Finish		;Check if the sprite X Speed is less than #$08 in both directions to check if we need to spawn another Ice Block.
		BRA	+
.Minus		CLC	
		ADC	#$08
		BMI	.Finish
+		LDA	#$01
		STA	!C2,x
		LDA	#$08
		STA	!14C8,x
.Finish		JML	$01A1EB|!base2
.JMPToShatPls	JSR	IceBlockMain_ShatPls
		BRA	.Finish

;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Routines used by the ice block
;;

;;;;;;;;;;;;;;;;;;;;;;;
;; 
;; New shatter effect.
;; 

;print "Shatter ice block routine at sprite position: $",pc

SetUpBrokenIce:	LDA	!E4,x
		STA	$9A
		LDA	!14E0,x		;Set up sprite
		STA	$9B
		LDA	!D8,x
		STA	$98
		LDA	!14D4,x
		STA	$99
		STZ	!14C8,x
;print "Shatter ice block routine at Mario position: $",pc
SpawnBrokenIce:	PHB	
		PHK			;Set bank.
		PLB	
		PHX			;Preserve X and Y
		PHY	
		LDY	#$03		;Spawn four minor extended sprites.
		STY	$00
		LDX	#$0B		;loop through 20 slots
.code02866A	LDA	$17F0|!base2,x
		BEQ	.code02867F
.code02866F	DEX	
		BPL	.code02866A
		DEC	$185D|!base2
		BPL	.code02867C
		LDA	#$13
		STA	$185D|!base2
.code02867C	LDX	$185D|!base2
.code02867F	LDA	#!ice_piece_num
		STA	$17F0|!base2,x
		LDA	$9A
		CLC	
		ADC.w	.XLoDisp,y
		STA	$1808|!base2,x
		LDA	$9B
		ADC	#$00
		STA	$18EA|!base2,x
		LDA	$98
		CLC	
		ADC.w	.YLoDisp,y
		STA	$17FC|!base2,x
		LDA	$99
		ADC	#$00
		STA	$1814|!base2,x
		LDA.w	.YVel,y		;set speed.
		STA	$1820|!base2,x
		LDA.w	.XVel,y
		STA	$182C|!base2,x
		LDA.w	.Tiles,y	;set tiles to some minor extended sprite table.
		STA	!extra_minor,x
		LDA	#$FF		;set lifespan.
		STA	$1850|!base2,x
		DEY	
		BPL	.loop
		LDA	#$07		;Sound effect.
		STA	$1DFC|!base2
		PLY	
		PLX	
		PLB	
		RTL	
.loop		DEX	
		BRA	.code02866A

.XLoDisp	db $00,$08,$00,$08
.YLoDisp	db $08,$00,$00,$08
.YVel		db $CE,$C0,$C0,$CE
.XVel		db $F1,$0D,$F2,$0F
.Tiles		db !ice_tile_dl,!ice_tile_ur,!ice_tile_ul,!ice_tile_dr

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;; Get Draw Info
;; 

;print "GetDrawInfo Location: $",pc

GetDrawInfo:	PHB	
		PHK	
		PLB	
		JSR	GetDrawInfoRt
		PLB	
		RTL	

GetDrawInfoRt:	STZ	!186C,x
		STZ	!15A0,x
		LDA	!E4,x
		CMP	$1A
		LDA	!14E0,x
		SBC	$1B
		BEQ	.OnscreenX
		INC	!15A0,x
.OnscreenX	LDA	!14E0,x
		XBA	
		LDA	!E4,x
		REP	#$20
		SEC	
		SBC	$1A
		CLC	
		ADC.w	#$0040
		CMP	#$0180
		SEP	#$20
		ROL	A
		AND	#$01
		STA	!15C4,x
		BNE	.Invalid
		LDY	#$00
		LDA	!1662,x
		AND	#$20
		BEQ	.OnscreenLoop
		INY	
.OnscreenLoop	LDA	!D8,x
		CLC	
		ADC.w	.Table1,y
		PHP	
		CMP	$1C
		ROL	$00
		PLP	
		LDA	!14D4,x
		ADC	#$00
		LSR	$00
		SBC	$1D
		BEQ	.OnscreenY
		LDA	!186C,x
		ORA.w	.Table2,y
		STA	!186C,x
.OnscreenY	DEY	
		BPL	.OnscreenLoop
		LDY	!15EA,x
		LDA	!E4,x
		SEC	
		SBC	$1A
		STA	$00
		LDA	!D8,x
		SEC	
		SBC	$1C
		STA	$01
		SEC	
		RTS	
.Invalid	CLC	
		RTS	

.Table1		db $0C,$1C
.Table2		db $01,$02