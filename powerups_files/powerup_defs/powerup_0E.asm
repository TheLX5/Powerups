;;;;;;;;;;;;;;;;;;;
;; Propeller
;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  ____________________________  ;
; /			       \ ;
;|  PROPELLER MUSHROOM DEFINES  |;
; \____________________________/ ;
;				 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; /	    \ ;
;|  Defines  |;
; \	    / ;

;<  Numerical adresses  >;

!PropSuit_tile	       = $0E
!PropSuit_prop	       = $04
!PropSuit_dynamic_tile = $42

!FlightTime  = #$48		;>  How much frames the player should be flying before
				;   starting to descend.
!FlightSpeed = #$CF 		;>  Y speed the player will have when flying.
!FlightSFX   = #$36		;>  Sound effect number used for the flying sound effect.
!FrndSpinSFX = #$04		;>  Sound effect number used for the spinning sound effect.
!SpinAtkSFX  = #$37		;>  Sound effect number used for the spinning sound effect.

;<  RAM adresses  >;

!PropStatus        = !flags		  ;>  RAM adress used to index the powerup status.
!PropStatusTimer   = !timer		  ;>  Timer used to indicate how much frames the
					  ;   player flies.
!PropPlayerFrame   = !misc		  ;>  RAM adress used to indicate the player frame
					  ;   when flying and descending.
!PropTileFlags	   = !extra_tile_flag	  ;>  RAM adress containing the propeller tile
					  ;   flags. Check !extra_tile_flags in
					  ;   powerup_defs.asm.
!PropTileAngle	   = !power_ram+0	  ;>  RAM adress used to create the real propeller
					  ;   tile's frame.
!PropTileFrame	   = !extra_tile_frame	  ;>  RAM adress used as the propeller tile's frame.
!PropTileYOffset   = !extra_tile_offset_y ;>  RAM adress used to set how many pixels the
					  ;   propeller tile is goin to be from the
					  ;   player vertically.
!PropTileXOffset   = !extra_tile_offset_x ;>  RAM adress used to set how many pixels the
					  ;   propeller tile is goin to be from the
					  ;   player horizontally.
!PropFlipFrequency = !power_ram+1	  ;>  RAM adress used to indicate the frequency
					  ;   where the propeller tile's frame changes.
!FlightSFXPort	   = $1DFC|!base2	  ;>  Port used by the flying sound effect.
!FrndSpinSFXPort   = $1DFC|!base2	  ;>  Port used by the spinning sound effect.
!SpinAtkSFXPort    = $1DFC|!base2	  ;>  Port used by the spin attack sound effect.

%powerup_number(PropSuit,0E,Smoke)	;Mandatory macro to get the powerup number.
	;Input: %powerup_number(<define>,<hex_num>)
	;<define>: Prefix of your defines in this file, must be unique.
	;<hex_num>: Actual powerup number, it must not repeat from another powerup
	;     	    And it must not exceed the value in !max_powerup.
	;Output: Various defines
	;!<define>_powerup_num: Complete define name, you could use it for something else
	;		        Its value would be <hex_num>
	;!powerup_<hex_num>: Complete define name, used within the patch in some tables
	;	             Its value will be !<define>_powerup_num
	;And a few other defines with prefix !powerup_<num>_ instead of !<define>_ such as:
	;!powerup_<num>_tile, !powerup_<num>_prop