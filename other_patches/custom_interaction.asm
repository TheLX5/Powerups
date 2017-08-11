@include
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; A little patch that allows you to code special cases of Mario<->Sprites interaction


org $01A832|!base3
	!a JML force_hit_sprites

freecode

setup_def_interaction:
	LDA	!1662,x
	BPL	+
	LDA	!9E,x
	CMP	#$6D
	BEQ	.default
	LDA	!167A,x
	BPL	.default
	INC	!1594,x
	JML	$01AA00|!base3
.default	
	JML	$01A9E9|!base3
+		
	JML	$01AA01|!base3

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
	STA	$0E
	SEP	#$20
	PLX	
	JMP	($000E|!base1)
		
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
	incsrc custom_interaction_code.asm