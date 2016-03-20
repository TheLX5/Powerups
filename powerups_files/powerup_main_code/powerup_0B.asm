		LDA	$187A|!base2
		ORA	$1470|!base2
		BNE	.reset
		LDA	!flags
		ASL	
		TAX	
		JMP	(.PowerBPtrs,x)
		RTS	
.PowerBPtrs	
		dw	.CheckDownAndRun
		dw	.Sliding
			
.Sliding	
		STZ	$149B|!base2
		STZ	$18D2|!base2
		LDA	#$01
		STA	!disable_spin_jump
		STA	$73
		LDA	$75
		BEQ	.no_water
		LDA	$77
		AND	#$04
		BNE	.no_water
		LDA	#$80
.no_water	
		ORA	#$0F
		STA	!mask_15
		LDY	$76
		LDA.w	.InShellSpeed,y
		STA	$7B
		LDA	$77
		BIT	#$01
		BEQ	+
		STZ	$76
		LDA	#$01
		STA	$1DF9|!base2
		JSR	.CapeSpin
+		BIT	#$02
		BEQ	.NotInShell
		LDA	#$01
		STA	$76
		LDA	#$01
		STA	$1DF9|!base2
		JSR	.CapeSpin
.NotInShell
		;JSR	.hit_sprites
		BIT	$15
		BVS	.HoldXY
.reset
		LDA	#$00
		STA	!disable_spin_jump
		STA	!mask_15
		STA	!flags
		STA	$73
.HoldXY
		RTS	

.CapeSpin	;LDA	$19
		;ASL	
		;TAX	
		LDY	$76
		REP	#$20
		LDA	$94
		STA	$13E9|!base2
		LDA	$96
		CLC	
		ADC	#$0014
		STA	$13EB|!base2
		SEP	#$20
		LDA	#$04
		STA	$13E8|!base2
		RTS	

.CheckDownAndRun
	;	LDA	$75
	;	BEQ	.more_checks
	;	JSR	.water_physics
.more_checks		
		LDA	$13E4|!base2
		CMP	#$64
		BCC	.no_active
		CMP	#$70
		BCS	.no_active
		LDA	$73
		BEQ	.no_active
		LDA	#$01
		STA	!flags
		STA	$73
		LDA	$13E3|!base2
		BEQ	.no_active
		PHB	
		LDA	#$80
		PHA	
		PLB	
		PHK	
		PEA.w	.no_wall-1	;stop wall-walking
		PEA.w	$84CF-1
		JML	$00EB42|!base3
.no_wall	PLB	
.no_active		
		RTS	

.InShellSpeed
		db $D0,$30

.reset_flag
		JSR	.reset
		STA	$7B
		STA	$7D
		LDA	#$FF	
		STA	$1891|!base2
		JML	$01C309|!base3

pushpc
org $01A832|!base3	;if shell mario, kill the sprite unless bit 1 of $167A is set
			;or run some custom code (this one is for platform sprites and solid sprites)
		JML .force_hit_sprites
						
org $01ED38|!base3	;make imposible to ride yoshi when Mario is inside of the shell
		JML .fix_yoshi
			
org $01C304|!base3	;reset the "inside shell" flag when we get a balloon
		JML .reset_flag
pullpc

.fix_yoshi		
		LDA	$19
		CMP	#$09
		BEQ	+
		CMP	#$0B
		BNE	..no_shell
+
		LDA	!flags
		BNE	..force_end_code
..no_shell		
		LDA	$72
		BEQ	..force_end_code
		JML	$01ED3C|!base3
..force_end_code	
		JML	$01ED70|!base3

.force_hit_sprites
		LDA	$19
		CMP	#$09
		BEQ	..tanooki
		CMP	#$0C
		BEQ	..tiny
		CMP	#$0B
		BNE	..recover_code_hit
		LDA	!flags
		BEQ	..recover_code_hit
		JMP	..hit_sprites
..recover_code_hit		
		LDA	!167A,x
		BPL	..default_interaction
..return_force	
		JML	$01A837|!base3
..default_interaction
		JML	$01A83B|!base3
..tanooki		
		LDA	!flags
		CMP	#$01
		BNE	..recover_code_hit

		PHX	
		LDA	!7FAB10,x
		AND	#$08
		BNE	..IsCustom
		LDA	!9E,x
		TAX	
		LDA.l	NormalSpr,x
		BRA	+
..IsCustom	LDA	!7FAB9E,x
		TAX	
		LDA.l	CustomSpr,x
+			
		PLX	
		STA	$00
		AND	#$08
		BNE	..pre_clc_rts
	;	LDA	#$10
	;	STA	!154C,x
		LDA	$77
		AND	#$04
		BEQ	+
		JMP	..clc_rts
+			
		LDA	#$04
		STA	!14C8,x
		LDA	#$1F
		STA	!1540,x
		JSL	$07FC3B|!base3
		JSL	$01AB99|!base3
		LDA	#$08
		STA	$1DF9|!base2
		LDA	#$01
		JSL	$02ACE5|!base3
		JMP	..clc_rts ;..return_force
..pre_clc_rts		
		LDA	$00
		AND	#$20
		BEQ	..recover_code_hit
		BRA	..clc_rts
..tiny			
		PHB	
		PHK	
		PLB	
		LDA	!7FAB10,x
		AND	#$08
		BNE	++
		LDA	!9E,x
		TAY	
		LDA.w	.spr_tab,y
		BRA	+
