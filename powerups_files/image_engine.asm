;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Handle player tile data
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Tiles:
	PHX	
	JSR	HandleCustomImages
	LDX	$19
	LDA.l	TileAltTable,x
	BNE	.UseAlt
	LDA	$13E0|!base2
	CMP	#$3D
	BCS	+
	ADC.l	TileIndexData,x
+	TAX	
	LDA	$E00C,x
	STA	$0A
	LDA	$E0CC,x
	STA	$0B
-	LDA	$DF1A,x
	BPL	+
	AND	#$7F
	STA	$0D
	LDA	#$04
+	STA	$06
	TXY	
	PLX	
	RTL	
.UseAlt	
	LDA.l	TileAltTable,x
	ASL	
	TAX	
	REP	#$20
	LDA	$13E0|!base2
	AND	#$00FF
	STA	$0B
	LDA.l	TileAltIndexUpper-$02,x
	CLC	
	ADC	$0B
	STA	$00
	SEP	#$20
	LDA.b	#TileAltTable>>16
	STA	$02
	LDA	[$00]
	STA	$0A
	REP	#$20
	LDA.l	TileAltIndexLower-$02,x
	CLC	
	ADC	$0B
	STA	$00
	SEP	#$20
	LDA	[$00]
	STA	$0B
	LDX	$19
	LDA	$13E0|!base2
	CMP	#$3D
	BCS	+
	CLC	
	ADC.l	TileIndexData,x
+	TAX	
	BRA	-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Handle custom images ($13E0)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

HandleCustomImages:
	LDA	$19
	CMP	#!max_powerup
	BEQ	+
	BCS	.Return
+		
	PHB	
	PHK	
	PLB	
	REP	#$30
	AND	#$00FF
	ASL	
	TAX	
	LDA.w	PowerupImages,x
	STA	$00
	SEP	#$30
	LDX	#$00
	JSR	($0000|!base1,x)
	PLB	
.Return		
	RTS	

PowerupImages:
	dw powerup_00_img
	dw powerup_01_img
	dw powerup_02_img
	dw powerup_03_img
	dw powerup_04_img
	dw powerup_05_img
	dw powerup_06_img
	dw powerup_07_img
	dw powerup_08_img
	dw powerup_09_img
	dw powerup_0A_img
	dw powerup_0B_img
	dw powerup_0C_img
	dw powerup_0D_img
	dw powerup_0E_img
	dw powerup_0F_img