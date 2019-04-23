incsrc powerup_defs.asm

if !i_read_the_readme == 0
	print "Custom Powerups patch - GFX Installer."
	print "Version 1.0.1"
	print ""
	print "Nothing was inserted."
	print "Please read the Readme file included in the zip file."
else

if !SA1 = 1
	sa1rom
endif

org $00A38B|!base3
	if read2($00D067|!base3) == $DEAD
		autoclean dl powerup_items
	else
		dl powerup_items
	endif

org $00A30A|!base3
	PowerupGFX:
org $00F63A|!base3
	ExtraTilesGFX:

	!i = 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GFX Files

if !gfx_compression == 0
freedata cleaned
powerup_items:
	incbin powerups_files/graphics/powerup_items.bin

	%insert_gfx(small_mario,0)
	%insert_gfx(big_mario,1)
	%insert_gfx(hammer_mario,2)
	%insert_gfx(boomerang_mario,3)
	%insert_gfx(raccoon_mario,4)
	%insert_gfx(tanooki_mario,5)
	%insert_gfx(frog_mario,6)
	%insert_gfx(mini_mario,7)
	%insert_gfx(penguin_mario,8)
	%insert_gfx(propeller_mario,9)
	%insert_gfx(shell_mario,A)
	%insert_gfx(cat_mario,B)
	%insert_extra_gfx(cape_tiles,0)
	%insert_extra_gfx(tail_tiles,1)
	%insert_extra_gfx(propeller_tiles,2)
	%insert_extra_gfx(cloud_tiles,3)
	%insert_extra_gfx(cat_tiles,4)
endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GFX install word

if read2($00D067|!base3) != $DEAD
	org $00D067|!base3
	install_byte:
		dw $DEAD
endif

print "Custom powerups patch - GFX Installer."
print "Version 1.0.1"
print ""
print "Inserted ", freespaceuse, " bytes among ", dec(!i)," files."
endif