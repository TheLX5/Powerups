;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This file contains GFX for separate powerups.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

%insert_gfx(mario,0)
%insert_gfx(mario_raccoon,3)
%insert_gfx(mario_hammer,6)
%insert_gfx(mario_tanooki,9)
%insert_gfx(mario_shell,12)
%insert_gfx(mario_tiny,15)

	incbin /graphics/ExtendGFX.bin		-> extended_gfx
	
if !enable_projectile_dma == 1
	incbin /graphics/projectiles.bin		-> projectiles_gfx
endif	