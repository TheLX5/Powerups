;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; /				   \ ;
;|  Propeller Mushroom main engine  |;
; \				   / ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; /	 \ ;
;|  Code  |;
; \	 / ;

;<  Main code  >;

	StZ $1407|!base2	   ;>  Never be gliding with the cape.
	LdA !PropStatusTimer	   ;\
	BEq .IsZero		   ; |		>  Don't decrement if it's 0.
	Dec : StA !PropStatusTimer ; | Handle time decrementing.
.IsZero				   ;/

	lda $1891|!base2	  ; | ...or in P-Balloon status...
	beq +		  ;/  ...return.
	rts
+	
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

	LdA !PropStatus
	BPl +
	LdA $77
	AND #$04
	PhP
	LdA !PropStatus
	PlP
	BEq +
	AND #$7F
	StA !PropStatus
+	AND #$7F
	BEq +
	PhA
	LdA #$80
	TSB $15
	PlA
+	TAY
	LdA $1470|!base2
	ORA $148F|!base2
	BEq +
	Jmp ClearStatus
+	TYA
	JSL $0086DF|!base3	;>  Jump to a location based on status index.
	dw .Normal		;>  $00 No special actions.
	dw .Propelling		;>  $01 Propelling.
	dw .Descending		;>  $02 Descending.
	dw .Spinning		;>  $03 "Friendly" spinning.
	dw .SpinAttacking	;>  $04 Spin-attacking.
	dw .04to02		;>  $05 From spin-attack to descent.

;< Status $00: Not flying >;

.Normal:
	LdA #$07		;\
	StA !PropFlipFrequency	;/  Set propeller frequency to be every 8 frames.
	StZ $140D|!base2	;>  Force the player to not be spin jumping (even if it's
				;   disabled in the misc. tables)

	LdA $18			;\
	BPl ..Rtrn0 		;/  Return if not pressing A.

	LdA !PropStatus
	BMi ..Rtrn0

	LdA #$01		;\
	StA !PropStatus		;/  Set status to be flying.
	LdA #$00		;\
	StA !PropFlipFrequency	;/  Set propeller frequency to be every frame.
	LdA $76			;\
	ASL			; | Set starting frame based on direction.
	StA !PropPlayerFrame	;/

	LdA $13E3|!base2
	BEq ..NotWallRunning
	AND #$01 : TAX
	LdA ..WallRunningDropXSpeeds,x
	StA $7B
	StZ $13E3|!base2
..NotWallRunning

	LdA !FlightTime		;\
	StA !PropStatusTimer	;/  Set flying time before starting to descend.
	StZ $72
	StZ $73			;>  Set the player to not be ducking.
	LdA #$80		;\
	StA $1406|!base2	;/  Make the screen scroll vertically.
	LdA #$80
	StA !mask_15
	LdA !FlightSFX		;\
	StA !FlightSFXPort	;/  Play the sound effect.
	LdA !FlightSpeed	;\  Set speed to #$D0. I'm doing this here to avoid a bug
	StA $7D			;/  in which the player can fly and touch the ground at the
				;   same time, cleaning the store to $1406.

..Rtrn0	RtS			;>  Return.

..WallRunningDropXSpeeds:
	db $28,$D8

.Propelling:
	JSr CheckDownAndGround_CheckGround

	LdA $71
	Cmp #$05
	BEq ..ClearStatus
	Cmp #$06
	BNE ..DontClearStatus
..ClearStatus
	Jmp ClearStatus
..DontClearStatus

	LdA #$01 : JSr CheckPlayerSpinFrequency	;\
	BNE ..DontUpdateFrame			;/

	LdA !PropPlayerFrame	;\
	Inc			; |
	Cmp #$04		; |
	BCC ..DontReset		; | 
	LdA #$00		; |
..DontReset			; |
	StA !PropPlayerFrame	;/
..DontUpdateFrame

	LdA !PropStatusTimer	;\  If the timer is 0...
	BEq ..StartingToDescend	;/  ...handle speed to start descending.
	LdA !FlightSpeed	;\
	StA $7D			;/  Continue setting Y speed.

