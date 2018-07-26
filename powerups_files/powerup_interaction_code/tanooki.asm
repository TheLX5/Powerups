.tanooki
	lda !power_ram+2
	cmp #$01
	beq ..stone
	jmp .recover_code_hit
..stone
	phx
	lda !7FAB10,x
if !giepy == 1
	and #$0C
else
	and #$08
endif	
	bne ..custom_sprite
	lda !9E,x
	tax 
	lda.l ..normal_sprites_table,x
	bra +
..custom_sprite	
	lda.b #(..pointers-2)
	sta $8A
	lda.b #(..pointers-2)/$100
	sta $8B
	lda.b #(..pointers-2)/$10000
	sta $8C
	jsr get_sprite_group
+	
	plx 
	sta $00
	and #$08
	bne ..pre_clc_rts
	lda $77
	and #$04
	beq +
	jmp .clc_rts
+	
	lda #$04
	sta !14C8,x
	lda #$1F
	sta !1540,x
	jsl $07FC3B|!base3
	jsl $01AB99|!base3
	lda #$08
	sta $1DF9|!base2
	lda #$01
	jsl $02ACE5|!base3
	jmp .clc_rts
..pre_clc_rts		
	lda $00
	and #$20
	beq ..recover_code_hit
	jmp .clc_rts
..recover_code_hit	
	jmp .recover_code_hit
			
	incsrc tanooki_table.asm


..pointers
	dw ..custom_sprites_table_group_1
	dw ..custom_sprites_table_group_2
	dw ..custom_sprites_table_group_3