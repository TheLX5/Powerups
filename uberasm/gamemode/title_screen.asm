init:
	jsl clean_powerup_ram
	jsl init_powerup_ram
	if !gfx_compression == 1
		jsl decompress_gfx
	endif
main:
	rtl