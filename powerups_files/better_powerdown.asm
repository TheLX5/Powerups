!DisableDropping	= !disable_drop_item		; If 1 then the reserve item will NOT drop if you get hurt
!DroppingIfOnlyBig	= !drop_item_if_big		; If the above is 0, this one is unused.

PowerDown:
	phx
	phy
	lda $15E9|!base2
	pha

	if !DisableDropping|!DroppingIfOnlyBig == 0
		JSL $028008|!base3
	endif

	lda $19
	dec
	asl
	tax
	jsr (Actions,x)

if !gfx_compression = 1
	ldy $19
	lda $02801B|!base3
	sta $8A
	lda $02801C|!base3
	sta $8B
	lda $02801D|!base3
	sta $8C
	lda [$8A],y
	sta !gfx_player_request
	sta !gfx_pl_compressed_flag
	lda $028021|!base3
	sta $8A
	lda $028022|!base3
	sta $8B
	lda $028023|!base3
	sta $8C
	lda [$8A],y
	sta !gfx_extra_request
	sta !gfx_ex_compressed_flag
endif

	lda !slippery_flag_backup
	beq +
	sta $86
+	
	sta !slippery_flag_backup
	
	lda #$00
	sta !cape_settings

	lda #$10
	tsb $78

	pla
	sta $15E9|!base2
	ply
	plx
	rtl

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
dw !powerup_13_powerdown
dw !powerup_14_powerdown
dw !powerup_15_powerdown
dw !powerup_16_powerdown
dw !powerup_17_powerdown

.Kill
	pla
	pla
	pla
	sta $15E9|!base2
	ply
	plx
	jml $00F606|!base3

; Shrinking
.Shrink
	if !DisableDropping == 0
		if !DroppingIfOnlyBig == 1
			jsl $028008|!base3
		endif
	endif
	lda #$04
	sta $1DF9|!base2
	lda #$2F
	sta $1496|!base2
	sta $9D
	lda #$01
	sta $71
	stz $19
	rts

; Transforming to a smoke
.Smoke
	lda #$0C
	sta $1DF9|!base2
	jsl $01C5AE|!base3
	inc $9D
	lda #$01
	sta $19
	rts

; Cycling through the palette
.Palette
	lda #$20
	sta $149B|!base2
	sta $9D
	lda #$04
	sta $71
	lda #$04
	sta $1DF9|!base2
	stz $1407|!base2
	lda #$7F
	sta $1497|!base2
	lda #$01
	sta $19
	rts
