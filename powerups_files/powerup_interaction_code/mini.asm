.mini
	phb
	phk
	plb
	lda !7FAB10,x
	and #$08
	bne ..is_custom
	lda !9E,x
	tay
	lda ..normal_sprites_table,y
	bra ..done_with_spr_num
..is_custom
	lda !7FAB9E,x
	tay
	lda ..custom_sprites_table,y
..done_with_spr_num
	plb
	and #$03
	cmp #$03
	beq ..bounce_off
	cmp #$01
	beq ..default_interaction
	cmp #$02
	beq ..platform_fix
	jmp .clc_rts
..default_interaction
	jmp .recover_code_hit
..platform_fix
	jmp .return_force
..bounce_off
if !mini_mushroom_yoshi_stomp == 1
	lda $187A|!base2
	bne ..default_interaction
endif
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
	jsl $01AA33|!base3
	lda #$80
	sta $1406|!base2
	lda #$03
	sta $1DF9|!base2
	jmp .clc_rts

incsrc mini_table.asm