;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; /				   \ ;
;|  Propeller Mushroom main engine  |;
; \				   / ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; /	 \ ;
;|  Code  |;
; \	 / ;

;<  Main code  >;
	stz $1407|!base2	   ;>  Never be gliding with the cape.
	lda !PropStatusTimer	   ;\
	beq .IsZero		   ; |		>  Don't decrement if it's 0.
	dec : sta !PropStatusTimer ; | Handle time decrementing.
.IsZero				   ;/

	lda $75			  ;\  If in water...
	ora $74
	beq .continue
	jmp ClearStatus
.continue

	lda $1697|!base2
	cmp !power_ram+5
	beq .no_reset
	sta !power_ram+5
	lda #$00
	sta !PropStatus
.no_reset

	lda !PropStatus
	bpl +
	lda $77
	and #$04
	php
	lda !PropStatus
	plp
	beq +
	and #$7F
	sta !PropStatus
+	and #$7F
	beq +
	pha
	lda #$80
	tsb $15
	pla
+	tay
	lda $1470|!base2
	ora $148F|!base2
	beq +
	jmp ClearStatus
+	tya
	jsl $0086DF|!base3	;>  Jump to a location based on status index.
	dw .Normal		;>  $00 No special actions.
	dw .Propelling		;>  $01 Propelling.
	dw .Descending		;>  $02 Descending.
	dw .Spinning		;>  $03 "Friendly" spinning.
	dw .SpinAttacking	;>  $04 Spin-attacking.
	dw .04to02		;>  $05 From spin-attack to descent.

;< Status $00: Not flying >;

.Normal:
	lda #$07		;\
	sta !PropFlipFrequency	;/  Set propeller frequency to be every 8 frames.
	stz $140D|!base2	;>  Force the player to not be spin jumping (even if it's
				;   disabled in the misc. tables)

	lda $18			;\
	bpl ..Rtrn0 		;/  Return if not pressing A.

	lda !PropStatus
	bmi ..Rtrn0

	lda #$01		;\
	sta !PropStatus		;/  Set status to be flying.
	lda #$00		;\
	sta !PropFlipFrequency	;/  Set propeller frequency to be every frame.
	lda $76			;\
	asl			; | Set starting frame based on direction.
	sta !PropPlayerFrame	;/

	lda $13E3|!base2
	beq ..NotWallRunning
	and #$01 : TAX
	lda ..WallRunningDropXSpeeds,x
	sta $7B
	stz $13E3|!base2
..NotWallRunning

	lda !FlightTime		;\
	sta !PropStatusTimer	;/  Set flying time before starting to descend.
	stz $72
	stz $73			;>  Set the player to not be ducking.
	lda #$80		;\
	sta $1406|!base2	;/  Make the screen scroll vertically.
	lda #$80
	sta !mask_15
	lda !FlightSFX		;\
	sta !FlightSFXPort	;/  Play the sound effect.
	lda !FlightSpeed	;\  Set speed to #$D0. I'm doing this here to avoid a bug
	sta $7D			;/  in which the player can fly and touch the ground at the
				;   same time, cleaning the store to $1406.

..Rtrn0	rts			;>  Return.

..WallRunningDropXSpeeds:
	db $28,$D8

.Propelling:
	jsr CheckDownAndGround_CheckGround

	lda $71
	cmp #$05
	beq ..ClearStatus
	cmp #$06
	bne ..DontClearStatus
..ClearStatus
	Jmp ClearStatus
..DontClearStatus

	lda #$01 : jsr CheckPlayerSpinFrequency	;\
	bne ..DontUpdateFrame			;/

	lda !PropPlayerFrame	;\
	inc			; |
	cmp #$04		; |
	bcc ..DontReset		; | 
	lda #$00		; |
..DontReset			; |
	sta !PropPlayerFrame	;/
