org $029FC2|!base3			;main code of iceball
	autoclean JML iceball
	NOP
org $02A1EF|!base3			;Edit the fireball graphic routine.
	autoclean JML iceball_edit

org $029FFF|!base3			;make iceball to be erased when bouncing twice
	autoclean JSL go_to_main