org $0196D7
	lda	$14

org $0180EA
!a	jml	ElecballParalyze
	
org $018AE5
!a	jml	BobOmbExplode
	nop
	
org $01962A
!a	jml	BobOmbExplode2
	nop
	
org $01D509
!a	jml	ParaBobOmbExplode	
	nop
	
org $01A7E4
!a	jml	PlyrInteractHack
	
org $01A40D
!a	jml	SprInteractHack

org $02BD23
!a	jml	SparkiesHealth
	
;<  Rearrange code  >;
	
org	$01B26F		;\
	lda	$9D		; |	Make this branch run the solid routine, off-screen handling and return.
	bne	$49		;/	From platforms 55-58.
	
org $02BB97		;\
	jsr	$D01F	; |
	lda	$9D		; |	Same, except it puts SubOffScreen before the check.
	bne	$5D		;/	From dolphins.
	
org $01B567		;\
	jmp	$B5A6	;/	From floating platforms.
	
org $01B53D		;\
	lda	$9D		; |	
	bne	$09		;/	From the orange platform that goes on forever.
	
if !SA1 == 0
!xpos = $E4,x

org $02DB9E
	lda	$9D
	bne	$3E
else
!xpos = ($EE)

org read3($02DB9F)+$26	;\
	jml	$02DBE0|!base3	;/	Sneak in SA-1 Pack's hijack for Amazin' Flying Hammer Bro.
endif
	
org	$01A152				;\
	lda	!xpos :	pha		; |
	lda	!1540,x			; |
	cmp	#$30			; |
	bcs	+				; |
	and	#$01			; |	Make this use sprite XPos for shaking instead of screen XPos.
	adc	!xpos			; |
	sta	!xpos			; |
+	jsl	$03B307|!base3	; |
	pla :	sta	!xpos	;/	For MechaKoopa.
	
org $038C32
	lda	$9D
	bne	$33				;/	For carrot tops.
	
org $038DBE
	lda	$9D
	bne	$21				;/	For timed lifts.
	
org $038A3F
	lda	$9D
	bne	$18
org $038A57
	jsl	$01802A|!base3
	jsl	$01B44F|!base3	;/	For Bowser statues.
	
org $038785
	lda	$9D
	bne	$4E				;/	For Mega Mole.
	
org $038702
	lda	$9D
	bne	$19				;/	For gray lava platform.
	
org $0385F9
	lda	$9D
	bne	$4C				;/	For flying grey turnblocks.
	
org	$038457
	lda	$9D
	bne	$1B				;/	For grey falling platform.
	
;<  For Rex  >:
	
org $07F26C+$91
db $10,$10,$10,$10,$10,$10,$10,$10

org $07F26C+$AB
db $10