..DontUpdateFrame

	lda !PropStatusTimer	;\  If the timer is 0...
	beq ..StartingToDescend	;/  ...handle speed to start descending.
	lda !FlightSpeed	;\
	sta $7D			;/  Continue setting Y speed.

..Rtrn0	rts			;>  Return.

..StartingToDescend
	lda #$01		;\
	sta !PropFlipFrequency	;/  Set propeller frequency to be every 2 frames.
	and $14
	bne +
	dec $7D			;>  Decrement Y speed to make the descent start "accurate".
+
	lda $7D			;\
	sec : sbc #$13		; |
	cmp #$04		; | If Y speed is #$11, #$12 or #$13...
	bcs ..Rtrn1		;/  ...return. Otherwise, increment status.

..Descend
	lda #$03		;\
	sta !PropFlipFrequency	;/  Set propeller frequency to be every 4 frames.
	lda #$02		;\
	sta !PropStatus		;/  Set the powerup status to descending.
	lda !PropPlayerFrame	;\
	ora #$04		; | "Add" 4 to image index.
	sta !PropPlayerFrame	;/

..Rtrn1	rts

.Descending:
	jsr CheckDownAndGround

	lda #$14		;\
	sta $7D			;/  Set Y speed to #$11.
	lda $14			;\
	and #$03		; |
	bne ..DontUpdateFrame	;/
	lda !PropPlayerFrame
	inc
	cmp #$08
	bcc ..DontReset
	lda #$04
..DontReset
	sta !PropPlayerFrame
..DontUpdateFrame

	lda $18			;\
	bpl ..Rtrn0		;/  Return if not pressing A.

	lda #$03		;\
	sta !PropStatus		;/  Set status to be spinning.
	lda #$01		;\
	sta !PropFlipFrequency	;/  Set propeller frequency to be every 4 frames.
..ResetSpin
	lda !PropPlayerFrame	;\
	and #$FB		; | "Substract" 4 to image index.
	sta !PropPlayerFrame	;/
	lda #$3C		;\
	sta !PropStatusTimer	;/
	lda !FrndSpinSFX	;\
	sta !FrndSpinSFXPort	;/  Play the "friendly" spin sound effect.

..Rtrn0
	RtS

.Spinning:
	jsr CheckDownAndGround

	lda !PropStatusTimer
	bne ..ContinueCode
..GoToDescending
	Bra .Propelling_Descend
..ContinueCode

	lda #$15		;\
	sta $7D			;/  Set Y speed to #$11.

	lda #$15 : JSr CheckPlayerSpinFrequency	;\  If not time to update image...
	bne ..DontUpdateFrame			;/  ...branch to code.

	lda !PropPlayerFrame	;\
	inc			; |
	cmp #$04		; |
	bcc ..DontReset		; | 
	lda #$00		; |
..DontReset			; |
	sta !PropPlayerFrame	;/
..DontUpdateFrame

	lda $18
	bmi .Descending_ResetSpin

..Rtrn0	RtS

.SpinAttacking:
	stz $7B			;>  Clear X speed.
	lda #$83		;\
	sta !mask_15		;/  Player can't press Left, Right and A/B.
	lda #$01		;\
	sta $140D|!base2	;/  Set spin jumping.

	lda $77			;\
	and #$04		; | Branch if not touching ground.
	beq +			;/

	lda #$01		;\
	sta $1DF9|!base2	;/  Play "hit head" sound effect.
++	jmp ClearStatus		;>  Clear status and return from all this code.

+	lda !PropStatusTimer
	bne +
	lda $15
	and #$04
	beq ..SetTransition
+
	lda $14
	and #$01
	bne ..DontUpdateFrame

	lda !PropPlayerFrame	;\
	inc			; |
	cmp #$0C		; |
	bcc ..DontReset		; | Animate the player. 
	lda #$08		; |
..DontReset			; |
	sta !PropPlayerFrame	;/
