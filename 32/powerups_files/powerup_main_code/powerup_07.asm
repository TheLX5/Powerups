; Rocket boots from Terraria
; By MarioE

		LDA $73
		ORA $74
		ORA $75
		ORA $9D
		ORA $187A|!base2
		BNE .ReturnClear
		LDA $77
		AND #$04
		BNE .ReturnClear
		LDA !flags
		BNE .ReturnClearFlag
		LDA !timer
		BEQ .SkipHoldCheck
		LDA $15
		AND #$80
		BNE .BoostUp
.SkipHoldCheck
		LDA $16
		AND #$80
		BEQ .Return
		LDA #!rocket_boots_time
		STA !timer
		BRA .BoostUp
.ReturnClear
		LDA #$00
		STA !timer
		STA !flags
.Return
		RTS
.ReturnClearFlag
		LDA #$00
		STA !timer
		BRA .Return
.BoostUp
		STZ $140D|!base2
		STZ $13ED|!base2
		LDA #$24
		STA $72
		LDA !timer
		CMP #$01
		BNE .skip1
		LDA #$01
		STA !flags
.skip1
		LDA $7D
		BMI .rising
		SEC
		SBC #$06
		STA $7D
		LDA !timer
		DEC A
		STA !timer
		BRA .done
.rising
		CMP #$D8
		BCC .done
		SEC
		SBC #$04
		STA $7D
		CMP #$E8
		BCC .skip3
		LDA !timer
		DEC A
		STA !timer
		BRA .done
.skip3
		LDA !timer
		DEC #2
		STA !timer
.done
		LDA $14
		AND #$07
		BEQ .skip
		LDA #$27
		STA $1DFC|!base2
		JSR .Smoke
.skip
		RTS
.Smoke
		REP #$20
		LDA $96
		CLC
		ADC #$0018
		CMP $1C
		SEP #$20
		BCC .stop
		LDY #$03
.loop
		LDA $170B|!base2,y
		BEQ .found
		DEY
		BPL .loop
.stop
		RTS
.found
		LDA #$01
		STA $170B|!base2,y
		LDA $94
		STA $171F|!base2,y
		LDA $95
		STA $1733|!base2,y
		LDA $96
		CLC
		ADC #$18
		STA $1715|!base2,y
		LDA $97
		ADC #$00
		STA $1729|!base2,y
		LDA #$0F
		STA $176F|!base2,y
		RTS