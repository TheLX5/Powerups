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
		dl <filename>_gfx
	warnpc $00A38E|!base3
freedata
	<filename>_gfx:
		incbin powerups_files/graphics/<filename>.bin
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

macro powerup_number(define_name,num)
	!<define_name>_powerup_num = $<num>
	!powerup_<num> = !<define_name>_powerup_num

	!powerup_<num>_tile = !<define_name>_tile
	!powerup_<num>_prop = !<define_name>_prop
endmacro

;;;;;;;;;;;;;
; Taken from alcaro's Mario ExGFX patch
;;;;;;;;;;;;;

!NumPowerup = $0F	;Limit is $0F
		; to increase, expand the table below (pattern should be obvious)

!powerups_A = 00
!powerups_AA = 01
!powerups_AAA = 02
!powerups_AAAA = 03
!powerups_AAAAA = 04
!powerups_AAAAAA = 05
!powerups_AAAAAAA = 06
!powerups_AAAAAAAA = 07
!powerups_AAAAAAAAA = 08
!powerups_AAAAAAAAAA = 09
!powerups_AAAAAAAAAAA = 0A
!powerups_AAAAAAAAAAAA = 0B
!powerups_AAAAAAAAAAAAA = 0C
!powerups_AAAAAAAAAAAAAA = 0D
!powerups_AAAAAAAAAAAAAAA = 0E
!powerups_AAAAAAAAAAAAAAAA = 0F

macro foreach_core(code1, code2, code3, code4, id)
!Id = !{powerups_<id>}
<code1>!{Id}<code2>!{Id}<code3>!{Id}<code4>
if $!Id < !max_powerup : %foreach_core("<code1>", "<code2>", "<code3>", "<code4>", <id>A)
endmacro
macro foreach(code1, code2)
%foreach_core("<code1>", "<code2> : if 0 : ", "x", "x", A)
endmacro
macro foreach2(code1, code2, code3)
%foreach_core("<code1>", "<code2>", "<code3> : if 0 : ", "x", A)
endmacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Defines, do not edit these
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	!a = autoclean

	incsrc powerup_defs.asm
	%foreach("incsrc powerups_files/powerup_defs/powerup_",".asm")

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
	incsrc powerups_files/hex_edits.asm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Add-on hijacks installer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	incsrc powerups_files/addon_hijack_installer.asm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

org $00A304|!base3
	PowerupGFX:

freecode
	prot PowerupData,extended_gfx

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Prot area
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	%protect_data(mario)

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

	pushpc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Misc incsrcs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	incsrc other_patches/itemboxspecial.asm
	incsrc other_patches/extended_sprites.asm
	incsrc other_patches/MinorExtendedSprites.asm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Add-ons incsrc area
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	pullpc
	
	incsrc powerups_files/addon_code_installer.asm

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

	incsrc powerups_files/powerup_gfx.asm

print "Inserted ", freespaceuse, " bytes"