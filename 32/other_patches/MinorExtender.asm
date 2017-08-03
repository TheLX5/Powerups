incsrc ../powerup_defs.asm

if !SA1
	sa1rom
endif

	!17F0	= $17F0|!base2		;$0DF5
	!17FC	= $17FC|!base2		;$0E09
	!1814	= $1814|!base2		;$0E1D
	!1808	= $1808|!base2		;$0E31
	!18EA	= $18EA|!base2		;$0E45
	!1820	= $1820|!base2		;$0E59
	!182C	= $182C|!base2		;$0E6D
	!1838	= $1838|!base2		;$0E81
	!1844	= $1844|!base2		;$0E95
	!1850	= $1850|!base2		;$0EA9

;; OAM Slots

org $02D51E|!base3
	db $50,$54,$58,$5C,$60,$64,$68,$6C
	db $70,$74,$78,$7C

;; Remap OAM Table calls

org $028C6E|!base3
	LDY $D51E,x
org $028CFF|!base3
	LDY $D51E,x
org $028D8B|!base3
	LDY $D51E,x
org $028E20|!base3
	LDY $D51E,x
org $028E94|!base3
	LDY $D51E,x
org $028EE1|!base3
	LDY $D51E,x
org $028F4D|!base3
	LDY $D51E,x
org $028FDD|!base3
	LDY $D51E,x

;; Increase loops and indexes

org $00FDA9|!base3
	LDY #$0B
org $01F7DD|!base3
	LDX #$0B
org $01F7EC|!base3
	LDA #$0B
org $0284DD|!base3
	LDY #$0B
org $0285BA|!base3		;Number of invincibility sparkles
	LDY #$0B
org $0285E4|!base3
	LDY #$0B
org $028668|!base3
	LDX #$0B
org $028677|!base3
	LDA #$0B
org $028B67|!base3
	LDX #$0B
org $028BC0|!base3
	LDY #$0B
org $028C30|!base3
	LDY #$0B
org $0298DA|!base3
	LDY #$0B
org $0298E9|!base3
	LDA #$0B
org $02C0F0|!base3
	LDY #$0B
org $02C0FF|!base3
	LDA #$0B
org $039020|!base3
	LDY #$0B
org $03902F|!base3
	LDA #$0B
org $03AD69|!base3
	LDY #$0B

;; Remap 17F0

org $00FDAB|!base3
	LDA !17F0,y
org $00FDEA|!base3
	STA !17F0,y
org $01F7DF|!base3
	LDA !17F0,x
org $01F7F6|!base3
	STA !17F0,x
org $0284DF|!base3
	LDA !17F0,y
org $028507|!base3
	STA !17F0,y
org $0285BC|!base3
	LDA !17F0,y
org $0285C7|!base3
	STA !17F0,y
org $0285E6|!base3
	LDA !17F0,y
org $0285F5|!base3
	STA !17F0,y
org $02866A|!base3
	LDA !17F0,x
org $028686|!base3
	STA !17F0,x
org $028B69|!base3
	LDA !17F0,x
org $028BC2|!base3
	LDA !17F0,y
org $028BCD|!base3
	STA !17F0,y
org $028C32|!base3
	LDA !17F0,y
org $028C3D|!base3
	STA !17F0,y
org $028C66|!base3
	STZ !17F0,x
org $028D62|!base3
	STZ !17F0,x
org $028E02|!base3
	LDA !17F0,x
org $028E4F|!base3
	LDA !17F0,x
org $028E76|!base3
	STZ !17F0,x
org $028EFE|!base3
	LDA !17F0,x
org $028F87|!base3
	STZ !17F0,x
org $0298DC|!base3
	LDA !17F0,y
org $0298F3|!base3
	STA !17F0,y
org $02C0F2|!base3
	LDA !17F0,y
org $02C108|!base3
	STA !17F0,y
org $039022|!base3
	LDA !17F0,y
org $039039|!base3
	STA !17F0,y
org $03AD6B|!base3
	LDA !17F0,y
org $03AD76|!base3
	STA !17F0,y

