@includefrom MinorExtendedSprites.asm

MinorExSprite0C:	
		RTL	

MinorExSprite0D:
		LDA	$9D
		BNE	.no_update
		JSR	MinorExUpdateGravity
.no_update	LDA	$028B78|!base3,x
		TAY	
		LDA	$1808|!base2,x
		SEC	
		SBC	$1A
		STA	$00
		LDA	$18EA|!base2,x
		SBC	$1B
		BNE	.kill
		LDA	$17FC|!base2,x
		SEC	
		SBC	$1C
		STA	$01
		LDA	$1814|!base2,x
		SBC	$1D
		BNE	.kill
		LDA	$00
		STA	$0200|!base2,y
		LDA	$01
		CMP	#$F0
		BCS	.kill
		STA	$0201|!base2,y
		LDA	!extra_minor,x
		STA	$0202|!base2,y
	if !iceball_inserted == 1
		LDA	#!ice_block_prop
	endif
		ORA	$64
		STA	$0203|!base2,y
		LDX	$1698|!base2
		TYA	
		LSR	#2
		TAY	
		LDA	#$00
		STA	$0420|!base2,y
		RTL	
.kill		JSR	kill_rt
.rtl		RTL


MinorExSprite0E:
	RTL	
MinorExSprite0F:
	RTL

kill_rt:	
		STZ	$17F0|!base2,x
		STZ	$17F0|!base2,x
		STZ	$17FC|!base2,x
		STZ	$1814|!base2,x
		STZ	$1808|!base2,x
		STZ	$18EA|!base2,x
		STZ	$1820|!base2,x
		STZ	$182C|!base2,x
		STZ	$1838|!base2,x
		STZ	$1844|!base2,x
		STZ	$1850|!base2,x
		RTS	

MinorExUpdateGravity:
		JSR	MinorExUpdateYPos
		LDY	#$00
		LDA	$1820|!base2,x
		BPL	.down
		CMP	#$E8
		BCS	.down
		LDA	#$E8
.down		LDA	$1820|!base2,x
		CLC	
		ADC.w	data019030,y
		STA	$1820|!base2,x
		BMI	.next
		CMP.w	data01902E,y
		BCC	.next
		LDA	data01902E,y
		STA	$1820|!base2,x
.next		LDA	$182C|!base2,x
		PHA	
		ASL	
		ROR	$182C|!base2,x
		LDA	$182C|!base2,x
		PHA	
		STA	$00
		ASL	
		ROR	$00
		PLA	
		ADC	$00
		STA	$182C|!base2,x
		JSR	MinorExUpdateXPos
		PLA	
		STA	$182C|!base2,x
		RTS
MinorExUpdateXPos:
		LDA	$182C|!base2,x
		ASL	#4
		CLC	
		ADC	$1844|!base2,x
		STA	$1844|!base2,x
		PHP	
		LDY	#$00
		LDA	$182C|!base2,x
		LSR	#4
		CMP	#$08
		BCC	$03
		ORA	#$F0
		DEY	
		PLP	
		PHA	
		ADC	$1808|!base2,x
		STA	$1808|!base2,x
		TYA	
		ADC	$18EA|!base2,x
		STA	$18EA|!base2,x
		PLA	
		RTS	
MinorExUpdateYPos:
		LDA	$1820|!base2,x
		ASL	#4
		CLC	
		ADC	$1838|!base2,x
		STA	$1838|!base2,x
		PHP	
		LDY	#$00
		LDA	$1820|!base2,x
		LSR	#4
		CMP	#$08
		BCC	$03
		ORA	#$F0
		DEY	
		PLP	
		PHA	
		ADC	$17FC|!base2,x
		STA	$17FC|!base2,x
		TYA	
		ADC	$1814|!base2,x
		STA	$1814|!base2,x
		PLA	
		RTS	
data01902E:	db $40,$10
data019030:	db $03,$01