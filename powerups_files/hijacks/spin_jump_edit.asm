;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Handle spin jump ability
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

org $00EA89|!base3
!a	JSL SpinJump			;Controls which powerups can perform a spinjump.
	BRA +
	NOP #3
+
org $00D645|!base3
!a	JSL SpinJump			;Controls which powerups can perform a spinjump.
	BRA +
	NOP #3
+