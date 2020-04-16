; /        \ ;
;|  Macros  |;
; \        / ;
	
macro JSLrts(adress,label)
	phk :	pea.w	<label>-1
	pea.w	$0180CA-1
	jml	<adress>|!base3
endmacro
	
macro CheckBypass()
	lda	!sprite_shock_flags,x
	and	#$C0 :	cmp	#$C0
endmacro
	
; /                  \ ;
;|  Paralyzed sprite  |;
; \                  / ;
	
ElecballParalyze:
	lda	!sprite_shock,x		;\
	beq	.DecTimersJMP		;/	Lock sprite if timer is not #$00.
	lda	!14C8,x				;\
	cmp	#$08				; |
	bcc	.Pre_DecTimersJMP	; |	Only statuses #$08, #$09, #$0A and #$0B are valid.
	cmp	#$0C				; |
	bcs	.Pre_DecTimersJMP	;/
	
	phb
	phk
	plb
	jsr	ShockGFX
	plb
	
	lda	!14C8,x
	cmp	#$0B				;\
	bne	.NotCarried			;/	Special treatment if it's being carried.
	
;<  Paralyzed while carried  >;
	
	lda	!14C8,x :	pha		;>	Preserve sprite status.
	lda	!1540,x :	pha
	lda	!sprite_shock,x		;\
	dec						; |	Preserve shock timer.
	pha						;/
	lda	$14 :	pha			;>	Preserve frame counter.
	lda	#$00				;\	
	sta	!sprite_shock,x		;/
	lda	!sprite_shock_14,x	;\
	sta	$14					;/	Replace frame counter's value with the one the table preserved before the shock.
	
	phk :	pea.w	.D-1	;\
	pea.w	$0180CA-1		; |
	pea.w	$018127-1		; |	Run timers decrementing and carried sprite.
	jml	$0180F6|!base3		;/
	
.D	pla :	sta	$14				;>	Restore frame counter.
	pla :	sta	!sprite_shock,x	;>	Restore shock timer.
	pla :	sta	!1540,x	
	pla							;\
	cmp	!14C8,x					; |	If it hasn't been dropped, branch.
	beq	+						;/
	lda	#$00					;\
	sta	!sprite_shock,x			;/	Stop shocking if dropped.
+	jmp	.ExecutedSprite			;>	Jump to finish code.
	
;<  Hotfix so above branches can reach the code that's way below  >;
	
.Pre_DecTimersJMP
	lda	#$00
	sta	!sprite_shock,x
	sta	!sprite_shock_flags,x
	sta	!sprite_shock_14,x
.DecTimersJMP
	jmp	.DecTimers
	
;<  Paralyzed while NOT carried (normal, stationary or kicked)  >;
	
.NotCarried
	lda	$14 :	pha
	%CheckBypass()			;\
	bne	+					; |
	lda	!1528,x :	pha		; |	Zero this table and adress ONLY in case of bypass.
	stz	!1528,x				; |	Platforms move the player horizontally if these have a value.
	stz	$1491|!base2		;/
	lda	!1558,x :	pha		;>	Preserve this table that 
+	lda	$9D					;\
	sta	$5A					;/	Preserve lock flag in scratch RAM.
	lda	!sprite_shock_14,x
	sta	$14
	lda	#$01				;\
	sta	$9D					;/	Toggle on lock flag.
	
	%JSLrts($018127,.A)		;>	Run sprite with lock flag forced.
	
.A	
	lda	$9D					;\
	dec						; |	Branch if lock flag hasn't been modified.
	beq	+					;/	SMW gives it different values sometimes for some reason.
	lda	$9D					;\
	sta	$5A					;/	If it has been modified (i.e. by taking damage), edit the backup.
+	%CheckBypass()			;\
	bne	+					; |	If bypass on, restore !1528,x's value.
	pla :	sta	!1558,x
	pla :	sta	!1528,x		;/
+	pla :	sta	$14			;>	Restore frame counter.
	lda	!167A,x
	pha
	ora	#$80
	sta	!167A,x
	lda	!sprite_shock,x
	dec
	pha
	lda	#$00
	sta	!sprite_shock,x
	%CheckBypass()			;\
	beq	.NoContactJMP		;/	If bypassing, don't check for interaction.
	jsl $018032|!base3		;>	Interact with sprites.
	jsl	$01A7DC|!base3		;>	Interact with player.
	bcc	.NoContactJMP		;\
	lda	!154C,x				; |	If not touching or set to not interact with the player, skip.
	bne	.NoContactJMP		;/
	
	lda	!14C8,x				;\
	cmp	#$08				; |	If status is #$08, execute stomp check code.
	beq	.Normal				;/
	
