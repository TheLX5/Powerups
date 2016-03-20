	LDA	$73
	ORA	$74
	ORA	$187A|!base2
	ORA	$1470|!base2
	BNE	.return
		
	BIT	$16
	BVS	.shoot_bubble
	LDA	$140D|!base2
	BEQ	.return
	INC	$13E2|!base2
	LDA	$13E2|!base2
	AND	#$0F
	BNE	.return
	TAY	
	LDA	$13E2|!base2
	AND	#$10
	BEQ	+
	INY	
+		
	STY	$76
.shoot_bubble	
	LDX	#$0B
.loop_normal
	LDA	!14C8,x
	CMP	#$08
	BNE	.dex
	LDA	!9E,x
	CMP	#$9D
	BEQ	.bubble_sprite_found
.dex
	DEX	
	BPL	.loop_normal
	BRA	.prepare_bubble
.bubble_sprite_found
	LDA	!190F,x
	BMI	.return
	BRA	.dex
.prepare_bubble
	LDX	#$08
	LDA	$170B|!base2,x
	BEQ	.found_slot
.return
	RTS	
.found_slot	
	LDA	!wait_timer
	BNE	.return
	LDA	#$01
	STA	!projectile_do_dma
	LDA	#$02		; play sfx
	STA	$1DFC|!base2
	LDA	#$0A		; show shooting pose
	STA	$149C|!base2
	LDA	#!bubble_num		; ext sprite number
	STA	$170B|!base2,x
	LDA	#$0A		; y speed
	STA	$173D|!base2,x

	LDY	$76
	LDA	$94			; x position lo/hi
	CLC	
	ADC	.x_disp,y
	STA	$171F|!base2,x
	LDA	$95
	ADC	#$00
	STA	$1733|!base2,x		; y position lo/hi
	LDA	$96
	CLC	
	ADC	#$08
	STA	$1715|!base2,x
	LDA	$97
	ADC	#$00
	STA	$1729|!base2,x
	LDA	$13F9|!base2		; go behind fg stuff
	STA	$1779|!base2,x
	STZ	$175B|!base2,x		; hit counter = 0
	STZ	$01
	LDY	#$1E
	LDA	$75
	ORA	$85
	STA	!extra_extended_2,x
	BEQ	.no_water
	LDY	#$3C
	LDA	#$22
	STA	$01
	BRA	.store_duration
.no_water	
	LDA	#$16
	STA	$01
.store_duration
	TYA	
	STA	!extra_extended,x
	PHX	
	STZ	$00
	LDA	$76
	CLC	
	ROR 	#2
	EOR	$7B
	BPL	+
	LDA	$7B
	STA	$00
+	LDA	$01
	LDX	$76
	BNE	+
	EOR	#$FF
	INC	A
+	CLC	
	ADC	$00
		
	PLX	
	STA	$1747|!base2,x
	RTS	
	
;7b $30 values

.x_disp
	db $00,$08