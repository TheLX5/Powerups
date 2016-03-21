MarioHammer:
		LDA	$9D			;go to graphics routine if $9d is set
		BNE	.Graphics
		JSR	SpriteSpd		;update position with gravity
		LDA	!extra_extended_2,x
		AND	#$80			;don't process interaction if bit is set
		BNE	.Graphics
		JSR	hammer_hit		;process interaction with sprites
			
		LDA	$13
		AND	#$01			;process interaction with layer 1 blocks
		BEQ	.no_process
		JSR	GetMap16
		PHX	
		REP	#$30
		LDY.w	#hammer_table_end-hammer_table-$03
.loop			
		CMP.w	hammer_table,y		;loop until find some interactive block
		BEQ	.found
		DEY	#3
		BPL	.loop
		SEP	#$30
		BRA	.back
.found			
		LDA	#$0000			;get interaction index
		SEP	#$20
		LDA.w	hammer_table+$02,y
		REP	#$20
		TXY	
		ASL	
		TAX	
		JSR	(InteractPointers,x)	;run code
.back			
		PLX	
.no_process		
		LDA	!extra_extended,x	;update hammer image
		LDY	$1747|!base2,x
		BPL	+
		DEC	A
		DEC	A
+		INC	A
		STA	!extra_extended,x
	if !enable_projectile_dma == 1
		LSR	#2
		AND	#$07
		TAY	
		LDA.w	hammer_projectile,y	;update image via DMA
		JSR	hammer_projectile_dma
	endif
.Graphics	;LDA	$1747|!base2,x
	;	AND	#$80
	;	ROL	#2
	;	STA	$03
		JSR	ExtGetDraw_NoIndex	;call getdrawinfo
		LDA	$1779|!base2,x		;get more info
		STA	$04
		LDA	!extra_extended,x	;get image info
		LSR	#2
		AND	#$07
		STA	$00
		PHX	
		TXA	
		SEC	
		SBC	#$08
		TAX	
		LDY.w	PowerOAM,x		;get oam index
	if !enable_projectile_dma == 1
		LDA.w	power_dynamic_tiles,x	;get tile
	else	
		LDX	$00
		LDA.w	hammer_tiles,x		;get tile based on image info
	endif	
		STA	$0202|!base2,y
		LDA	$01
		STA	$0200|!base2,y		;fill YX coordinates
		LDA	$02
		STA	$0201|!base2,y
		LDX	$00			;get YX bits based on image info
		LDA.w	hammer_props,x
		ORA	$64			;get PP bits
		LDX	$04
		BEQ	+
		AND	#$CF			;change PP bits based on $1779
		ORA	#$10
+		STA	$0203|!base2,y
		TYA	
		LSR	#2
		TAX	
		LDA	#$02			;tile size is 16x16
		STA	$0420|!base2,x
		PLX	
.ret		RTS	

hammer_hit:		
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
		LDA.w	hammer_normal_sprites,y	;handle normal sprites
		BRA	+
.IsCustom	LDA	!7FAB9E,x
		TAY	
		LDA.w	hammer_custom_sprites,y	;handle custom sprites
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
		LDA	$0F
		AND	#$10			;Hammer should interact with sprites?
		BNE	.return	
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
.return			
		RTS	

.KillSpd	db $18,$E8			;killed sprite speeds

if !enable_projectile_dma == 1

hammer_projectile_dma:
		PHX	
		LDX	$15E9|!base2		;get index
		REP	#$20
		AND	#$00FF
		ASL	#6
		CLC	
		ADC.w	#hammer_projectile_gfx	;this needs to be changed
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

hammer_projectile:
		db $00,$01,$01,$00,$00,$01,$01,$00
.gfx
		incbin hammer_gfx.bin
else
hammer_tiles:
		db !hammer_pro_tile_1,!hammer_pro_tile_2
		db !hammer_pro_tile_2,!hammer_pro_tile_1
		db !hammer_pro_tile_1,!hammer_pro_tile_2
		db !hammer_pro_tile_2,!hammer_pro_tile_1
endif
hammer_props:	
		db !hammer_pro_props+$40,!hammer_pro_props+$40
		db !hammer_pro_props,!hammer_pro_props
		db !hammer_pro_props+$80,!hammer_pro_props+$80
		db !hammer_pro_props+$C0,!hammer_pro_props+$C0

hammer:
incsrc hammer_props.asm