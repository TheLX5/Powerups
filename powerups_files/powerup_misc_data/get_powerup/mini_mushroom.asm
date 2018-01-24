give_mini_mushroom:
	stz $140D|!base2
	phx
	lda #$01
	sta !clipping_flag
	lda #$08
	sta !clipping_width
	lda #$07
	ldx $187A|!base2
	beq +
	lda #$17
+	
	sta !clipping_height
	lda #$08
	sta !clipping_disp_x
	lda #$19
	sta !clipping_disp_y
	
	rep #$30
	ldx #$006C
-	
	lda.l .x_coords,x
	sta !collision_data_x,x
	lda.l .y_coords,x
	sta !collision_data_y,x
	dex #2
	bpl -
	sep #$30
	lda #$01
	sta !collision_flag
	lda #$FF
	sta !collision_index
	lda #$04
	sta $1DF9|!base2
	lda #!mini_mushroom_powerup_num
	sta $19
	plx
	lda #$04
	jsl $02ACE5|!base3
	jsl $01C5AE|!base3
	inc $9D
	jmp clean_ram

.x_coords
dw $0008,$000C,$000C,$0008,$0006,$000A	;x<8, no yoshi, no duck
dw $0008,$0004,$0004,$0008,$000A,$0006	;x>8, no yoshi, no duck
dw $0008,$000C,$000C,$0008,$0006,$000A	;x<8, no yoshi, duck
dw $0008,$0004,$0004,$0008,$000A,$0006	;x>8, no yoshi, duck
dw $0008,$000C,$000C,$0008,$0006,$000A	;x<8, yoshi, no duck
dw $0008,$0004,$0004,$0008,$000A,$0006	;x>8, yoshi, no duck
dw $0008,$000C,$000C,$0008,$0006,$000A	;x<8, yoshi, duck
dw $0008,$0004,$0004,$0008,$000A,$0006	;x>8, yoshi, duck
dw $0010,$0010,$0007			;left wallrunning
dw $0000,$0000,$0008			;right wallrunning

.y_coords
dw $0017,$0019,$0015,$0013,$0020,$0020	;x<8, no yoshi, no duck
dw $0017,$0019,$0015,$0013,$0020,$0020	;x>8, no yoshi, no duck
dw $0017,$0019,$0015,$0013,$0020,$0020	;x<8, no yoshi, duck
dw $0017,$0019,$0015,$0013,$0020,$0020	;x>8, no yoshi, duck
dw $0020,$0024,$001E,$001B,$0030,$0030	;x<8, yoshi, no duck
dw $0020,$0024,$001E,$001B,$0030,$0030	;x>8, yoshi, no duck
dw $0022,$0024,$0020,$001D,$0030,$0030	;x<8, yoshi, duck
dw $0022,$0024,$0020,$001D,$0030,$0030	;x>8, yoshi, duck
dw $0018,$0018,$0018			;left wallrunning
dw $0018,$0018,$0018			;right wallrunning