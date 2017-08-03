;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Clear almost 22000 bytes of RAM. Note that certain portions should NOT
; be used.
;  - Original patch
; Dunno why the patch says this, clearing all of the RAM doesn't seem to do
; anything bad... besides glitching the berries due to their tiles are in GFX32.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

if !clear_7E2000 == 1
Clear7E2000:
	REP	#$30
	LDX	#$5BFE
-		
	TXA	
	SEC	
	SBC	#$4D80
	CMP	#$0080
	BCC	+
	TXA	
	SEC	
	SBC	#$4F80
	CMP	#$0080
	BCC	+
		
	LDA	#$0000
	STA	$7E2000,x
+		
	DEX	#2
	BPL	-
	SEP	#$30
	LDX	#$07
	LDA	#$FF
	RTL	
endif