;; Remap 17FC

org $00FDCF|!base3
	STA !17FC,y
org $01F808|!base3
	STA !17FC,x
org $0284F2|!base3
	STA !17FC,y
org $0285D1|!base3
	STA !17FC,y
org $02861E|!base3
	STA !17FC,y
org $02869F|!base3
	STA !17FC,x
org $028BDA|!base3
	STA !17FC,y
org $028C4F|!base3
	LDA !17FC,x
org $028C52|!base3
	STA !17FC,y
org $028C80|!base3
	LDA !17FC,x
org $028CD7|!base3
	LDA !17FC,x
org $028D16|!base3
	LDA !17FC,x
org $028D72|!base3
	INC !17FC,x
org $028D9E|!base3
	LDA !17FC,x
org $028E1D|!base3
	DEC !17FC,x
org $028E34|!base3
	LDA !17FC,x
org $028E97|!base3
	LDA !17FC,x
org $028EF1|!base3
	LDA !17FC,x
org $028F59|!base3
	LDA !17FC,x
org $028FB4|!base3
	ADC !17FC,x
org $028FB7|!base3
	STA !17FC,x
org $028FCA|!base3
	LDA !17FC,x
org $029918|!base3
	STA !17FC,y
org $02B5E5|!base3
	ADC !17FC,x
org $02B5E8|!base3
	STA !17FC,x
org $02C118|!base3
	STA !17FC,y
org $039049|!base3
	STA !17FC,y
org $03AD9D|!base3
	STA !17FC,y

;; Remap 1814

org $00FDDA|!base3
	STA !1814,y
org $01F80D|!base3
	STA !1814,x
org $028626|!base3
	STA !1814,y
org $0286A6|!base3
	STA !1814,x
org $028BE2|!base3
	STA !1814,y
org $028C55|!base3
	LDA !1814,x
org $028C58|!base3
	STA !1814,y
org $028C88|!base3
	LDA !1814,x
org $028CDF|!base3
	LDA !1814,x
org $028FBB|!base3
	ADC !1814,x
org $028FBE|!base3
	STA !1814,x
org $028FD2|!base3
	LDA !1814,x
org $03904F|!base3
	STA !1814,y
org $03ADA5|!base3
	STA !1814,y

;; Remap 1808

org $00FDE0|!base3
	STA !1808,y
org $01F7FF|!base3
	STA !1808,x
org $0284FA|!base3
	STA !1808,y
org $0285D6|!base3
	STA !1808,y
org $028608|!base3
	STA !1808,y
org $02868F|!base3
	STA !1808,x
org $028BFC|!base3
	STA !1808,y
org $028C43|!base3
	LDA !1808,x
org $028C46|!base3
	STA !1808,y
org $028C71|!base3
	LDA !1808,x
org $028CC8|!base3
	LDA !1808,x
org $028D02|!base3
	LDA !1808,x
org $028D4F|!base3
	LDA !1808,x
org $028D8E|!base3
	LDA !1808,x
org $028E23|!base3
	LDA !1808,x
org $028EA4|!base3
	LDA !1808,x
org $028EE4|!base3
	LDA !1808,x
org $028F2F|!base3
	LDA !1808,x
org $028F50|!base3
	LDA !1808,x
org $028F9E|!base3
	ADC !1808,x
org $028FA1|!base3
	STA !1808,x
org $028FE0|!base3
	LDA !1808,x
org $02990F|!base3
	STA !1808,y
org $02C110|!base3
	STA !1808,y
org $03903E|!base3
	STA !1808,y
org $03AD8B|!base3
	STA !1808,y

;; Remap 18EA

org $00FDE5|!base3
	STA !18EA,y
org $028502|!base3
	STA !18EA,y
org $028610|!base3
	STA !18EA,y
org $028696|!base3
	STA !18EA,x
org $028C04|!base3
	STA !18EA,y
org $028C49|!base3
	LDA !18EA,x
org $028C4C|!base3
	STA !18EA,y
org $028C79|!base3
	LDA !18EA,x
