ClearStatusRAM:
	LdA #$02
	StA $1DF9|!base2

	LdA $19
	Cmp #!PropSuit_powerup_num
	BNE .Rtrn0

	LdA #$80
	StA !PropStatus
	LdA #$00
	StA !PropStatusTimer
	StA !mask_15
	StA $140D|!base2

.Rtrn0	RtL