++			
		LDA	!7FAB9E,x
		TAY	
		LDA.w	.cust_spr_tab,y
+			
		PLB	
		BIT	#$40
		BNE	+
		BIT	#$10
		BNE	++
		BIT	#$20
		BNE	+++
		JMP	..clc_rts
++			
		JMP	..recover_code_hit
+++
		JMP	..force_sec_rts
+			
		PHK	
		PEA.w	...SubVertPos-1
		PEA.w	$80CA-1
		JML	$01AD42|!base3
...SubVertPos	LDA	$0E
		CMP	#$EF
		BMI	++
-			
		JMP	..recover_code_hit
++			
		CPY	#$00
		BEQ	-
		LDA	#$03
		STA	$1DF9
		JSL	$01AA33|!base3
	;	JSL	$01AB99|!base3
		BRA	..clc_rts
..hit_sprites		
		LDA	!167A,x
		AND	#$02
		BNE	..check_flip_direction
		LDA	#$10
		STA	!154C,x
		LDA	#$02
		STA	!14C8,x
		LDA	#$D0
		STA	!AA,x
		LDY	$76
		LDA.w	$A839,y
		STA	!B6,x
		JSL	$01AB99|!base3
		LDA	#$14
		STA	$1DF9|!base2
		LDA	#$01
		JSL	$02ACE5|!base3
..clc_rts
		JML	$01A7F5|!base3

..check_flip_direction
		PHB	
		PHK	
		PLB	
		LDA	!7FAB10,x
		AND	#$08
		BNE	++
		LDA	!9E,x
		TAY	
		LDA.w	.spr_tab,y
		BRA	+
++			
		LDA	!7FAB9E,x
		TAY	
		LDA.w	.cust_spr_tab,y
+			
		PLB	
		BIT	#$01
		BNE	..force_sec_rts
		BIT	#$02
		BNE	..flip_shell
		BRA	..clc_rts
..sec_rts	
..force_sec_rts		
		JML	$01A837|!base3

..flip_shell	
		PHK	
		PEA.w	..SubVertPos-1
		PEA.w	$80CA-1
		JML	$01AD42|!base3
..SubVertPos		
		LDA	$0E
		CMP	#$EF
		BMI	..force_sec_rts
		LDA	$76
		EOR	#$01
		STA	$76
		LDA	$7B
		EOR	#$FF
		INC	
		STA	$7B
		LDA	#$01
		STA	$1DF9|!base2
		LDA	#$02
		STA	!154C,x
		JMP	..clc_rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Mario touchs the sprite when he inside of the shell and when he's tiny.
;; Table details:
;; x0 =	run no contact code on sprites (CLC : RTS)
;; x1 =	run original contact code on sprites (SEC : RTS)
;; x2 =	RUN original contact code on sprite if mario is on top of the sprite,
;;	but flips mario direction if there is contact on the side of the sprite.
;; To do: make the shell mario trigger flying question blocks and message boxes.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Tiny Mario details:
;; 0x = Run no contact code on sprites (CLC : RTS)
;; 1x = Run default interaction. (!167A,x or SEC : RTS)
;; 2x = Run contact code on sprites (SEC : RTS)
;; 4x = Bounce off sprite (not killing).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.spr_tab
	;   x0  x1  x2  x3  x4  x5  x6  x7  x8  x9  xA  xB  xC  xD  xE  xF
	db $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$10,$40	; 0x
	db $40,$40,$00,$10,$10,$10,$10,$00,$10,$00,$10,$40,$40,$10,$40,$40	; 1x
	db $10,$10,$40,$40,$40,$40,$10,$10,$10,$40,$10,$10,$40,$10,$10,$22	; 2x
	db $40,$10,$40,$10,$00,$10,$00,$10,$10,$10,$10,$10,$10,$10,$42,$40	; 3x
	db $40,$21,$21,$21,$10,$00,$40,$10,$10,$20,$10,$40,$00,$40,$40,$10	; 4x
	db $10,$40,$20,$00,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21	; 5x
	db $21,$21,$21,$21,$20,$10,$10,$10,$10,$00,$00,$21,$21,$22,$40,$40	; 6x
	db $10,$40,$40,$40,$21,$21,$21,$21,$21,$00,$00,$10,$00,$20,$10,$10	; 7x
	db $12,$21,$00,$22,$22,$00,$40,$20,$00,$00,$00,$00,$00,$00,$21,$21	; 8x
	db $12,$40,$40,$40,$40,$40,$40,$40,$40,$10,$10,$40,$21,$40,$10,$40	; 9x
	db $21,$21,$40,$21,$10,$10,$10,$00,$10,$00,$00,$40,$22,$22,$10,$10	; Ax
	db $10,$21,$10,$10,$10,$10,$10,$21,$21,$22,$21,$21,$20,$00,$40,$10	; Bx
	db $21,$21,$10,$10,$21,$00,$22,$21,$22,$00,$00,$00,$00,$00,$00,$00	; Cx
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$40,$40,$40,$40,$40,$40	; Dx
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; Ex
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; Fx

.cust_spr_tab

	;   x0  x1  x2  x3  x4  x5  x6  x7  x8  x9  xA  xB  xC  xD  xE  xF
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; 0x
	db $00,$40,$21,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; 1x
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; 2x
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; 3x
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; 4x
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; 5x
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; 6x
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; 7x
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; 8x
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; 9x
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; Ax
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; Bx
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; Cx
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; Dx
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; Ex
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00	; Fx