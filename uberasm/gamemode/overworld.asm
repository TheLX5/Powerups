main:
	lda $0DAE|!addr
	bne +
	jsl init_powerup_ram
+	
if !DEBUG == 1
	jsl powerup_test
endif
	rtl

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

powerup_test:
	ldx $0DB3|!addr
	lda $18
	and #$10
	beq .no_r
	lda $19
	cmp #!max_powerup
	bcc .no_max_power_r
	lda #!max_powerup
	sta $19
	if !gfx_compression == 1
		jsl decompress_gfx
	endif
	jml init_powerup_ram
.no_max_power_r
	inc $19
	if !gfx_compression == 1
		jsl decompress_gfx
	endif
	jml init_powerup_ram
.no_r	
	lda $18
	and #$20
	beq .no_l
	lda $19
	bne .no_max_power_l
	lda #$00
	sta $19
	if !gfx_compression == 1
		jsl decompress_gfx
	endif
	jml init_powerup_ram
.no_max_power_l
	dec $19
	if !gfx_compression == 1
		jsl decompress_gfx
	endif
	jml init_powerup_ram
.no_l	
	rtl