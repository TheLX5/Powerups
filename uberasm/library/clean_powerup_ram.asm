clean_powerup_ram:
	lda #$00
	sta !gfx_bypass_flag
	sta !gfx_bypass_num
	sta !mask_15
	sta !mask_17
	sta !disable_spin_jump
	sta !shell_immunity
	sta !pal_bypass
	sta !projectile_do_dma
	sta !extra_tile_flag
	sta !extra_gfx_bypass_num
	sta !clipping_flag
	sta !collision_flag
	sta !gfx_pl_compressed_flag
	sta !gfx_ex_compressed_flag
	sta !gfx_player_request
	sta !gfx_extra_request

	ldx.b #21
-	
	sta !sprite_shock,x
	sta !sprite_shock_flags,x
	sta !sprite_shock_14,x
	dex
	bpl -

	rtl