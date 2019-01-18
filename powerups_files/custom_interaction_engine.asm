
force_hit_sprites:
	phx
	ldx $19
	lda.l force_hit_sprites_powerups,x
	beq .recover_code_hit_x
	dec	
	asl	
	tax	
	rep #$20
	lda.l .pointers,x
	sta $0E
	sep #$20
	plx 
	jmp ($000E|!base1)
		
.recover_code_hit_x	
	plx 	
.recover_code_hit	
	lda !167A,x
	bpl .default_interaction
.return_force		
	jml $01A837|!base3
.default_interaction
	jml $01A83B|!base3
.clc_rts
	jml $01A7F5|!base3
.pointers
	incsrc powerup_interaction_code/custom_interaction_code.asm
