;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Unlike the "%give_points()" already given on GPS, that only gives 10 points without
;;displaying the score sprite. Attempting to use "JSL $02ACE5" is dangerous as the
;;code itself uses sprite tables. This one displays the score sprite as if the
;;player kills a sprite. Inspired by code located at $02ACEF to $02ACF6 and
;;$02AD34 to $02AD4B.
;;
;;Input:
;; A:
;;  #$00 = ?
;;  #$01 = 10
;;  #$02 = 20
;;  #$03 = 40
;;  #$04 = 80
;;  #$05 = 100
;;  #$06 = 200
;;  #$07 = 400
;;  #$08 = 800
;;  #$09 = 1000
;;  #$0A = 2000
;;  #$0B = 4000
;;  #$0C = 8000
;;  #$0D = 1up
;;  #$0E = 2up
;;  #$0F = 3up
;;  #$10 = 5up (may glitch)
;;
;;Output:
;; X = index of score sprite (#$00-#$05)
;;
;;
;;Note:
;; The X and Y coordinates aren't written here automatically,
;; Use $98-$9B (block coordinates), AND it by #$FFF0/#$F0 to align it
;; (would simply round down to the nearest #$10. then use CLC : ADC/SEC :
;; SBC to displace it relative to the block.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	PHY				;>Preserve block behavior high byte.
	XBA				;>Preserve value used as the score sprite number
	
	;.FindFreeslot
	LDY #$05
	-
	LDA $16E1|!addr,y		;\If slot is free, return with Y being the available index.
	BEQ +				;/
	DEY				;>Next slot
	BPL -				;>Loop until no more available slots found.
	
	;..ReplaceOldestScoreSprite
	DEC $18F7|!addr			;>Index to replace the oldest score sprite
	BPL ++				;>If not negative, don't reset the index count back.
	LDA #$05			;\Reset the index count
	STA $18F7|!addr			;/
	++
	LDY $18F7|!addr			;>and use that index count
	+
	
	;Y = current score sprite slot to be spawned.
	
	;.WriteScoreSprite
	
	XBA				;>Restore A as the score sprite number
	STA $16E1|!addr,y		;>Score sprite number (0 = free slot)
	LDA #$30			;\Score sprite exist and speed timer (decaying speed)
	STA $16FF|!addr,y		;/
	
	TYX				;>copy value in Y and place to X.

	PLY				;>Restore block behavior high byte
	RTL