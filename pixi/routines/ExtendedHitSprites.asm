; check contact between powerup projectile and enemy
; input: 
; X = Extended sprite index.
; Y = Extended sprite index.
; 
; output:
; carry set = collision was found
; carry clear = collision wasn't found
; 

	txy
	sty $185E|!Base2
	ldx.b #!SprSize-1
.loop	
	stx $15E9|!Base2
	lda !14C8,x
	cmp #$08
	bcc .ignore
;	lda !167A,x
;	and #$02
	lda !15D0,x
	ora !1632,x
	eor !extended_behind,y
	bne .ignore
	jsl $03B6E5|!BankB
	jsl $03B72B|!BankB
	bcs .collision
.ignore
	ldy $185E|!Base2
	dex
	bpl .loop 
	sty $15E9|!Base2
	tyx
	clc
	rtl
.collision
	lda !7FAB10,x
	and #$08
	bne .is_custom
	ldy.w !9E,x
	bra .continue
.is_custom
	rep #$20
	inc $8A
	inc $8A
	sep #$20
	lda !7FAB9E,x
	tay
.continue
	rep #$30
	lda ($8A)
	sta $8A
	sep #$20
	lda [$8A],y
	sep #$10
	sta $0F
	and #$10
	bne .ignore
	ldy $185E|!Base2
	sec
	rtl