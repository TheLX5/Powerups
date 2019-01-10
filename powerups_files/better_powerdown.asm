!DisableDropping	= 0		; If 1 then the reserve item will NOT drop if you get hurt
!DroppingIfOnlyBig	= 1		; If the above is 0, this one is unused.

PowerDown:
	PHX
	if !DisableDropping|!DroppingIfOnlyBig == 0
		JSL $028008|!base3
	endif

	LDA $19
	DEC
	ASL : TAX
	JSR (Actions,x)

	PLX
	RTL

; Feel free to add more actions if you use more power ups
; (e.g. through LX5's custom power up patch).
Actions:
dw !powerup_01_powerdown	; .Shrink
dw !powerup_02_powerdown	; .Smoke
dw !powerup_03_powerdown	; .Palette
dw !powerup_04_powerdown	
dw !powerup_05_powerdown
dw !powerup_06_powerdown
dw !powerup_07_powerdown
dw !powerup_08_powerdown
dw !powerup_09_powerdown
dw !powerup_0A_powerdown
dw !powerup_0B_powerdown
dw !powerup_0C_powerdown
dw !powerup_0D_powerdown
dw !powerup_0E_powerdown
dw !powerup_0F_powerdown
dw !powerup_10_powerdown
dw !powerup_11_powerdown
dw !powerup_12_powerdown

.Kill
	pla
	pla
	plx
	jml $00F606|!base3

; Shrinking
.Shrink
	if !DisableDropping == 0
		if !DroppingIfOnlyBig == 1
			JSL $028008|!base3
		endif
	endif
	LDA #$04
	STA $1DF9|!base2
	LDA #$2F
	STA $1496|!base2
	STA $9D
	LDA #$01
	STA $71
	STZ $19
	RTS

; Transforming to a smoke
.Smoke
	LDA #$0C
	STA $1DF9|!base2
	JSL $01C5AE|!base3
	INC $9D
	LDA #$01
	STA $19
	RTS

; Cycling through the palette
.Palette
	LDA #$20
	STA $149B|!base2
	STA $9D
	LDA #$04
	STA $71
	LDA #$04
	STA $1DF9|!base2
	STZ $1407|!base2
	LDA #$7F
	STA $1497|!base2
	LDA #$01
	STA $19
	RTS
