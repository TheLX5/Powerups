org $01ED38|!base3	;make imposible to ride yoshi when !flags isn't zero
	!a JML fix_yoshi

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This little patch checks if Mario should ride yoshi when !flags isn't zero

fix_yoshi:		
		PHX	
		LDX	$19
		LDA.l	.get_powerups,s
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This table controls which powerups should check if !flags =/= 0

.get_powerups
	db $00,$00,$00,$00,$00,$00,$00,$00		;powerups 0-7
	db $00,$00,$00,$00,$00,$00,$00,$00		;powerups 8-F