..Rtrn0	RtS			;>  Return.

..StartingToDescend
	LdA #$01		;\
	StA !PropFlipFrequency	;/  Set propeller frequency to be every 2 frames.
	AND $14
	BNE +
	Dec $7D			;>  Decrement Y speed to make the descent start "accurate".
+
	LdA $7D			;\
	SeC : SbC #$13		; |
	Cmp #$04		; | If Y speed is #$11, #$12 or #$13...
	BCS ..Rtrn1		;/  ...return. Otherwise, increment status.

..Descend
	LdA #$03		;\
	StA !PropFlipFrequency	;/  Set propeller frequency to be every 4 frames.
	LdA #$02		;\
	StA !PropStatus		;/  Set the powerup status to descending.
	LdA !PropPlayerFrame	;\
	ORA #$04		; | "Add" 4 to image index.
	StA !PropPlayerFrame	;/

..Rtrn1	RtS

.Descending:
	JSr CheckDownAndGround

	LdA #$14		;\
	StA $7D			;/  Set Y speed to #$11.
	LdA $14			;\
	AND #$03		; |
	BNE ..DontUpdateFrame	;/
	LdA !PropPlayerFrame
	Inc
	Cmp #$08
	BCC ..DontReset
	LdA #$04
..DontReset
	StA !PropPlayerFrame
..DontUpdateFrame

	LdA $18			;\
	BPl ..Rtrn0		;/  Return if not pressing A.

	LdA #$03		;\
	StA !PropStatus		;/  Set status to be spinning.
	LdA #$01		;\
	StA !PropFlipFrequency	;/  Set propeller frequency to be every 4 frames.
..ResetSpin
	LdA !PropPlayerFrame	;\
	AND #$FB		; | "Substract" 4 to image index.
	StA !PropPlayerFrame	;/
	LdA #$3C		;\
	StA !PropStatusTimer	;/
	LdA !FrndSpinSFX	;\
	StA !FrndSpinSFXPort	;/  Play the "friendly" spin sound effect.

..Rtrn0
	RtS

.Spinning:
	JSr CheckDownAndGround

	LdA !PropStatusTimer
	BNE ..ContinueCode
..GoToDescending
	Bra .Propelling_Descend
..ContinueCode

	LdA #$15		;\
	StA $7D			;/  Set Y speed to #$11.

	LdA #$15 : JSr CheckPlayerSpinFrequency	;\  If not time to update image...
	BNE ..DontUpdateFrame			;/  ...branch to code.

	LdA !PropPlayerFrame	;\
	Inc			; |
	Cmp #$04		; |
	BCC ..DontReset		; | 
	LdA #$00		; |
..DontReset			; |
	StA !PropPlayerFrame	;/
..DontUpdateFrame

	LdA $18
	BMi .Descending_ResetSpin

..Rtrn0	RtS

.SpinAttacking:
	StZ $7B			;>  Clear X speed.
	LdA #$83		;\
	StA !mask_15		;/  Player can't press Left, Right and A/B.
	LdA #$01		;\
	StA $140D|!base2	;/  Set spin jumping.

	LdA $77			;\
	AND #$04		; | Branch if not touching ground.
	BEq +			;/

	LdA #$01		;\
	StA $1DF9|!base2	;/  Play "hit head" sound effect.
++	Jmp ClearStatus		;>  Clear status and return from all this code.

+	LdA !PropStatusTimer
	BNE +
	LdA $15
	AND #$04
	BEq ..SetTransition
+
	LdA $14
	AND #$01
	BNE ..DontUpdateFrame

	LdA !PropPlayerFrame	;\
	Inc			; |
	Cmp #$0C		; |
	BCC ..DontReset		; | Animate the player. 
	LdA #$08		; |
..DontReset			; |
	StA !PropPlayerFrame	;/
