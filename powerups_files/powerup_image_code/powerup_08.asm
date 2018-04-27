;;;;;;;;;;;;;;;;;;;
;; Frog Suit (SMB3)
;;;;;;;;;;;;;;;;;;;

.image
	lda $71
	ora $13ED|!base2
	ora $1493|!base2
	ora $148F|!base2
	bne .custom_anim
	lda $75
	bne .override
	lda $77
	and #$04
	bne .in_ground
	rts
.in_ground
	lda $15
	and #$03
	bne .not_looking_up
	lda $15
	and #$08
	beq .not_looking_up
	lda #$03
	bra .end
.not_looking_up

.override
	lda !power_ram
.end
	sta $13E0|!base2
.no	
	rts

.custom_anim
	bra .no
.walk_cycle
	lda $13E0|!base2
	lda !power_ram+3
	inc 
	sta !power_ram+3
	lsr #2
	and #$03
	tax
	lda.l .walk_poses,x
	bra .end

.walk_poses
	db $00,$01,$02,$01