;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Goal tape hax.
; Modifies the routine that gives an item if you carry a sprite after touching
; the goal tape.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

goal_tape_hax:
	STA.w	!9E,y
	TYX	
	JSL	$07F7D2|!base3
	LDX	$02
	CPX	#$FF
	BEQ	.return
	LDA.l	data00FADF_settings,x
	BEQ	.return
	TYX	
	LDA	$0F
	PHA	
	LDA.b	!9E,x
	STA	!7FAB9E,x
	LDA	#$08
	STA	!7FAB10,x
	JSL	$0187A7|!base3
	PLA	
	STA	$0F
	TXY	
.return		
	RTL	