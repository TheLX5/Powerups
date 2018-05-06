;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Miscelaneous routines for sprites.
;; Ripped from SMW.
;;
;; ----------------------------------------------------------------------
;; 
;; SubHorzPos or SUB_HORZ_POS:
;;	Routine to get the horizontal distance between Mario and a sprite.
;;	
;; Input:
;;	X = Sprite index
;; 
;; Output:
;;	Y = 0, Mario is to the right of the sprite.
;;	Y = 1, Mario being on the left.
;;	$0E = Distance between Mario and the sprite. (16-bit)
;;
;; ----------------------------------------------------------------------
;; 
;; SubVerPos or SUB_VERT_POS:
;;	Routine to get the vertical distance between Mario's Head and
;;	a sprite.
;;	
;; Input:
;;	X = Sprite index
;; 
;; Output:
;;	Y = 0, Mario is above of the sprite.
;;	Y = 1, Mario is below of the sprite
;;	$0E = Distance between Mario and the sprite. (16-bit)
;;
;; ----------------------------------------------------------------------

SubHorzPos:
SUB_HORZ_POS:
	ldy #$00
	lda $94
	sec
	sbc !E4,x
	sta $0E
	lda $95
	sbc !14E0,x
	sta $0F
	bpl $01
	iny
	rtl

SubVertPos:
SUB_VERT_POS:
	ldy #$00
	lda $96
	sec
	sbc !D8,x
	sta $0E
	lda $97
	sbc !14D4,x
	sta $0F
	bpl $01
	iny
	rtl