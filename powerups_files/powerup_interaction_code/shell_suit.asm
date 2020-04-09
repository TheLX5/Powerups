.shell_suit
	lda !flags
	bne ..check_flip_direction
	jmp .recover_code_hit

..check_flip_direction	
	phb	
	phk	
	plb	
	lda !7FAB10,x
	and #$08
	bne +
	lda !9E,x
	tay 
	lda.w ..normal_sprites_table,y
	bra ++
+	
	lda !7FAB9E,x
	tay
	lda.w ..custom_sprites_table,y	
++		
	plb 
	and #$07
	beq ..disable_interaction
	cmp #$01
	beq ..default_interaction
	cmp #$02
	beq ..solid_sprite
	jmp ..hit_sprites
..solid_sprite
	phk 
	pea.w ..SubVertPos-1
	pea.w $80CA-1
	jml $01AD42|!base3
..SubVertPos 	
	lda $0E
	cmp #$EF
	bmi ..disable_interaction
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
..disable_interaction
	jmp .clc_rts

..default_interaction
	jmp .return_force

..hit_sprites
	cmp #$03
	beq ...fall_down
...spin_jump
	jsl $07FC3B|!base3
	lda #$04
	sta !14C8,x
	lda #$1F
	sta !1540,x
	lda #$08
	sta $1DF9|!base2
	bra ...shared_hit
...fall_down
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
	stz $1DF9|!base2
...shared_hit
	jsl $01AB99|!base3
	
	inc $18D2|!base2
	lda $18D2|!base2
	cmp #$08
	bcc +
	lda #$08
	sta $18D2|!base2
+	
if !shell_suit_inc_points == 0
	lda #!shell_suit_fixed_points
endif	
	jsl $02ACE5|!base3
	lda $1DF9|!base2
	bne +
	ldx $18D2|!base2
	cpx #$08
	bcs +
	lda.l ...sfx,x
	sta $1DF9|!base2
+	
	ldx $15E9|!base2
	jmp .clc_rts

...sfx	
	db $00,$13,$14,$15,$16,$17,$18,$19

	incsrc shell_suit_table.asm