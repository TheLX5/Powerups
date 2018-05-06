;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Goal tape hax.
; Modifies the routine that gives an item if you carry a sprite after touching
; the goal tape.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

goal_tape_hax:
	sta.w !9E,y
	tyx 
	jsl $07F7D2|!base3
	stz !1510,x
	stx $15E9|!base2
	ldx $02
	cpx #$FF
	beq .regular
	lda.l data00FADF_settings,x
	beq .regular
	tyx
	lda $0F
	pha
	lda.b !9E,x
	sta !7FAB9E,x
	lda #$88
	sta !7FAB10,x
	jsl $0187A7|!base3
	jsl init_item
	pla 
	sta $0F
	txy
	rtl
.regular
	ldx $15E9|!base2
	jsl init_item
	txy
	rtl