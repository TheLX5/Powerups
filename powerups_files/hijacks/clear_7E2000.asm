;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Clear almost 22000 bytes of RAM. Note that certain portions should NOT
; be used.
;  - Original patch
; Dunno why the patch says this, clearing all of the RAM doesn't seem to do
; anything bad... besides glitching the berries due to their tiles are in GFX32.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

org $0096B4|!base3
	if !clear_7E2000 == 1
!a		JSL Clear7E2000		;Cleans $7E2000 area.
	else				;only if Mode 7 Game Over patch isn't installed.
		LDX #$07
		LDA #$FF
	endif