..DontUpdateFrame

	ldy #$01		     ;\
	lda $7D			     ; |
	cmp #$36		     ; |
	bcs +			     ; |
	inc #3			     ; |
	bra ++			     ; |
+	lda #$3B		     ; |
	ldy #$00		     ; |
++	sta $7D			     ; |
	tya : sta !PropFlipFrequency ;/

	rts

..SetTransition
	lda #$05
	sta !PropStatus
	inc : sta !PropStatusTimer
	lda #$01
	sta !PropFlipFrequency
	dec
;	sta !disable_spin_jump
	sta $140D
	lda !PropPlayerFrame
	and #$03
	sta !PropPlayerFrame
	rts

.04to02:
	lda #$80
	sta !mask_15

	lda $7D
	bmi ++
	lda $77
	and #$04
	beq +
++	jmp ClearStatus
+
	lda $14
	and #$03
	bne ..DontUpdateFrame

	lda !PropPlayerFrame	;\
	inc			; |
	cmp #$04		; |
	bcc ..DontReset		; | 
	lda #$00		; |
..DontReset			; |
	sta !PropPlayerFrame	;/
..DontUpdateFrame

	lda $7D
	cmp #$17
	bcc +
	dec #6
	bra ++
+	lda #$02
	sta !PropStatus
	lda !PropPlayerFrame
	and #$03
	ora #$04
	sta !PropPlayerFrame
	lda #$17
++	sta $7D

	rts

;<  Checks if the player is on ground or pressing down and acts according to them  >;

CheckDownAndGround:
.CheckStomp
	lda $7D
	bpl .CheckGround
	lda #$80
	sta !PropStatus
	lda #$00
	sta !PropStatusTimer
;	sta !disable_spin_jump
	sta $140D|!base2
	pla : pla
	rts

.CheckGround
	lda $77			;\
	and #$04		; | If not touching ground...
	beq .CheckDown		;/  ...check if pressing down. Otherwise reset status.

.ResetStatus
	lda #$00		;\
	sta !PropStatus		;/  Set powerup status to 0.
	pla : pla		;\
	rts			;/  Return to SMW code.

.CheckDown
	lda !PropStatus
	cmp #$01
	bne ..DoCheckDown
	lda !PropStatusTimer
	cmp !FlightTime-$14
	bcs ..Rtrn0

..DoCheckDown
	lda $15
	and #$04
	beq ..Rtrn0

	sta !PropStatus		;>  Set powerup status to 4. A always contains #$04 due to
				;   the previous check.
	lda #$0A		;\
	sta $7D			;/  Set player's Y speed to #$04.
	lda !PropPlayerFrame
	and #$FB
	ora #$08
	sta !PropPlayerFrame
	lda #$06		;\
	sta !PropStatusTimer	;/  
	lda !SpinAtkSFX
	sta !SpinAtkSFXPort
	pla : pla		;\
..Rtrn0	rts			;/  Return to SMW code.

;<  A check to the frame counter with the status timer that can be used for anything  >;
;> Input:
; ¬ A should contain a limit for !PropStatusTimer where it will lower the frame counter's
;   frequency if !PropStatusTimer is under that value.

CheckPlayerSpinFrequency:
	sta $00
	lda !PropStatusTimer : TAY ;>  Load status timer into Y.
	lda $14			   ;\
	cpy $00			   ; |
	bcs +			   ; | Only update player's image every 2 or 4 frames,
	and #$03		   ; | depending of the timer's value.
	bra ++			   ; |
+	and #$01		   ;/
++	rts			   ;>  Return.

;<  Clears player's powerup status and timer  >;

ClearStatus:
	lda #$00
	sta !PropStatus
	sta !PropStatusTimer
	sta !power_ram+5
	sta !mask_15
	lda #$07		;\
	sta !PropFlipFrequency	;/  Set propeller frequency to be every 8 frames.
	stz $140D|!base2	;>  No more "spin jumping".
	rts