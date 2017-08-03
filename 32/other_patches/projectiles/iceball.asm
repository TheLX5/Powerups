go_to_main:
		LDA	$170B|!base2,x
		CMP	#!iceball_num
		BNE	+
		LDA	!extra_extended,x
		DEC	
		BEQ	really_kill
		STA	!extra_extended,x
+		LDA	$1715|!base2,x
		SEC	
		RTL	

really_kill:	
		PHX	
		TXY	
		JSR	SubSmoke
		PLX	
		LDA	#$00
		STA	$170B|!base2,x
		INC	
		STA	$1DF9|!base2
		PLA	
		PLA	
		PLA	
		JML	$02A4BC|!base3

iceball:	
	PHB	
	PHK	
	PLB	
	INC	$1765|!base2,x	; restore hijacked code
	LDA	$170B|!base2,x
	CMP	#!iceball_num
	BEQ	.frozesprites
	JSR	Hit_Sprite	; otherwise check for interaction with sprites (and hurt if possible).
-	PLB	
	JML	$029FC8|!base3	; jump back to original code.
.frozesprites	
	JSR	ice_hit
	LDA	$170B|!base2,x
	BNE	-
	PLB	
	JML	$029F98|!base3

ice_hit:		
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
		JSR	IceClip		;get projectile clipping
		PLX	
		LDY	$185E|!base2
		JSL	$03B72B|!base3		;check for contact
		BCC	++
		LDA	!7FAB10,x
		AND	#$08			;is the sprite custom?
		BNE	.IsCustom
		LDY.w	!9E,x
		LDA.w	ice_normal_sprites,y		;handle normal sprites
		BRA	+
.IsCustom	LDA	!7FAB9E,x
		TAY	
		LDA.w	ice_custom_sprites,y		;handle custom sprites
+		;LDY	$00
		STA	$0F			;store sprite info for later usage
		LDY	$185E|!base2
		TXA	
		STA	$0E			;save sprite index
		LDA	$170B|!base2,y
		SEC	
		SBC	#$14			;get index for pointers
		ASL	
		TAX	
		JSR	.hit			;run interaction code
.finish		PLX	
		STX	$15E9|!base2		;don't check for more sprites
		RTS	
++		LDY	$185E|!base2
		DEX				;are we done with sprites?
		BMI	.finish			;yes
		BRA	.loop			;no

.hit			
		LDX	$0E
		LDA	$0F
		BIT	#$10			;projectile should interact with sprite?
		BEQ	+
		RTS	
+			
		AND	#$02			;is sprite imune to iceballs?
		BNE	.Puff
	;	LDA	!166E,x
	;	AND	#$10|
	;	BNE	.Puff
		LDA	!190F,x
		AND	#$08
		BRA	.InstantFroze		;insta-froze every sprite
		INC	!1528,x
		LDA	!1528,x
		CMP	#$05
		BCS	.InstantFroze
.Puff		JSR	SubSmoke		;make projectile die in a puff of smoke
		LDA	#$00
		STA	$170B|!base2,y
		INC	
		STA	$1DF9|!base2
		JSR	check_dma		;stop dma
+			
		RTS	
.InstantFroze	LDA	#$01
		STA	$1DFC|!base2
		PHX	
		JSR	SubSmoke		;kill projectile here too
		PLX	
		LDA	#$00
		STA	$170B|!base2,y
		JSR	check_dma		;stop dma
		LDA	!1588,x
		STA	$00			;get some settings
		LDA	!164A,x			
		STA	$01
		LDA	#$08			;make it "alive"
		STA	!14C8,x
		LDA	#$53			;Throw block.
		STA	!9E,x
		JSL	$07F7D2|!base3
		LDA	#$FF
		STA	!1540,x			;Max lifespan.
		LDA	$00
		STA	!1588,x
		AND	#$04			;The frozen sprite was touching the floor?
		BEQ	.NoFloor
		LDA	#$01			;Prevent shattering when the ice touch the floor
		STA	!C2,x
		BRA	.Nexty