.Stationary
	ply							;\
;	lda	#$00					; |
;	sta	!sprite_shock_flags,x	; |	Don't paralyze anymore.
;	tay							;/
	pla
	sta	!167A,x
	pha
	phy
	lda	!B6,x :	pha
	lda	!AA,x :	pha
	lda	!14C8,x :	pha
	stz	!B6,x
	stz	!AA,x
	stz	$9D
	stz	!154C,x
	%JSLrts($018127,.C)			;>	Run sprite again, this time with $9D clear.
.C	
	pla
	cmp	!14C8,x
	beq	.SameStatus
	pla :	pla
	lda	!14C8,x
	cmp	#$0B
	beq	+
	pla
	lda	#$00
	pha
+	jmp	.Finish
.SameStatus
	pla :	sta	!AA,x
	pla :	sta	!B6,x
	jmp	.Finish
	
.NoContactJMP
	jmp	.NoContact
	
.Normal
	lda	!sprite_shock_flags,x
	bpl	.DontKick
	and	#$40
	bne	.Finish
	lda	$7D
	bmi	.Kick
	lda	!1656,x
	and	#$10
	beq	.Kick
	
	lda	#$14				;\
	sta	$01					; |
	lda	$05					; |
	sec :	sbc	$01			; |
	rol	$00					; |
	cmp	$D3					; |
	php						; |	If not above sprite, kick it instead.
	lsr	$00					; |
	lda	$0B					; |
	sbc	#$00				; |
	plp						; |
	sbc	$D4					; |
	bmi	.Kick				;/
	
	lda	$02,s				;\
	bmi	.DontKick			;/	If it doesn't use default interaction, branch.
	
.Stomp
	pla							;\
	lda	#$00					; |
	sta	!sprite_shock_flags,x	; |	Don't paralyze anymore.
	pha							;/
	%JSLrts($01A8B0,.Finish)	;>	Run vanilla stomp code.
.Kick
	jsr	StarKill
	bra	.Finish
	
.DontKick
	stz	$9D
	lda	$02,s				;\
	bmi	.NotDefault			;/	If it doesn't use default interaction, branch.
	%JSLrts($01A83B,.B)		;>	Run default interaction.

.NotDefault
	%CheckBypass()			;\
	beq	.B					;/	If bypass is on, don't run again.
	pla							;\
	lda	#$00					; |
	sta	!sprite_shock_flags,x	; |	Don't paralyze anymore.
	pha							;/
	%JSLrts($018127,.B)		;>	Run sprite again, this time with $9D clear.
.B	
	lda	$9D
	sta	$5A
	
.Finish
	lda	#$08                
	sta	!154C,x
.NoContact
	pla
	sta	!sprite_shock,x
	lda	!167A,x
	and	#$7F
	sta	$00
	pla
	and	#$80
	ora	$00
	sta	!167A,x
	
	lda	$5A					;>	Restore $9D's original value.
	sta $9D
	lda	!154C,x
	beq	.ExecutedSprite
	dec	!154C,x
.ExecutedSprite
	pla :	pla				;>	Avoid the sprite running twice.
	jml	$0180B2|!base3		;>	Return to sprite loop.
	
.DecTimers
	lda	$9D
	bne	+
	jml	$0180EE|!base3
+	jml	$018126|!base3		;>	Return.
	
ShockGFX:
	jsl	GetDrawInfo
	
	lda	!sprite_shock,x
	cmp	#$3C
	rep	#$20
	bcs	.NotFading
	and	#$000c
	asl
	bra	.Store
.NotFading
	and	#$0006
	asl	#2
.Store
	sta	$03
	lda	!sprite_shock_flags,x
	and	#$000F
	xba
	lsr	#3
	ora	$03
	clc :	adc.w	#ShockTiles
	sta	$03
	sep	#$20
	lda.b	#ShockTiles>>16
	sta	$05
	
	lda	!sprite_shock,x
	cmp	#$3C
	bcs	.NotFading2
	and	#$0C
	lsr	
	bra	.Store2
.NotFading2
	and	#$06
.Store2
	lsr
	sta	$06
	stz	$08
	lda	!sprite_shock_flags,x
	and	#$C0 :	cmp	#$80
	beq	+
	lda	#$04
	sta	$08
