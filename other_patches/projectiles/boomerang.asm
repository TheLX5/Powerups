MarioBoomerang_ret:
		RTS	
MarioBoomerang:
		JSR 	.BoomerangGfx		;Graphics routine
		LDA	$9D
		BNE	.ret			;If $9D is set, don't run code
		LDA	!extra_extended_2,x
		AND	#$80			;Check if boomerang has hit anything
		BEQ	+
		JSR	SpriteSpd		;Falling off screen routine.
		RTS				;it's just a gravity routine.
.killxspd	db $F7,$09
+		PHX	
		PHY	
		JSR	boomerang_hit		;Process interaction with sprites.
			
		LDA	$13
		AND	#$01			;Process interaction with blocks at 30fps
		BEQ	.no_process
		JSR	GetMap16		;Get Acts like number
		PHX	
		REP	#$30
		LDY.w	#boomerang_table_end-boomerang_table-$03
.loop			
		CMP.w	boomerang_table,y	;loop until it finds anything
		BEQ	.found
		DEY	#3
		BPL	.loop
		SEP	#$30			;If the boomerang isn't touching a block
		BRA	.back			;end routine
.found			
		LDA	#$0000
		SEP	#$20			;if anything found, clear A
		LDA.w	hammer_table+$02,y	;get index
		REP	#$20
		TXY	
		ASL	
		TAX	
		JSR	(InteractPointers,x)	;Run block interaction code.
.back			
		PLX	
.no_process		
		JSR	ExtSprClip		
		JSL	$03B664|!base3		;Mario catches boomerang detection
		JSL	$03B72B|!base3
		BCC	+
		LDA	$176F|!base2,x		;The boomerang isn't catched if timer
		BNE	+			;is set
		LDA	#$00
		STA	$170B|!base2,x		;clear boomerang
		LDA	!extra_extended_2,x
		AND	#$BF			;clear "carry sprite" bit
		STA	!extra_extended_2,x
		LDA	!extra_extended_3,x	;Get $1686 info.
		TAY	
		LDA	!extra_extended_4,x	;Get sprite index.
		PHX	
		TAX	
		TYA	
		STA	!1686,x			;make it interact with objects again
		LDA	#$00
		STA	!extra_sprites,x
		PLX	
		JSR	check_dma		;stop DMA
+		PLY	
		PLX	
			
		LDA	!extra_extended,x	;increase misc ram
		INC	
		STA	!extra_extended,x	;used to update boomerang's image
		LDY	#$01
		LDA	$14
		AND	#$02
		BEQ	+
		INY	
+		STY	$00			;store it for later (acceleration)
		LDA	$1747|!base2,x		;start handling X speed.
		LDY	$1765|!base2,x		;get direction
		BNE	+
		CLC	
		ADC	$00			;make it accelerate
		BMI	++
		CMP	#$50			;if max speed hasn been reached
		BCC	++
		LDA	#$50			;keep it.
		BRA	++
+		SEC	
		SBC	$00			;do the same as above
		BPL	++			;but for the other direction
		CMP	#$B0
		BCS	++
		LDA	#$B0
++		STA	$1747|!base2,x		;update X speed.
			
		LDA	!extra_extended_2,x	;check if boomerang should go up
		AND	#$01
		BNE	+++
		LDA	$173D|!base2,x		;increase y speed
		INC	A
		BMI	+
		CMP	#$10			;check velocity
		BCC	+
		LDA	!extra_extended_2,x
		ORA	#$01			;set bit if we should go up now.
		STA	!extra_extended_2,x
++		LDA	#$10
-		
+		STA	$173D|!base2,x		;store Y speed.
--		JSR	SpriteSpdNoGravity	;update position without gravity
		RTS	
+++		LDA	$14
		AND	#$03
		BEQ	--
		LDA	$173D|!base2,x		;make boomerang go up
		SEC	
		SBC	#$01			;accelerate
		BPL	-
	;	CMP	#$00
	;	BCS	-
		LDA	#$00			;max upward speed
		BRA	-
			
