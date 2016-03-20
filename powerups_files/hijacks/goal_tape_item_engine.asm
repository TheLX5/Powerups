;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Goal tape hax.
; Modifies the routine that gives an item if you carry a sprite after touching
; the goal tape.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

org $00FB26|!base3			
	db !max_powerup+$01
org $00FB2B|!base3
	db !max_powerup+$01
org $00FB30|!base3
	db !max_powerup+$01

org $00FB32|!base3
	STZ	$0F
	LDA.l	data00FADF,x
	STX	$02
	LDX	$0DC2|!base2
	CMP.l	data00FAFB,x
	BNE	+
	LDX	#$FF
	STX	$02
	LDA	#$00
	STA	$0F
	LDA	#$78
	BRA	+
org $00FB55|!base3
+		
!a	JSL goal_tape_hax
	BRA +
org $00FB64|!base3
	+