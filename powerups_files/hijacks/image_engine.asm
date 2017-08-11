;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Handle player tile data
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

org $00E36D
!a	jml Tiles

;org $00E3E4|!base3
;!a	jml OAM_data
;	ldx $04
;	cpx #$E8
org $00E489
;!a	jsl OAM_x_pos
;	clc
;	adc.w $DD4E,x

org $00E471
;!a	jsl OAM_y_pos
;	clc
;	adc.w $DD32,x

org $00E461
;!a	jml OAM_8x8
;	nop
;	ldx $06
;	lda $DFDA,x