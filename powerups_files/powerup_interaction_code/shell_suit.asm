.shell_suit
	lda !flags
	bne ..hit_sprites
	jmp .recover_code_hit

..hit_sprites		
	lda !167A,x
	and #$02
	bne ..check_flip_direction
	lda #$10
	sta !154C,x
	lda #$02
	sta !14C8,x
	lda #$D0
	sta !AA,x
	phb
	lda.b #$01|(!base3/$10000)
	pha
	plb
	ldy $76
	lda.w $A839,y
	sta !B6,x
	plb
	jsl $01AB99|!base3
	lda #$14
	sta $1DF9|!base2
	lda #$01
	jsl $02ACE5|!base3
	jmp .clc_rts

..check_flip_direction	
	phb	
	phk	
	plb	
	lda !7FAB10,x
if !giepy == 1
	and #$0C
else
	and #$08
endif	
	bne +
	lda !9E,x
	tay 
	lda.w ..normal_sprites,y
	bra ++
+	
	lda !7FAB9E,x
	tay
	lda.w ..cust_spr_tab,y	
++		
	plb 
	bit #$01
	beq +
-		
	jmp .return_force
+			
	bit #$02
	bne ..flip_shell
	jmp .clc_rts
..flip_shell 	
	phk 
	pea.w ..SubVertPos-1
	pea.w $80CA-1
	jml $01AD42|!base3
..SubVertPos 	
	lda $0E
	cmp #$EF
	bmi -
	lda $76
	eor #$01
	sta $76
	lda $7B
	eor #$FF
	inc 
	sta $7B
	lda #$01
	sta $1DF9|!base2
	lda #$02
	sta !154C,x
	jmp .clc_rts

	incsrc shell_suit_table.asm