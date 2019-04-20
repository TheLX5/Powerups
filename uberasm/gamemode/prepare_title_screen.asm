init:
	lda #$FF
	sta !item_gfx_oldest
	sta !item_gfx_latest
	jsl clean_powerup_ram
	jsl init_powerup_ram
	if !gfx_compression == 1
		jsl decompress_gfx
	endif
main:
	rtl