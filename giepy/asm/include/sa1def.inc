@include
;-------------------------------------------------------------------------------
; Addressing map defines for Vitor's SA-1 patch
;-------------------------------------------------------------------------------
!__sa1def_inc ?= 0
if 0 == !__sa1def_inc
!__sa1def_inc := 1

incsrc "common.inc"
incsrc "macros.inc"
incsrc "config.inc"
incsrc "inschk.inc"

;-----------------------------
; sa-1 defines
;-----------------------------
!sa1	:= !false	;\ default isn't sa-1
!sa_1	 = !sa1		;/

!base1 := $0000		; base adr 1 : WRAM 0
!base2 := $0000		; base adr 2 : WRAM 0

; base bank define
!bankA := $7e0000	; base bank 1 : WRAM
!bankB := $800000	; base bank 2 : FastMode

!map	?= 1		; if map mode isn't defined, 
			; set LoRom

if 0 == !map
	if $23 == read1($00ffd5)
		%putdebug("Type check in asm : SA-1")
		!map = 3
		sa1rom
	elseif $25 == read1($00ffd5)
		%putdebug("Type check in asm : ExLoRom")
		!map = 4
		exlorom
	else
		%putdebug("Type check in asm : LoRom")
		!map = 1
		lorom
	endif
endif


if 3 == !map	; sa-1 rom
	%putdebug("MAP MODE : SA-1 ROM")
	; sa-1 detection
	!sa1	:= !true	;\ detect sa-1

	; base adr define
	!base1 = $3000		; base adr 1 : BW-RAM
	!base2 = $6000		; base adr 2 : IW-RAM

	; base bank define
	!bankA = $400000	; base adr 1 : SRAM
	!bankB = $000000	; base adr 2 : disable fastrom
else
	%putdebug("ADDRESS MODE : LoROM or ExLoROM")
endif

!SA1	 = !sa1
!Base1 = !base1
!Base2 = !base2
!dp    = !base1
!addr  = !base2
!BankA = !bankA
!BankB = !bankB

;-----------------------------
; extra bytes defines
;-----------------------------
!EXTRA_BYTES_EXT := !false
if !false == !OmitInsCheck
	if $42 == read1($0ef30f)
		%putdebug("EXTRA BYTES : ON")
		!EXTRA_BYTES_EXT := !true
	else
		%putdebug("EXTRA BYTES : OFF")
	endif
endif


;-------------------------------------------------
; Define memory address
;   based on sprite tool / pixi
;-------------------------------------------------
%define_sprite_table(extra_bits, !_extra_bits, !_extra_bits_sa1)
%define_sprite_table(7FAB10, !_extra_bits, !_extra_bits_sa1)
%define_sprite_table(new_code_flag, !_new_code_flag, !_new_code_flag_sa1)
%define_sprite_table(7FAB1C, !_new_code_flag, !_new_code_flag_sa1)
%define_sprite_table(extra_prop_1, !_extra_prop_1, !_extra_prop_1_sa1)
%define_sprite_table(7FAB28, !_extra_prop_1, !_extra_prop_1_sa1)
%define_sprite_table(extra_prop_2, !_extra_prop_2, !_extra_prop_2_sa1)
%define_sprite_table(7FAB34, !_extra_prop_2, !_extra_prop_2_sa1)
%define_sprite_table(new_sprite_num, !_new_sprite_num, !_new_sprite_num_sa1)
%define_sprite_table(7FAB9E, !_new_sprite_num, !_new_sprite_num_sa1)
if !true == !EXTRA_BYTES_EXT
	%define_sprite_table(extra_byte_1, !_extra_byte_1, !_extra_byte_1_sa1)
	%define_sprite_table(7FAB40, !_extra_byte_1, !_extra_byte_1_sa1)
	%define_sprite_table(extra_byte_2, !_extra_byte_2, !_extra_byte_2_sa1)
	%define_sprite_table(7FAB4C, !_extra_byte_2, !_extra_byte_2_sa1)
	%define_sprite_table(extra_byte_3, !_extra_byte_3, !_extra_byte_3_sa1)
	%define_sprite_table(7FAB58, !_extra_byte_3, !_extra_byte_3_sa1)
	%define_sprite_table(extra_byte_4, !_extra_byte_4, !_extra_byte_4_sa1)
	%define_sprite_table(7FAB64, !_extra_byte_4, !_extra_byte_4_sa1)
