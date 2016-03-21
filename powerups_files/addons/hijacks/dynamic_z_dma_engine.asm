if !dynamic_z = 1
org $00A304|!base3
!a	JML	dynamic_z_code		;Handle those DMA routines using Dynamic Z
	RTS	
	NOP	#2
endif