
MarioBubble:
		LDA	$9D			;if $9D is set, just run graphics routine
		BNE	.Graphics
		JSR	bubble_hit		;make bubble interact with sprites
		LDA	!extra_extended,x	;decrease timer
		DEC	
		BNE	.not_pop		;if not zero, keep bubble alive
.force_pop
		PHX	
		TXY	
		JSR	SubSmoke		;call smoke routine
		LDA	#$02
		STA	$17C0|!base2,x		;change some info
		LDA	#$0C
		STA	$17CC|!base2,x		;to make it spawn a "contact" graphic
		PLX	
		STZ	$170B|!base2,x		;and kill bubble
		JSR	check_dma		;and stop DMA
		LDA	#$19
		STA	$1DFC|!base2		;sound when bubble pops
	;	LDA	#$08
	;	STA	!wait_timer
		RTS	
.not_pop		
		STA	!extra_extended,x	;keep time
		JSR	.handle_objects		;handle objects
		BCC	.force_pop
		LDA	$14
		AND	#$01
		BEQ	.nope_x
		LDA	$1747|!base2,x		;modify bubble X speed
		BEQ	.zero
		BMI	.minus
		DEC	#2
.minus			
		INC	A
.zero			
		STA	$1747|!base2,x
.nope_x		
		LDY	$173D|!base2,x		;make bubble rise
		LDA	$14
		AND	#$03
		BEQ	.no_dey
		DEY	
.no_dey			
		TYA
		STA	$173D|!base2,x		
		JSR	SpriteSpdNoGravity	;update positions without gravity
.Graphics	
		LDA	!extra_extended_2,x
		LSR	
		LDA	!extra_extended,x
		BCC	.in_air
		LSR	
.in_air		
		LSR	#3
		AND	#$03
	if !enable_projectile_dma == 1
		TAY	
		LDA.w	bubble_projectile,y	;update bubble image
		JSR	bubble_projectile_dma	;with DMA
	else
		STA	$05			;or make it a index
	endif	
		JSR	ExtGetDrawInfo		;call getdrawinfo
		LDA	$1779|!base2,x
		STA	$04			;retrieve some info
		PHX	
		TXA	
		SEC	
		SBC	#$08
		TAX	
		LDY.w	PowerOAM,x		;get oam index
		LDA	$01
		STA	$0200|!base2,y		;fill some basic info
		LDA	$02
		STA	$0201|!base2,y
	if !enable_projectile_dma == 1
		LDA.w	power_dynamic_tiles,x	;get DMA tile
	else	
		LDX	$05
		LDA.w	bubble_tiles,x		;get tile
	endif		
		STA	$0202|!base2,y
		PHY	
		LDA	#!bubble_pro_props	;get CCCT bits
		ORA	$64			;get PP bits
		LDY	$04
		BEQ	+
		AND	#$CF			;change PP bits if behind layers
		ORA	#$10
+		PLY	
		ORA	#$20			;and force them...?
		STA	$0203|!base2,y
		TYA	
		LSR	#2
		TAY	
		LDA	#$02			;bubble is 16x16
		STA	$0420|!base2,y
		PLX	
.ret		RTS	

.handle_objects
		JSR	ObjInteraction		;Fireball's object interaction
		PHA
		PHP	
		LDA	!extra_extended_2,x	;if bubble was in water...
		BNE	.spawn_in_water
.handle_water_level	
		PLP	
		PLA	
		BCC	.keep_floating		;if water level handle it like in normal levels
.force_pop_plus		
		CLC				;CLC = pop
		RTS	
.keep_floating		
		SEC				;SEC = no pop
		RTS	
.spawn_in_water		
		LDY	$85			;check if water level
		BNE	.handle_water_level
		PLP	
		PLA	
		BCS	.force_pop_plus		;check if it collides with solid objects
		LDA	$0F
		XBA	
		LDA	$0C
		REP	#$20
		CMP	#$0004			;check if touching water tiles
		SEP	#$20
		BCS	.force_pop_plus		;if not, pop it
		BRA	.keep_floating		;else keep it alive

bubble_hit:
		LDA	$13
		AND	#$01			;runs at 30fps
		BEQ	.run_code
		RTS	
.run_code		
		PHX	
		TXY	
		STY	$185E|!base2		;save projectile index for later
	if !SA1 == 1
		LDX.b	#21
	else		
		LDX	#$0B			;start looping through all sprite slots
	endif		
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
		LDA.w	bubble_normal_sprites,y		;handle normal sprites
		BRA	+
.IsCustom	LDA	!7FAB9E,x
		TAY	
		LDA.w	bubble_custom_sprites,y	;handle custom sprites
+		;LDY	$00
		STA	$0F			;store sprite info for later usage
		LDY	$185E|!base2
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
		BIT	#$10			;check if bubble should interact with sprites
		BEQ	+
		RTS	
+			
		AND	#$04			;check if sprite is imune to bubble
		BEQ	.no_pop
		TYX	
		JMP	MarioBubble_force_pop	;make it pop then
.no_pop			
		LDA	#$08
		STA	!14C8,x			;make sprite alive
		LDA	#$9D
		STA	!9E,x			;make it a bubble
		JSL	$07F7D2|!base3
		LDA	#$40
		STA	!154C,x
		LDA	!190F,x
		ORA	#$80			;set unused bit
		STA	!190F,x
		LDA	!D8,x
		SEC	
		SBC	#$02
		STA	!D8,x			;set Y position
		LDA	!14D4,x
		SBC	#$00
		STA	!14D4,x
		PHX	
		LDA	$1747|!base2,y		;Get velocity
		PHA	
		BMI	+
		LSR	
		BRA	++
+			
		EOR	#$FF			;uh...
		INC	
		LSR	
		EOR	#$FF			;uhhhhhhhhhhhhh
		INC	
++			
		STA	$00			;that didn't make too much sense...
		PLA	
		ASL				;it works anyways
		ROL	
		AND	#$01			;get direction
		TAX				;and use it as index
		LDA.w	.bubble_x,x		
		PLX	
		CLC	
		ADC	$00	;$1747|!base2,y	;add that thing that we did above
		STA	!B6,x			;and that's our X speed!
		LDA	#$1E
		STA	$1DF9|!base2		;sound
		LDA	#$00
		STA	$170B|!base2,y		;kill bubble
		JSR	check_dma		;stop DMA
		RTS	
.bubble_x
	db $04,$FC

if !enable_projectile_dma == 1
bubble_projectile_dma:
		PHX	
		LDX	$15E9|!base2		;get index
		REP	#$20
		AND	#$00FF
		ASL	#6
		CLC	
		ADC.w	#bubble_projectile_gfx	;this needs to be changed
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
		LDA	#bubble_projectile_gfx>>16
		STA	!projectile_gfx_bank
		LDA	#$01
		STA	!projectile_do_dma	;enable projectile DMA
		PLX	
		RTS	

bubble_projectile:
		db $03,$02,$01,$00
bubble_projectile_gfx:
	incbin bubble_gfx.bin
else
bubble_tiles:
		db !bubble_pro_tile_4,!bubble_pro_tile_3
		db !bubble_pro_tile_2,!bubble_pro_tile_1
endif

bubble:
incsrc bubble_props.asm