+	
	lda	!sprite_shock_flags,x	;\
	and	#$0F					; |
	tax							; |	Get OAM slots required, and tile counter.
	lda.l	OAMSlots,x			; |
	sta	$07						;/
	
	lda	#$03
	sta	$02
	
.Loop
	lda	$06
	and	#$03
	ora	$08
	tax

	lda	[$03]
	rep	#$20
	inc	$03
	sep	#$20
	clc :	adc	$00
	sta	$0300|!base2,y
	
	lda	[$03]
	rep	#$20
	inc	$03
	sep	#$20
	cmp	#$80
	beq	+
	clc :	adc	$01
	sta	$0301|!base2,y
	
	lda	#$C2
	sta	$0302|!base2,y
	
	lda.l	ShockPalette,x
	ora	$64
	sta	$0303|!base2,y
	
	iny	#4
+	inc	$06
	dec	$02
	bpl	.Loop
	
	ldx	$15E9|!base2
	ldy	#$02
	lda	$07
	pha
	jsl	$01B7B3|!base3
	
	pla
	inc
	asl	#2
	clc :	adc	!15EA,x
	sta	!15EA,x
	rts
	
	
ShockTiles:
incsrc ParalyzeEffects.asm
ShockPalette:
db $00,$44,$82,$C6			;>	Kickeable.
db $08,$40,$88,$C2			;>	Non-kickeable.
	
OAMSlots:
db $00,$03,$01,$01,$01,$02,$03,$03
db $03,$03,$00,$00,$00,$00,$00,$00
	
;<  Simulate a star kill  >;
	
StarKill:
	lda	#$02			; \ status = 2 (being killed by star)
	sta	!14C8,x			; /
	lda	#$D0			; \ set y speed
	sta	!AA,x			; /
	ldy #$00			;\
	lda $94				; |
	cmp !E4,x			; |
	lda $95				; |	SubHorzPos.
	sbc !14E0,x			; |
	bpl +				; |
	iny					;/
+	lda.w	$01A839,y	; \ set x speed based on direction
	sta	!B6,x			; /
	lda	#$00
	jsl	$02ACE5|!base3
	lda	#$03
	sta	$1DF9|!base2
	rts
.xSPD
db $F0,$10
	
BobOmbExplode:
	lda	!1534,x
	bne	.ExplodeBomb
	lda	!1FD6,x
	bne	.ActualExplosion
	jml	$018AEA|!base3
.ExplodeBomb
	jml	$018ADA|!base3
	
.ActualExplosion
	lda	#$09 :	sta	!14C8,x
	lda	#$02
	jml	$018AF6|!base3
	
BobOmbExplode2:
	lda	!1FD6,x
	bne	.ExplodeBomb
	lda	!1540,x
	cmp	#$01
	jml	$01962F|!base3
	
.ExplodeBomb
	jml	$019631|!base3
	
ParaBobOmbExplode:
	lda	!1FD6,x
	beq	+
	lda	#$0D
	sta	!9E,x
	jsl	$07F7D2|!base3
	lda	#$08 :	sta	!14C8,x
	lda	#$01 :	sta	!1534,x
	lda	#$30 :	sta	!1540,x
	lda	!1656,x
	ora	#$80
	sta	!1656,x
	lda	!167A,x
	ora	#$02
	sta	!167A,x
ReturnPar:
	jml	$0185C2|!base3
	
+	lda	!1540,x
	bne	+
	jml	$01D50E|!base3
+	jml	$01D558|!base3
	
SparkiesHealth:
	cmp	#$A5
	bcc	+
	lda	!1FD6,x
	cmp	#$03
	bne	.GoNormal
	lda	#$04
	sta	!14C8,x
	lda	#$1F
	sta	!1540,x
	lda	#$00
	jsl	$02ACE5|!base3
	lda	#$03
	sta	$1DF9|!base2
	rtl
	
.GoNormal
	jml	$02BD27
+	jml	$02BD2C
	
; /                                                                       \ ;
;|  Restrict interaction for paralyzed enemies so it can be handled above  |;
; \                                                                       / ;
	
PlyrInteractHack:
	lda	!sprite_shock,x		;\
	beq	+					;/
	%CheckBypass()			;\
	bne	ReturnPar			;/	If bypass on, force interact.
+	lda	!167A,x
	and	#$20
	jml	$01A7E9|!base3
	
SprInteractHack:
	lda	!sprite_shock,x		;\
	bne	ReturnPar			; |
	txa
	beq	ReturnPar
	tay
	jml	$01A411|!base3

	