endif


; giepy memory address
%define_sprite_table(extra_bits_sh, !_extra_bits_sh, !_extra_bits_sh_sa1)
%define_sprite_table(extra_bits_gen, !_extra_bits_gen, !_extra_bits_gen_sa1)
%define_sprite_table(extra_bits_l1scr, !_extra_bits_l1scr, !_extra_bits_l1scr_sa1)
%define_sprite_table(extra_bits_l2scr, !_extra_bits_l2scr, !_extra_bits_l2scr_sa1)
if !true == !EXTRA_BYTES_EXT
	%define_sprite_table(extra_byte_sh, !_extra_byte_sh, !_extra_byte_sh_sa1)
	%define_sprite_table(extra_byte_gen, !_extra_byte_gen, !_extra_byte_scr_sa1)
	%define_sprite_table(extra_byte_scr, !_extra_byte_gen, !_extra_byte_scr_sa1)
endif



;-------------------------------------------------
; Define shooter memory address
;-------------------------------------------------
%define_base2_address(shoot_num, 1783)
%define_base2_address(shoot_y_low, 178b)	: !178B = !178b
%define_base2_address(shoot_y_high, 1793)
%define_base2_address(shoot_x_low, 179b)	: !179B = !179b
%define_base2_address(shoot_x_high, 17a3)	: !17A3 = !17a3
%define_base2_address(shoot_timer, 17ab)	: !17AB = !17ab


;-------------------------------------------------
; Define generator memory address
;-------------------------------------------------
%define_base2_address(gen_num, 18b9)		: !18B9 = !18b9


;-------------------------------------------------
; Define scroller memory address
;-------------------------------------------------
%define_base2_address(scroll_num_l1, 143e)	: !143E = !143e
%define_base2_address(scroll_num_l2, 143f)	: !143F = !143f
%define_base2_address(scroll_layer_bit, 1456)


;-------------------------------------------------
; Define cluster sprite memory address
;-------------------------------------------------
%define_base2_address(cluster_num, 1892)
%define_base2_address(cluster_y_low, 1e02)	: !1E02 = !1e02
%define_base2_address(cluster_y_high, 1e2a)	: !1E2A = !1e2a
%define_base2_address(cluster_x_low, 1e16)	: !1E16 = !1e16
%define_base2_address(cluster_x_high, 1e3e)	: !1E3E = !1e3e


;-------------------------------------------------
; Define extended sprite memory address
;-------------------------------------------------
%define_base2_address(extended_num, 170b)	: !170B = !170b
%define_base2_address(extended_y_low, 1715)
%define_base2_address(extended_y_high, 1729)
%define_base2_address(extended_x_low, 171f)	: !171F = !171f
%define_base2_address(extended_x_high, 1733)
%define_base2_address(extended_y_speed, 173d)	: !173D = !173d
%define_base2_address(extended_x_speed, 1747)
%define_base2_address(extended_table, 1765)
%define_base2_address(extended_timer, 176f)	: !176F = !176f
%define_base2_address(extended_behind, 1779)

;%define_base2_address(, )


