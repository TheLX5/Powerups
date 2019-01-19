.mini
	phb
	phk
	plb
	lda !7FAB10,x
	and #$08
	bne ..is_custom
	lda !9E,x
	tay
	lda ..spr_tab,y
	bra ..done_with_spr_num
..is_custom
	lda !7FAB9E,x
	tay
	lda ..cust_spr_tab,y
..done_with_spr_num
	plb
	bit #$40
	bne ..bounce_off
	bit #$10
	bne ..default_interaction
	bit #$20
	bne ..platform_fix
	jmp .clc_rts
..default_interaction
	jmp .recover_code_hit
..platform_fix
	jmp .return_force
..bounce_off
	phk
	pea ..sub_vert_pos-1
	pea $80C9
	jml $01AD42|!base3
..sub_vert_pos
	lda $0E
	cmp #$EF
	bmi ..bounce
..hit_from_below
	jmp .recover_code_hit
..bounce
	cpy #$00
	beq ..hit_from_below
	lda #$03
	sta $1DF9|!base2
	jsl $01AA33|!base3
	jmp .clc_rts

incsrc mini_table.asm