;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Handle powerup item gfx
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

org $01C6D1|!base3
!a	jml powerup_tiles		;Edits powerup item image.
	nop

if !dynamic_items == 1
org $01817D+($74*2)|!base3
	dw init_mushroom
	dw init_flower
	dw init_star
	dw init_feather
	dw init_1up

org $01C6DD|!base3
init_mushroom:
init_flower:
init_star:
init_feather:
init_1up:
!a	jsl init_powerup
	rts

org $02894F|!base3
!a	jsl question_block_fix

endif

