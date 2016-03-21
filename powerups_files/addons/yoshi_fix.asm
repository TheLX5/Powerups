;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This little patch checks if Mario should ride yoshi when !flags isn't zero

fix_yoshi:		
		PHX	
		LDX	$19
		LDA.l	.get_powerups
		BEQ	.invalid
		LDA	!flags
		BNE	.force_end_code
.invalid		
		LDA	$72
		BEQ	.force_end_code
		PLX	
		JML	$01ED3C|!base3
.force_end_code		
		PLX	
		JML	$01ED70|!base3

.get_powerups
	db $00,$00,$00,$00,$00,$00,$00,$00		;powerups 0-7
	db $00,$01,$00,$01,$00,$00,$00,$00		;powerups 8-F