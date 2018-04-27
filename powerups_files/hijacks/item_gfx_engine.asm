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

org $03C31C|!base3
!a	jsl invisible_mushroom_fix

org $03C301|!base3
!a	jsl green_mushroom_checkpoint_fix

org $02EB19|!base3
!a	jsl super_koopa_fix

org $02D980|!base3
!a	jsl bubble_fix

endif