.NoFloor	LDA	$01			;The frozen sprite was in water?
		BNE	.Nexty
		LDA	#$80			;If not, set fall timer.
		STA	!154C,x
.Nexty		LDA	#$22			;Force Ice block.
		STA	!1686,x
		LDA	#$A9
		STA	!167A,x
	;	LDA	$0F			;Get sprite ice block size
	;	AND	#$0C			;doesn't work with the current version of IceBlock.asm
	;	LSR				;unless I get a 32x32 solid sprite
	;	ORA	!C2,x
	;	STA	!C2,x			;Store in C2,x
.rts		RTS	

;;;;;;;;;;;;;;;;;;;
;; 
;; Edits the graphics routine of the original fireball.
;; 

iceball_edit:	LDA.l	$02A15F|!base3,x
		STA	$03
		PHX	
		LDX	$15E9|!base2
		LDA	$170B|!base2,x
		BEQ	+++
		CMP	#!iceball_num
		BNE	+
	if !enable_projectile_dma == 1
		;JSR	ExtGetDraw_NoIndex
		LDA	$14
		LSR	#2
		AND	#$03
		STA	$05
		TAX	
		LDA.l	iceball_projectile,x
		LDX	$15E9|!base2
		JSR	ice_projectile_dma
		TXA	
		SEC	
		SBC	#$08
		TAX	
	;	LDA.l	PowerOAM,x
	;	TAY	
		LDA.l	power_dynamic_tiles,x
		STA	$0202|!base2,y
		;LDX	$05
		PLX	
		LDA.l	Data02A15F,x
		EOR	$00
		ORA	$64
		STA	$0203|!base2,y
		LDX	$01
		BEQ	.skip
		AND	#$CF
		ORA	#$10
		STA	$0203|!base2,y
.skip
		LDA	$0200|!base2,y
		SEC	
		SBC	#$04
		STA	$0200|!base2,y
		LDA	$0201|!base2,y
		SEC	
		SBC	#$04
		STA	$0201|!base2,y
		TYA	
		LSR	#2
		TAY	
		LDA	#$02
		JML	$02A20A|!base3
	else	
		LDA	$14
		LSR	#3
		AND	#$03
		TAX	
		LDA.l	.TileData,x
	endif	
		STA	$0202|!base2,y
		PLX	
		LDA.l	Data02A15F,x
		BRA	++
+		PLX	
		LDA	$03
++		EOR	$00
		ORA	$64
		JML	$02A1F6|!base3
+++		
		LDA	#$F0
		STA	$0201|!base2,y
		PLX	
		JML	$02A204|!base3

	if !enable_projectile_dma == 1
	else
.TileData	db !iceball_tile_1,!iceball_tile_2,!iceball_tile_1,!iceball_tile_2
	endif
Data02A15F:	db !iceball_prop,!iceball_prop,!iceball_prop+$C0,!iceball_prop+$C0

if !enable_projectile_dma == 1

ice_projectile_dma:
		PHX	
		LDX	$15E9|!base2		;get index
		REP	#$20
		AND	#$00FF
		ASL	#6
		CLC	
		ADC.w	#iceball_projectile_gfx	;this needs to be changed
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
		LDA	#iceball_projectile_gfx>>16
		STA	!projectile_gfx_bank
		LDA	#$01
		STA	!projectile_do_dma	;enable projectile DMA
		PLX	
		RTS	

iceball_projectile:
		db $00,$01,$00,$01
iceball_projectile_gfx:
	incbin iceball_gfx.bin
endif

IceClip:
	LDA	$171F|!base2,x
	CLC	
	ADC	#$04
	STA	$04
	LDA	$1733|!base2,x
	ADC	#$00
	STA	$0A
	LDA	#$08
	STA	$06
	LDA	$1715|!base2,x
	CLC	
	ADC	#$04
	STA	$05
	LDA	$1729|!base2,x
	ADC	#$00
	STA	$0B
	LDA	#$08
	STA	$07
	RTS	

ice:
incsrc iceball_props.asm