;-------------------------------------------------
; Define normal sprite memory address
;-------------------------------------------------
%define_sprite_table(sprite_num, 9e, 3200)		: !9E = !9e
%define_sprite_table(sprite_speed_y, aa, 9e)		: !AA = !aa
%define_sprite_table(sprite_speed_x, b6, b6)		: !B6 = !b6
%define_sprite_table(sprite_misc_c2, c2, d8)		: !C2 = !c2
%define_sprite_table(sprite_y_low, d8, 3216)		: !D8 = !d8
%define_sprite_table(sprite_x_low, e4, 322c)		: !E4 = !e4
%define_sprite_table(sprite_status, 14c8, 3242)		: !14C8 = !14c8
%define_sprite_table(sprite_y_high, 14d4, 3258)		: !14D4 = !14d4
%define_sprite_table(sprite_x_high, 14e0, 326e)		: !14E0 = !14e0
%define_sprite_table(sprite_speed_y_frac, 14ec, 74c8)	: !14EC = !14ec
%define_sprite_table(sprite_speed_x_frac, 14f8, 74de)	: !14F8 = !14f8
%define_sprite_table(sprite_misc_1504, 1504, 74f4)
%define_sprite_table(sprite_misc_1510, 1510, 750a)
%define_sprite_table(sprite_misc_151c, 151c, 3284)	: !151C = !151c
%define_sprite_table(sprite_misc_1528, 1528, 329a)
%define_sprite_table(sprite_misc_1534, 1534, 32b0)
%define_sprite_table(sprite_misc_1540, 1540, 32c6)
%define_sprite_table(sprite_misc_154c, 154c, 32dc)	: !154C = !154c
%define_sprite_table(sprite_misc_1558, 1558, 32f2)
%define_sprite_table(sprite_misc_1564, 1564, 3308)
%define_sprite_table(sprite_misc_1570, 1570, 331e)
%define_sprite_table(sprite_misc_157c, 157c, 3334)	: !157C = !157c
%define_sprite_table(sprite_blocked_status, 1588, 334a)
%define_sprite_table(sprite_misc_1594, 1594, 3360)
%define_sprite_table(sprite_off_screen_horz, 15a0, 3376) : !15A0 = !15a0
%define_sprite_table(sprite_misc_15ac, 15ac, 338c)	: !15AC = !15ac
%define_sprite_table(sprite_slope, 15b8, 7520)		: !15B8 = !15b8
%define_sprite_table(sprite_off_screen, 15c4, 7536)	: !15C4 = !15c4
%define_sprite_table(sprite_being_eaten, 15d0, 754c)	: !15D0 = !15d0
%define_sprite_table(sprite_obj_interact, 15dc, 7562)	: !15DC = !15dc
%define_sprite_table(sprite_oam_index, 15ea, 33a2)	: !15EA = !15ea
%define_sprite_table(sprite_oam_properties, 15f6, 33b8)	: !15F6 = !15f6
%define_sprite_table(sprite_misc_1602, 1602, 33ce)
%define_sprite_table(sprite_misc_160e, 160e, 33e4)	: !160E = !160e
%define_sprite_table(sprite_index_in_level, 161a, 7578)	: !161A = !161a
%define_sprite_table(sprite_misc_1626, 1626, 758e)
%define_sprite_table(sprite_behind_scenery, 1632, 75a4)
%define_sprite_table(sprite_misc_163e, 163e, 33fa)	: !163E = !163e
%define_sprite_table(sprite_in_water, 164a, 75ba)	: !164A = !164a
%define_sprite_table(sprite_tweaker_1656, 1656, 75d0)
%define_sprite_table(sprite_tweaker_1662, 1662, 75ea)
%define_sprite_table(sprite_tweaker_166e, 166e, 7600)	: !166E = !166e
%define_sprite_table(sprite_tweaker_167a, 167a, 7616)	: !167A = !167a
%define_sprite_table(sprite_tweaker_1686, 1686, 762c)
%define_sprite_table(sprite_off_screen_vert, 186c, 7642) : !186C = !186c
%define_sprite_table(sprite_misc_187b, 187b, 3410)	: !187B = !187b
%define_sprite_table(sprite_load_table, 1938, 418a00)
%define_sprite_table(sprite_tweaker_190f, 190f, 7658)	: !190F = !190f
%define_sprite_table(sprite_misc_1fd6, 1fd6, 766e)	: !1FD6 = !1fd6
%define_sprite_table(sprite_cape_disable_time, 1fe2, 7fd6) : !1FE2 = !1fe2

endif
