;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Custom powerups patch by MarioE
; Asar version by Lui37
; Modified by LX5
; 
; This does exactly what the title says and it adds in some more very useful
; stuff.
;
; Absolutely no credit required.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;autoclean

macro insert_gfx(filename,add)
	org ($00A304|!base3+($<add>*3))
		autoclean dl <filename>_gfx
	warnpc $00A38B|!base3
freedata
	<filename>_gfx:
		incbin powerups_files/graphics/<filename>.bin
endmacro

macro insert_extra_gfx(filename,add)
	org ($00F63A|!base3+($<add>*3))
		autoclean dl <filename>_gfx
	warnpc $00F69F|!base3
freedata
	<filename>_gfx:
		incbin powerups_files/graphics/<filename>.bin
endmacro

macro insert_big_gfx(filename,add)
    org ($00A304|!base3+($<add>*3))
        autoclean dl <filename>_gfx
    warnpc $00A38B|!base3
        incbin powerups_files/graphics/<filename>.bin -> <filename>_gfx
endmacro

macro protect_data(filename)
	prot <filename>_gfx
endmacro

macro insert_addon_code(filename)
	incsrc powerups_files/addons/<filename>.asm
endmacro

macro insert_addon_hack(filename)
	incsrc powerups_files/addons/hijacks/<filename>.asm
endmacro


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Defines, do not edit these
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	!a = autoclean

	incsrc powerup_defs.asm

if !SA1 = 1
	sa1rom
endif
			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Hijacks, do not edit these
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	incsrc powerups_files/hijacks/main_engine.asm
	incsrc powerups_files/hijacks/image_engine.asm
	incsrc powerups_files/hijacks/mario_exgfx_engine.asm
	incsrc powerups_files/hijacks/item_gfx_engine.asm
	incsrc powerups_files/hijacks/dma_engine.asm
	incsrc powerups_files/hijacks/control_hack.asm
	incsrc powerups_files/hijacks/palette_engine.asm
	incsrc powerups_files/hijacks/walking_frames_code.asm
	incsrc powerups_files/hijacks/spin_jump_edit.asm
	incsrc powerups_files/hijacks/goal_tape_item_engine.asm
	incsrc powerups_files/hijacks/clear_7E2000.asm
	incsrc powerups_files/hijacks/shell_immunity_code.asm
	incsrc powerups_files/hijacks/custom_collision_engine.asm
	incsrc powerups_files/hijacks/cape_engine.asm
	incsrc powerups_files/hijacks/item_box_engine.asm
	incsrc powerups_files/hijacks/custom_interaction_engine.asm
	if !better_powerdown == 0
		incsrc powerups_files/hijacks/clean_ram.asm
	endif
	incsrc powerups_files/hex_edits.asm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Add-on hijacks installer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	incsrc powerups_files/addon_hijack_installer.asm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

org $00A38B|!base3
	autoclean dl powerup_items
org $00A304|!base3
	PowerupGFX:
org $00F63A|!base3
	ExtraTilesGFX:

freecode
	prot PowerupData,powerup_items

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Prot area
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	%protect_data(small_mario)
	%protect_data(big_mario)
	%protect_data(hammer_mario)
	%protect_data(cape_tiles)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Powerup code
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	incsrc powerups_files/main_engine.asm
	%foreach2("powerup_",": : incsrc powerups_files/powerup_main_code/powerup_",".asm")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Handle player tile data
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	incsrc powerups_files/image_engine.asm
	%foreach2("powerup_","_img: : incsrc powerups_files/powerup_image_code/powerup_",".asm")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Goal tape hax.
; Modifies the routine that gives an item if you carry a sprite after touching
; the goal tape.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	incsrc powerups_files/goal_tape_item_engine.asm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Disable certain controls as per the mask.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	incsrc powerups_files/control_hack.asm
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Clear almost 22000 bytes of RAM. Note that certain portions should NOT
; be used.
;  - Original patch
; Dunno why the patch says this, clearing all of the RAM doesn't seem to do
; anything bad... besides glitching the berries due to their tiles are in GFX32.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		if read1($009750|!base3) == $20
	incsrc powerups_files/clear_7E2000.asm
		endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Handle player tile GFX pointers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	incsrc powerups_files/mario_exgfx_engine.asm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Handle player palette
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	incsrc powerups_files/palette_engine.asm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Handle player GFX DMA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	incsrc powerups_files/dma_engine.asm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Handle spin jump ability
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	incsrc powerups_files/spin_jump_edit.asm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Handle powerup item gfx
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	incsrc powerups_files/item_gfx_engine.asm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Shell immunity stuff
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	incsrc powerups_files/shell_immunity_code.asm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Handle walking frames
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	incsrc powerups_files/walking_frames_code.asm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Handle custom collision engine
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	incsrc powerups_files/custom_collision_engine.asm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Handle cape stuff.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	incsrc powerups_files/cape_engine.asm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Clear some RAM when Mario's hurt.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	if !better_powerdown = 0
		incsrc powerups_files/clean_ram.asm
	endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Handle Mario's riding yoshi status
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	incsrc powerups_files/ride_yoshi.asm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Handle item box stuff.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	incsrc powerups_files/item_box_engine.asm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Handle custom interaction with sprites.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	incsrc powerups_files/custom_interaction_engine.asm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

freedata

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Random Data
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PowerupData:
	incsrc powerups_files/powerup_misc_data/gfx_index.asm
	incsrc powerups_files/powerup_misc_data/palette.asm
	incsrc powerups_files/powerup_misc_data/tilemaps.asm
	incsrc powerups_files/powerup_misc_data/goal_sprites.asm
	incsrc powerups_files/powerup_misc_data/spin_jump.asm
	incsrc powerups_files/powerup_misc_data/walk_frames.asm
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Graphics files
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

freedata
powerup_items:
	incbin powerups_files/graphics/powerup_items.bin

	incsrc powerups_files/powerup_gfx.asm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Add-ons incsrc area
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	incsrc powerups_files/addon_code_installer.asm

print "Custom powerups patch."
print "Version 3.0.0"
print ""
print "Inserted ", freespaceuse, " bytes"