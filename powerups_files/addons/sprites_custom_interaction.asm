;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; A little patch that allows you to code special cases of Mario<->Sprites interaction

force_hit_sprites_powerups:
	db $00,$00,$00,$00,$00,$00,$00,$00		;powerups 0-7
	db $00,$00,$00,$00,$00,$00,$00,$00		;powerups 8-F

force_hit_sprites:
		PHX	
		LDX	$19
		LDA.l	force_hit_sprites_powerups,x
		BEQ	.recover_code_hit_x
		DEC	
		ASL	
		TAX	
		REP	#$20
		LDA.l	.pointers,x
		STA	$00
		SEP	#$20
		PLX	
		JMP	($0000)
			
.recover_code_hit_x	
		PLX	
.recover_code_hit	
		LDA	!167A,x
		BPL	.default_interaction
.return_force		
		JML	$01A837|!base3
.default_interaction
		JML	$01A83B|!base3
.clc_rts
		JML	$01A7F5|!base3
.pointers
	incsrc sprites_custom_interaction_pointers.asm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; vvvv ---- Here goes your custom code ---- vvvv

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Tanooki code
;;

.tanooki
		lda	!flags
		cmp	#$01
		beq	..stone
		jmp	.recover_code_hit
..stone			
		phx	
		lda	!7FAB10,x
		and	#$08
		bne	..custom_sprite
		lda	!9E,x
		tax	
		lda.l	..normal_sprites_table,x
		bra	+
..custom_sprite		
		lda	!7FAB9E,x
		tax	
		lda.l	..custom_sprites_table,x
+			
		plx	
		sta	$00
		and	#$08
		bne	..pre_clc_rts
		lda	$77
		and	#$04
		beq	+
		jmp	.clc_rts
+			
		lda	#$04
		sta	!14C8,x
		lda	#$1F
		sta	!1540,x
		jsl	$07FC3B|!base3
		jsl	$01AB99|!base3
		lda	#$08
		sta	$1DF9|!base2
		lda	#$01
		jsl	$02ACE5|!base3
		jmp	.clc_rts
..pre_clc_rts		
		lda	$00
		and	#$20
		beq	..recover_code_hit
		jmp	.clc_rts
..recover_code_hit	
		jmp	.recover_code_hit
	incsrc interaction_codes/tanooki.asm

;; ^^^^ ---- Here goes your custom code ---- ^^^^
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;