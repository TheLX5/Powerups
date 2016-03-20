org $01A1D4|!base3			;Edit "!14C8=09 or 0B" of the Throw Block
!a	JML	IceBlockRt

org $018672|!base3			;Repoint throw block state 08 to freespace
	dw $FFBF

org $01FFBF|!base3			;Ice block state #$08
!a	JSL	IceBlock	
	RTS 	

org $0199F8|!base3			;New shatter effect made with minor extended sprites.
!a	JML	NewEffect