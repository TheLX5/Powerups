;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;This routine adjust the score sprite position. To be used after
;;"%give_points_special()" provided. Based from $02ACF9 to $02AD2A.
;;
;;This is separate in case if you want a different offset score sprite position.
;;
;;Input:
;; X = index of score sprite (#$00-#$05)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	LDA $9A			;\X position (low and high byte)
	AND #$F0		;|
	STA $16ED|!addr,x	;|
	LDA $9B			;|
	STA $16F3|!addr,x	;/
	LDA $98			;\Y position (low byte)
	AND #$F0		;|
	SEC			;|
	SBC #$08		;|
	STA $16E7|!addr,x	;/
	PHA			;>Save the Y position (low byte)
	LDA $99			;\Y position (high byte)
	SBC #$00		;|
	STA $16F9|!addr,x	;/
	PLA			;>load the Y position (low byte)
	SEC			;\Subtract by screen Y coordinate.
	SBC $1C			;/
	CMP #$F0		;\If not past the top of the screen, don't move it downwards
	BCC +			;/
	LDA $16E7|!addr,x	;\this would add by #$11 (17 in decimal) due to carry set.
	ADC #$10		;|
	STA $16E7|!addr,x	;|Move score sprite downwards (prevents past the top edge of the screen).
	LDA $16F9|!addr,x	;|
	ADC #$00		;|
	STA $16F9|!addr,x	;/
	+
	RTL