..DontUpdateFrame

	LdY #$01		     ;\
	LdA $7D			     ; |
	Cmp #$36		     ; |
	BCS +			     ; |
	Inc #3			     ; |
	Bra ++			     ; |
+	LdA #$3B		     ; |
	LdY #$00		     ; |
++	StA $7D			     ; |
	TYA : StA !PropFlipFrequency ;/

	RtS

..SetTransition
	LdA #$05
	StA !PropStatus
	Inc : StA !PropStatusTimer
	LdA #$01
	StA !PropFlipFrequency
	Dec
;	StA !disable_spin_jump
	StA $140D
	LdA !PropPlayerFrame
	AND #$03
	StA !PropPlayerFrame
	RtS

.04to02:
	LdA #$80
	StA !mask_15

	LdA $7D
	BMi ++
	LdA $77
	AND #$04
	BEq +
++	Jmp ClearStatus
+
	LdA $14
	AND #$03
	BNE ..DontUpdateFrame

	LdA !PropPlayerFrame	;\
	Inc			; |
	Cmp #$04		; |
	BCC ..DontReset		; | 
	LdA #$00		; |
..DontReset			; |
	StA !PropPlayerFrame	;/
..DontUpdateFrame

	LdA $7D
	Cmp #$17
	BCC +
	Dec #6
	Bra ++
+	LdA #$02
	StA !PropStatus
	LdA !PropPlayerFrame
	AND #$03
	ORA #$04
	StA !PropPlayerFrame
	LdA #$17
++	StA $7D

	RtS

;<  Checks if the player is on ground or pressing down and acts according to them  >;

CheckDownAndGround:
.CheckStomp
	LdA $7D
	BPl .CheckGround
	LdA #$80
	StA !PropStatus
	LdA #$00
	StA !PropStatusTimer
;	StA !disable_spin_jump
	StA $140D|!base2
	PlA : PlA
	RtS

.CheckGround
	LdA $77			;\
	AND #$04		; | If not touching ground...
	BEq .CheckDown		;/  ...check if pressing down. Otherwise reset status.

.ResetStatus
	LdA #$00		;\
	StA !PropStatus		;/  Set powerup status to 0.
	PlA : PlA		;\
	RtS			;/  Return to SMW code.

.CheckDown
	LdA !PropStatus
	Cmp #$01
	BNE ..DoCheckDown
	LdA !PropStatusTimer
	Cmp !FlightTime-$14
	BCS ..Rtrn0

..DoCheckDown
	LdA $15
	AND #$04
	BEq ..Rtrn0

	StA !PropStatus		;>  Set powerup status to 4. A always contains #$04 due to
				;   the previous check.
	LdA #$0A		;\
	StA $7D			;/  Set player's Y speed to #$04.
	LdA !PropPlayerFrame
	AND #$FB
	ORA #$08
	StA !PropPlayerFrame
	LdA #$06		;\
	StA !PropStatusTimer	;/  
	LdA !SpinAtkSFX
	StA !SpinAtkSFXPort
	PlA : PlA		;\
..Rtrn0	RtS			;/  Return to SMW code.

;<  A check to the frame counter with the status timer that can be used for anything  >;
;> Input:
; ¬ A should contain a limit for !PropStatusTimer where it will lower the frame counter's
;   frequency if !PropStatusTimer is under that value.

CheckPlayerSpinFrequency:
	StA $00
	LdA !PropStatusTimer : TAY ;>  Load status timer into Y.
	LdA $14			   ;\
	CpY $00			   ; |
	BCS +			   ; | Only update player's image every 2 or 4 frames,
	AND #$03		   ; | depending of the timer's value.
	Bra ++			   ; |
+	AND #$01		   ;/
++	RtS			   ;>  Return.

;<  Clears player's powerup status and timer  >;

ClearStatus:
	LdA #$00
	StA !PropStatus
	StA !PropStatusTimer
	StA !mask_15
	LdA #$07		;\
	StA !PropFlipFrequency	;/  Set propeller frequency to be every 8 frames.
	StZ $140D|!base2	;>  No more "spin jumping".
	RtS