org $028CD0|!base3
	LDA !18EA,x
org $028D0A|!base3
	LDA !18EA,x
org $028D54|!base3
	LDA !18EA,x
org $028F34|!base3
	LDA !18EA,x
org $028FA5|!base3
	ADC !18EA,x
org $028FA8|!base3
	STA !18EA,x
org $028FE8|!base3
	LDA !18EA,x
org $039044|!base3
	STA !18EA,y
org $03AD93|!base3
	STA !18EA,y

;; Remap 1820

org $01F813|!base3
	STA !1820,x
org $0285CC|!base3
	STA !1820,y
org $0285FA|!base3
	STA !1820,y
org $0286AC|!base3
	STA !1820,x
org $028C40|!base3
	STA !1820,y
org $028E8E|!base3
	INC !1820,x
org $028E91|!base3
	INC !1820,x
org $028F4A|!base3
	INC !1820,x
org $028FAD|!base3
	LDA !1820,x
org $028FC7|!base3
	INC !1820,x
org $02B5C8|!base3
	LDA !1820,x
org $02B5D7|!base3
	LDA !1820,x
org $03ADAA|!base3
	STA !1820,y

;; Remap 182C

org $01F819|!base3
	STA !182C,x
org $0286B2|!base3
	STA !182C,x
org $028BF3|!base3
	STA !182C,y
org $028C14|!base3
	LDA !182C,x
org $028C23|!base3
	STA !182C,x
org $028D29|!base3
	LDA !182C,x
org $028DF1|!base3
	INC !182C,x
org $028DF8|!base3
	DEC !182C,x
org $028DFB|!base3
	DEC !182C,x
org $028DFE|!base3
	LDA !182C,x
org $028E0C|!base3
	STA !182C,x
org $028E13|!base3
	STA !182C,x
org $028F97|!base3
	LDA !182C,x
org $02C122|!base3
	STA !182C,y
org $039059|!base3
	STA !182C,y

;; Remap 1838

org $02B5D0
	ADC !1838,x
org $02B5D3
	STA !1838,x

;; Remap 1844

; !1844

; Seems unused in the original game. It must be remapped in other patches.

;; Remap 1850

org $00FDEF|!base3
	STA !1850,y
org $01F825|!base3
	STA !1850,x
org $02850C|!base3
	STA !1850,y
org $0285DB|!base3
	STA !1850,y
org $02862B|!base3
	STA !1850,y
org $0286B7|!base3
	STA !1850,x
org $028BD2|!base3
	STA !1850,y
org $028C0F|!base3
	LDA !1850,x
org $028C5D|!base3
	STA !1850,y
org $028C61|!base3
	DEC !1850,x
org $028C9A|!base3
	LDA !1850,x
org $028CFA|!base3
	DEC !1850,x
org $028D5B|!base3
	LDA !1850,x
org $028D75|!base3
	LDA !1850,x
org $028DAB|!base3
	LDA !1850,x
org $028DD3|!base3
	INC !1850,x
org $028DDF|!base3
	LDA !1850,x
org $028DE4|!base3
	DEC !1850,x
org $028DE7|!base3
	LDA !1850,x
org $028DEE|!base3
	LDA !1850,x
org $028E16|!base3
	LDA !1850,x
org $028E48|!base3
	LDA !1850,x
org $028E58|!base3
	LDA !1850,x
org $028E7E|!base3
	DEC !1850,x
org $028E81|!base3
	LDA !1850,x
org $028EB6|!base3
	LDA !1850,x
org $028ED2|!base3
	LDA !1850,x
org $028EDE|!base3
	DEC !1850,x
org $028F02|!base3
	LDA !1850,x
org $028F3B|!base3
	LDA !1850,x
org $028F44|!base3
	DEC !1850,x
org $028F66|!base3
	LDA !1850,x
org $028FFD|!base3
	LDA !1850,x
org $02991E|!base3
	STA !1850,y
org $02C11D|!base3
	STA !1850,y
org $039054|!base3
	STA !1850,y
org $03ADAF|!base3
	STA !1850,y