.BoomerangGfx		
		JSR	ExtGetDraw_NoIndex	;call getdrawinfo
		LDA	$1747|!base2,x
		STA	$03
		LDA	$1779|!base2,x		;retrieve some info
		STA	$04
		LDA	!extra_extended,x	;get image index
		LSR	#2
		AND	#$03
		STA	$05			;make it slower and store it for later
		PHX	
		TXA	
		SEC	
		SBC	#$08
		TAX	
		LDY.w	PowerOAM,x		;get OAM index
if !enable_projectile_dma == 1
		STX	$0F			;store projectile index for later usage
		LDA	$05
		TAX				;get index for the current image
		LDA.w	boomerang_projectile,x
		JSR	boomerang_projectile_dma		;update image via DMA
		LDX	$0F
		LDA.w	power_dynamic_tiles,x	;get tile based on projectile index
else
		LDX	$05			;get tile based on !extra_extended
		LDA.w	boomerang_tiles,x
endif		
		STA	$0202|!base2,y
		LDA	$01
		STA	$0200|!base2,y		;typical filling oam code
		LDA	$02
		STA	$0201|!base2,y
		LDX	$05			
		LDA	#!boomerang_pro_props	;get palette and GFX page
		PHY	
		TXY	
		LDX	$03			;flip based on direction
		BPL	+
		INY	#4
+		ORA	.prop,y			;set YX bits
		ORA	$64			;set PP bits
		LDY	$04
		BEQ	+
		AND	#$CF			;change PP bits if projectile is behind layers
		ORA	#$10
+		PLY	
		STA	$0203|!base2,y
		TYA	
		LSR	#2
		TAX	
		LDA	#$02			;projectile size
		STA	$0420|!base2,x
		PLX	
		RTS	
.prop		db $40,$40,$80,$80
		db $00,$00,$C0,$C0

boomerang_hit:	
		LDA	!extra_extended_2,x	;is boomerang carrying something?
		AND	#$40
		BEQ	+
		BRA	.run_code
+			
		LDA	$13
		AND	#$01			;runs at 30fps
		BEQ	.run_code
		RTS	
.run_code		
		PHX	
		TXY	
		STY	$185E|!base2		;save projectile index for later
		LDX	#$0B			;start looping through all sprite slots
.loop		STX	$15E9|!base2
		LDA	!14C8,x
		CMP	#$08			;dont check if sprite isn't considered alive
		BCC	++
		CMP	#$0B
		BCS	++
+	;	LDA	!167A,x
	;	AND	#$02
		LDA	!15D0,x
		ORA	!1632,x			;if sprite is being eaten
		EOR	$1779|!base2,y		;or not in the same layer as projectile
		BNE	++			;don't check
		JSL	$03B6E5|!base3		;get sprite clipping
		PHX	
		TYX	
		JSR	ExtSprClip		;get projectile clipping
		PLX	
		LDY	$185E|!base2
		JSL	$03B72B|!base3		;check for contact
		BCC	++
		LDA	!7FAB10,x
		AND	#$08			;is the sprite custom?
		BNE	.IsCustom
		LDY.w	!9E,x
		LDA.w	boomerang_normal_sprites,y	;handle normal sprites
		BRA	+
.IsCustom	LDA	!7FAB9E,x
		TAY	
		LDA.w	boomerang_custom_sprites,y	;handle custom sprites
+		;LDY	$00
		STA	$0F			;store sprite info for later usage
		LDY	$185E|!base2
		TXA	
		STA	$0E			;save sprite index
		JSR	.hit			;run interaction code
.finish		PLX	
		STX	$15E9|!base2		;don't check for more sprites
		RTS	
++		LDY	$185E|!base2
		DEX				;are we done with sprites?
		BMI	.finish			;yes
		BRA	.loop			;no

.hit		
		LDA	$0F			;7th is used to bypass 4th bit setting
		BMI	++
		AND	#$10			;should boomerang interact with anything?
		BEQ	++
