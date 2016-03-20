; Remap sprite stuff.

org $019B8C|!base3
if !remap_shell_less_koopa = 1
			db $E0,$E2,$E2,$E6,$CC,$86,$4E
else
			db $E0,$E2,$E2,$CE,$E4,$86,$4E
endif

if !remap_little_bubble = 1
	org $029F5B|!base3	;remap bubble sprite to 5up graphic.
		LDA #!little_bubble_tile
endif

if !remap_cheep_cheeps = 1
	org $01B117|!base3	;make cheep cheeps use SP3/SP4
		ORA #!cheep_cheep_page

	org $019C0F|!base3	;remap flopping cheep cheeps
		db !flopping_cheep_tile_1,!flopping_cheep_tile_2
endif

if !remap_hammers = 1
	org $02A2DF|!base3	;remap hammers
		db !hammer_tile_1,!hammer_tile_2,!hammer_tile_2,!hammer_tile_1
		db !hammer_tile_1,!hammer_tile_2,!hammer_tile_2,!hammer_tile_1
	org $02A2E7|!base3
		db !hammer_palette_page+$40,!hammer_palette_page+$40
		db !hammer_palette_page,!hammer_palette_page
		db !hammer_palette_page+$80,!hammer_palette_page+$80
		db !hammer_palette_page+$C0,!hammer_palette_page+$C0
endif

if !remap_pow = 1
	org $01A221|!base3	;remap pow
		db !pow_tile
	org $018466|!base3
		db !blue_pow_yxppccct,!silver_pow_yxppccct
endif

if !remap_squished_koopa = 1
	org $01E729|!base3		;remap squished koopa
		db !squished_koopa_tile
endif

if !remap_sparkles = 1
	org $028ECC|!base3		;remap star sparkle tiles
		db !small_star_tile,!small_star_tile,!medium_star_tile
		db !medium_star_tile,!large_star_tile,!large_star_tile
endif

if !remap_spinjump_star = 1
	org $029C94|!base3		;remap spinjump star
		db !spin_star_tile
endif

; vv -- Remap smoke particles -- vv ;

if !remap_smoke_particles = 1
org $00FBA4|!base3
        db $64,$64,$62,$60,$E8,$EA,$EC,$EA
org $01E985|!base3
        db $64,$64,$62,$60
org $028C6A|!base3
        db $64,$64,$62,$60
org $028D42|!base3
        db $68,$68,$6A,$6A,$6A,$62,$62,$62
        db $64,$64,$64,$64,$64
org $0296D8|!base3
        db $64,$62,$64,$62,$60,$62,$60
org $029922|!base3
        db $64,$62,$64,$62,$62
org $029922|!base3
        db $64,$62,$64,$62,$62
org $029C33|!base3
        db $64,$64,$62,$60,$60,$60,$60,$60
org $02A347|!base3
        db $64,$64,$60,$62
endif