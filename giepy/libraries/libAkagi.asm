;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; libAkagi.asm
;; ------------
;;
;;   Original source auther : Akaginite
;;   Modification for GIEPY : 6646
;;
;;   * Please don't send questions to Akaginite about this library.
;;     I don't want to trouble her.
;;
;;
;;   This file includes these routines.
;;
;;   - GetDrawInfo
;;         ... Get sprite's OAM Information subroutine.
;;     [args]
;;         X  : Sprite index
;;     [return]
;;         ?
;;
;;   - SubOffScreen
;;         ... 
;;     [args]
;;         X  : Sprite index
;;         Y  : (type << 1)  (e.g. X1=$02, X2=$04 ... X7=$0E)
;;     [return]
;;         ?
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; GetDrawInfo - Optimized version
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

GetDrawInfo:	LDA   !14E0,x
		XBA
		LDA   !E4,x
		REP   #$20
		SEC
		SBC   $1A
		STA   $00
		CLC
		ADC.w #$0040
		CMP.w #$0180
		SEP   #$20
		LDA   $01
		BEQ   +
		LDA   #$01
+		STA   !15A0,x
		TDC
		ROL   A
		STA   !15C4,x
		BNE   .Invalid

		LDA   !14D4,x
		XBA
		LDA   !1662,x
		AND   #$20
		BEQ   .CheckOnce
.CheckTwice	LDA   !D8,x
		REP   #$21
		ADC.w #$001C
		SEC
		SBC   $1C
		SEP   #$20
		LDA   !14D4,x
		XBA
		BEQ   .CheckOnce
		LDA   #$02
.CheckOnce	STA   !186C,x
		LDA   !D8,x
		REP   #$21
		ADC.w #$000C
		SEC
		SBC   $1C
		SEP   #$21
		SBC   #$0C
		STA   $01
		XBA
		BEQ   .OnScreenY
		INC   !186C,x
.OnScreenY	LDY   !15EA,x
		RTL

.Invalid	REP   #$20	;
		PLY		;
		PLA		;   discard JSR return address 
		PLA		;   get 16bits return address
		PHB		;\  set 24bits address
		PHA		;/
		SEP   #$20	;
		RTL



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; SubOffScreen - Optimized version
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Argument
; Y : type (#$00=X0, #$02=X1 ... #$0E=X7)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SubOffScreen:
		PHB
		PHK
		PLB
		LDA   !15A0,x
		ORA   !186C,x
		BEQ   .Return2
		LDA   !167A,x
		AND   #$04
		BNE   .Return2
		LDA   $5B
		LSR   A
		BCS   .VerticalLevel
		LDA   !D8,x
		ADC   #$50
		LDA   !14D4,x
		ADC   #$00
		CMP   #$02
		BCS   .EraseSprite
		LDA   !14E0,x
		XBA
		LDA   !E4,x
		REP   #$21
		ADC   .AddTable,y
		SEC
		SBC   $1A
		CMP   .CmpTable,y
.Common		SEP   #$20
		BCC   .Return2
.EraseSprite	LDA   !14C8,x
		CMP   #$08
		BCC   .KillSprite
		LDY   !161A,x
		CPY   #$FF
		BEQ   .KillSprite
if !sa1
		PHX
		TYX
		LDA   !1938,x
		AND   #$FE
		STA   !1938,x
		PLX
else
		LDA   !1938,y
		AND   #$FE
		STA   !1938,y
endif
.KillSprite	STZ   !14C8,x
.Return2	
		PLB
		RTL

.VerticalLevel	LDA   $13
		LSR   A
		BCS   .CheckY
		LDA   !14E0,x
		XBA
		LDA   !E4,x
		REP   #$21
		ADC.w #$0040
		CMP.w #$0280
		BRA   .Common
.CheckY		LDA   !14D4,x
		XBA
		LDA   !D8,x
		REP   #$20
		SBC   $1C
		CLC
		ADC.w #$0070
		CMP.w #$01D0
		BRA   .Common

.AddTable	dw $0040,$0040,$0010,$0070
		dw $0090,$0050,$0080,$FFC0
.CmpTable	dw $0170,$01E0,$01B0,$01D0
		dw $0230,$01B0,$0220,$0160