-			
		RTS				;no
++			
		TYX	
		LDA	!extra_extended_2,x	;is boomerang carrying something?
		AND	#$40
		BNE	+++
		LDX	$0E
		LDA	!extra_sprites,x	;is this sprite being carried?
		BNE	-			;dont process anything then
		LDA	$0F
		AND	#$40			;can sprite be retrieved?
		BEQ	.main_hit
		LDA	$176F|!base2,y		;check some timer
		BNE	-
+			
		LDA	$171F|!base2,y
		STA	!E4,x
		LDA	$1733|!base2,y		;stick item to boomerang
		STA	!14E0,x
		LDA	$1715|!base2,y
		STA	!D8,x
		LDA	$1729|!base2,y
		STA	!14D4,x
		STZ	!AA,x			;kill its gravity
		LDA	#$01
		STA	!extra_sprites,x	;set flag
		LDA	!1686,x
		STA	$00			;save tweaker bits
		ORA	#$80
		STA	!1686,x			;set "don't interact with objects" bit
		TXA	
		TYX	
		STA	!extra_extended_4,x	;save sprite index
		LDA	$00
		STA	!extra_extended_3,x	;save tweaker bits
		LDA	!extra_extended_2,x
		ORA	#$40
		STA	!extra_extended_2,x	;set "carrying sprite" flag
		LDX	$0E			;get index
		RTS	
+++			
		LDX	$0E
		LDA	$171F|!base2,y
		STA	!E4,x
		LDA	$1733|!base2,y		;stick item to boomerang
		STA	!14E0,x
		LDA	$1715|!base2,y
		STA	!D8,x
		LDA	$1729|!base2,y
		STA	!14D4,x
		STZ	!AA,x			;kill gravity
		LDA	!1686,x
		ORA	#$80
		STA	!1686,x			;force "don't interact with objects" bit
		RTS	
.main_hit			
		TYX	
		LDA	!extra_extended_2,x
		ORA	#$80			;set "fall off screen" bit
		STA	!extra_extended_2,x
		LDX	$0E
		LDA	$0F
		AND	#$01			;check if sprite is imune to projectile
		BNE	.go_back
		PHY	
		LDA	$1747|!base2,y		;get direction
		AND	#$80
		CLC	
		ROL	#2
		TAY	
		LDA.w	.KillSpd,y		;get sprite X speed
		PLY	
		STA	!B6,x
		LDA	#$D4			;change its Y speed too
		STA	!AA,x
		LDA	#$02			;kill it
		STA	!14C8,x
	;	LDA	#$04
.go_back		
		LDA	#$10
		LDX	$1747|!base2,y		;kill boomerang/hammer code
		BMI	+
		LDA	#$F0	
+	
		STA	$1747|!base2,y
		LDA	#$03
		STA	$1DF9|!base2
		RTS	

.KillSpd	db $18,$E8			;killed sprite speeds


if !enable_projectile_dma == 1

boomerang_projectile_dma:
		PHX	
		LDX	$15E9|!base2		;get index
		REP	#$20
		AND	#$00FF
		ASL	#6
		CLC	
		ADC.w	#boomerang_projectile_gfx	;this needs to be changed
		PHA				;then we can patch this file without
		TXA				;patching powerup.asm
		SEC	
		SBC	#$0008
		ASL	
		TAX	
		PLA	
		STA	!projectile_gfx_index,x	;get GFX index
		CLC	
		ADC	#$0200
		STA	!projectile_gfx_index+$04,x
		SEP	#$20
		LDA	#$01
		STA	!projectile_do_dma	;enable projectile DMA
		PLX	
		RTS	

boomerang_projectile:
		db $00,$01,$00,$01
.gfx		
		incsrc boomerang_gfx.bin
else
boomerang_tiles:
		db !boomerang_pro_tile_1,!boomerang_pro_tile_2
		db !boomerang_pro_tile_1,!boomerang_pro_tile_2
endif

boomerang:
	incsrc boomerang_props.asm