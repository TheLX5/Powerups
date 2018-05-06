;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Bits:
; 0 = Ice block has a coin inside.
; 1 = Can't be frozen by Iceball.
; 2-3 = Ice block size
; 4 = Don't interact with the Iceball at all.
; 5 = Disappears in a puff of smoke
; 6 = Move X pos by 8px to the left
; 7 = Move Y pos by 16px upwards
; Bit order is:
; 76543210
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Ice block size format:
; 00 = 16x16 ice block
; 01 = 16x32 ice block
; 10 = 32x16 ice block
; 11 = 32x32 ice block
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

iceball_custom_sprites:
	db %00010010,%00010010,%00010010,%00010010	; custom sprites 0-3
	db %00010010,%00010010,%00010010,%00010010	; custom sprites 4-7
	db %00010010,%00010010,%00010010,%00010010	; custom sprites 8-B
	db %00010010,%00010010,%00010010,%00010010	; custom sprites C-F
	db %00000010,%00000010,%00000000,%00000000	; custom sprites 10-13
	db %00000000,%00000000,%00000000,%00000000	; custom sprites 14-17
	db %00000000,%00000000,%00000000,%00000000	; custom sprites 18-1B
	db %00000000,%00000000,%00000000,%00000000	; custom sprites 1C-1F
	db %00000000,%00000000,%00000000,%00000000	; custom sprites 20-23
	db %00000000,%00000000,%00000000,%00000000	; custom sprites 24-27
	db %00000000,%00000000,%00000000,%00000000	; custom sprites 28-2B
	db %00000000,%00000000,%00000000,%00000000	; custom sprites 2C-2F
	db %00000000,%00000000,%00000000,%00000000	; custom sprites 30-33
	db %00000000,%00000000,%00000000,%00000000	; custom sprites 34-37
	db %00000000,%00000000,%00000000,%00000000	; custom sprites 38-3B
	db %00000000,%00000000,%00000000,%00000000	; custom sprites 3C-3F
	db %00000000,%00000000,%00000000,%00000000	; custom sprites 40-43
	db %00000000,%00000000,%00000000,%00000000	; custom sprites 44-47
	db %00000000,%00000000,%00000000,%00000000	; custom sprites 48-4B
	db %00000000,%00000000,%00000000,%00000000	; custom sprites 4C-4F
	db %00000000,%00000000,%00000000,%00000000	; custom sprites 50-53
	db %00000000,%00000000,%00000000,%00000000	; custom sprites 54-57
	db %00000000,%00000000,%00000000,%00000000	; custom sprites 58-5B
	db %00000000,%00000000,%00000000,%00000000	; custom sprites 5C-5F
	db %00000000,%00000000,%00000000,%00000000	; custom sprites 60-63
	db %00000000,%00000000,%00000000,%00000000	; custom sprites 64-67
	db %00000000,%00000000,%00000000,%00000000	; custom sprites 68-6B
	db %00000000,%00000000,%00000000,%00000000	; custom sprites 6C-6F
	db %00000000,%00000000,%00000000,%00000000	; custom sprites 70-73
	db %00000000,%00000000,%00000000,%00000000	; custom sprites 74-77
	db %00000000,%00000000,%00000000,%00000000	; custom sprites 78-7B
	db %00000000,%00000000,%00000000,%00000000	; custom sprites 7C-7F
	db %00000000,%00000000,%00000000,%00000000	; custom sprites 80-83
	db %00000000,%00000000,%00000000,%00000000	; custom sprites 84-87
	db %00000000,%00000000,%00000000,%00000000	; custom sprites 88-8B
	db %00000000,%00000000,%00000000,%00000000	; custom sprites 8C-8F
	db %00000000,%00000000,%00000000,%00000000	; custom sprites 90-93
	db %00000000,%00000000,%00000000,%00000000	; custom sprites 94-97
	db %00000000,%00000000,%00000000,%00000000	; custom sprites 98-9B
	db %00000000,%00000000,%00000000,%00000000	; custom sprites 9C-9F
	db %00000000,%00000000,%00000000,%00000000	; custom sprites A0-A3
	db %00000000,%00000000,%00000000,%00000000	; custom sprites A4-A7
	db %00000000,%00000000,%00000000,%00000000	; custom sprites A8-AB
	db %00000000,%00000000,%00000000,%00000000	; custom sprites AC-AF
	db %00000000,%00000000,%00000000,%00000000	; custom sprites B0-B3
	db %00000000,%00000000,%00000000,%00000000	; custom sprites B4-B7
	db %00000000,%00000000,%00000000,%00000000	; custom sprites B8-BB
	db %00000000,%00000000,%00000000,%00000000	; custom sprites BC-BF
	db %00000000,%00000000,%00000000,%00000000	; custom sprites C0-C3
	db %00000000,%00000000,%00000000,%00000000	; custom sprites C4-C7
	db %00000000,%00000000,%00000000,%00000000	; custom sprites C8-CB
	db %00000000,%00000000,%00000000,%00000000	; custom sprites CC-CF
	db %00000000,%00000000,%00000000,%00000000	; custom sprites D0-D3
	db %00000000,%00000000,%00000000,%00000000	; custom sprites D4-D7
	db %00000000,%00000000,%00000000,%00000000	; custom sprites D8-DB
	db %00000000,%00000000,%00000000,%00000000	; custom sprites DC-DF
	db %00000000,%00000000,%00000000,%00000000	; custom sprites E0-E3
	db %00000000,%00000000,%00000000,%00000000	; custom sprites E4-E7
	db %00000000,%00000000,%00000000,%00000000	; custom sprites E8-EB
	db %00000000,%00000000,%00000000,%00000000	; custom sprites EC-EF
	db %00000000,%00000000,%00000000,%00000000	; custom sprites F0-F3
	db %00000000,%00000000,%00000000,%00000000	; custom sprites F4-F7
	db %00000000,%00000000,%00000000,%00000000	; custom sprites F8-FB
	db %00000000,%00000000,%00000000,%00000000	; custom sprites FC-FF

iceball_normal_sprites:
;.00 Green Koopa no shell
	db %00000001
;.01 Red Koopa no shell
	db %00000001
;.02 Blue Koopa no shell
	db %00000001
;.03 Yellow Koopa no shell
	db %00000001
;.04 Green Koopa
	db %10000101
;.05 Red Koopa
	db %10000101
;.06 Blue Koopa
	db %10000101
;.07 Yellow Koopa
	db %10000101
;.08 Green Koopa flying left
	db %10000101
;.09 Green bouncing Koopa
	db %10000101
;.0A Red vertical flying Koopa
	db %10000101
;.0B Red horizontal flying Koopa
	db %10000101
;.0C Yellow Koopa with wings
	db %10000101
;.0D Bob-omb
	db %00000001
;.0E Keyhole
	db %00011011
;.0F Goomba
	db %00000000
;.10 Bouncing Goomba with wings
	db %00000001
;.11 Buzzy Beetle
	db %00000001
;.12 Unused
	db %00000000
;.13 Spiny
	db %00000001
;.14 Spiny falling
	db %00000001
;.15 Fish, horizontal
	db %00000001
;.16 Fish, vertical
	db %00000001
;.17 Fish, created from generator
	db %00000001
;.18 Surface jumping fish
	db %00000001
;.19 Display text from level Message Box #1
	db %00011011
;.1A Classic Piranha Plant
	db %10000101
;.1B Bouncing football in place
	db %00000001
;.1C Bullet Bill
	db %00000001
;.1D Hopping flame
	db %00100000
;.1E Lakitu
	db %10000101
;.1F Magikoopa
	db %10000101
;.20 Magikoopa's magic
	db %00011111
;.21 Moving coin
	db %11011111
;.22 Green vertical net Koopa
	db %10000101
;.23 Red vertical net Koopa
	db %10000101
;.24 Green horizontal net Koopa
	db %10000101
;.25 Red horizontal net Koopa
	db %10000101
;.26 Thwomp
	db %00001111
;.27 Thwimp
	db %00001111
;.28 Big Boo
	db %00011111
;.29 Koopa Kid
	db %00011111
;.2A Upside down Piranha Plant
	db %10000101
;.2B Sumo Brother's fire lightning
	db %01000010
;.2C Yoshi egg
	db %11011111
;.2D Baby green Yoshi
	db %11011111
;.2E Spike Top
	db %00000001
;.2F Portable spring board
	db %11111111
;.30 Dry Bones, throws bones
	db %00000010
;.31 Bony Beetle
	db %00000010
;.32 Dry Bones, stay on ledge
	db %00000010
;.33 Fireball
	db %00100000
;.34 Boss fireball
	db %00100000
;.35 Green Yoshi
	db %00011111
;.36 Unused
	db %00000000
;.37 Boo
	db %00000010
;.38 Eerie
	db %00000010
;.39 Eerie, wave motion
	db %00000010
;.3A Urchin, fixed
	db %00001101
;.3B Urchin, wall detect
	db %00001101
;.3C Urchin, wall follow
	db %00001101
;.3D Rip Van Fish
	db %00000001
;.3E POW
	db %11111111
;.3F Para-Goomba
	db %00000001
;.40 Para-Bomb
	db %00000001
;.41 Dolphin, horizontal
	db %00111111
;.42 Dolphin2, horizontal
	db %00111111
;.43 Dolphin, vertical
	db %00111111
;.44 Torpedo Ted
	db %01001001
;.45 Directional coins
	db %11011111
;.46 Diggin' Chuck
	db %01001101
;.47 Swimming/Jumping fish
	db %00000001
;.48 Diggin' Chuck's rock
	db %00000001
;.49 Growing/shrinking pipe end
	db %00111111
;.4A Goal Point Question Sphere
	db %11111111
;.4B Pipe dwelling Lakitu
	db %10000101
;.4C Exploding Block
	db %00000010
;.4D Ground dwelling Monty Mole
	db %00000001
;.4E Ledge dwelling Monty Mole
	db %00000001
;.4F Jumping Piranha Plant
	db %00000001
;.50 Jumping Piranha Plant, spit fire
	db %00000001
;.51 Ninji
	db %00000001
;.52 Moving ledge hole in ghost house
	db %00111111
;.53 Throw block sprite
	db %00011111
;.54 Climbing net door
	db %00011111
;.55 Checkerboard platform, horizontal
	db %00111111
;.56 Flying rock platform, horizontal
	db %00111111
;.57 Checkerboard platform, vertical
	db %00111111
;.58 Flying rock platform, vertical
	db %00111111
;.59 Turn block bridge, horizontal and vertical
	db %00111111
;.5A Turn block bridge, horizontal
	db %00111111
;.5B Brown platform floating in water
	db %00111111
;.5C Checkerboard platform that falls
	db %00111111
;.5D Orange platform floating in water
	db %00111111
;.5E Orange platform, goes on forever
	db %00111111
;.5F Brown platform on a chain
	db %00111111
;.60 Flat green switch palace switch
	db %00111111
;.61 Floating skulls
	db %00111111
;.62 Brown platform, line-guided
	db %00111111
;.63 Checker/brown platform, line-guided
	db %00111111
;.64 Rope mechanism, line-guided
	db %00011111
;.65 Chainsaw, line-guided
	db %00001110
;.66 Upside down chainsaw, line-guided
	db %00001110
;.67 Grinder, line-guided
	db %00001111
;.68 Fuzz ball, line-guided
	db %00000010
;.69 Unused
	db %00000000
;.6A Coin game cloud
	db %11011111
;.6B Spring board, left wall
	db %00111111
;.6C Spring board, right wall
	db %00111111
;.6D Invisible solid block
	db %00111111
;.6E Dino Rhino
	db %01001101
;.6F Dino Torch
	db %00000001
;.70 Pokey
	db %00000010
;.71 Super Koopa, red cape
	db %00001001
;.72 Super Koopa, yellow cape
	db %00001001
;.73 Super Koopa, feather
	db %00001001
;.74 Mushroom
	db %11111111
;.75 Flower
	db %11111111
;.76 Star
	db %11111111
;.77 Feather
	db %11111111
;.78 1-Up
	db %11111111
;.79 Growing Vine
	db %00111111
;.7A Firework
	db %00011111
;.7B Goal Point
	db %00111111
;.7C Princess Peach
	db %00011111
;.7D Balloon
	db %11111111
;.7E Flying Red coin
	db %11111111
;.7F Flying yellow 1-Up
	db %11111111
;.80 Key
	db %11011111
;.81 Changing item from translucent block
	db %11111111
;.82 Bonus game sprite
	db %00111111
;.83 Left flying question block
	db %00111111
;.84 Flying question block
	db %00111111
;.85 Unused (Pretty sure)
	db %00011111
;.86 Wiggler
	db %00000010
;.87 Lakitu's cloud
	db %00111111
;.88 Unused (Winged cage sprite)
	db %00111111
;.89 Layer 3 smash
	db %00111111
;.8A Bird from Yoshi's house
	db %00111111
;.8B Puff of smoke from Yoshi's house
	db %00011111
;.8C Fireplace smoke/exit from side screen
	db %00111111
;.8D Ghost house exit sign and door
	db %00111111
;.8E Invisible "Warp Hole" blocks
	db %00111111
;.8F Scale platforms
	db %00111111
;.90 Large green gas bubble
	db %00011111
;.91 Chargin' Chuck
	db %01001101
;.92 Splittin' Chuck
	db %01001101
;.93 Bouncin' Chuck
	db %01001101
;.94 Whistlin' Chuck
	db %01001101
;.95 Clapin' Chuck
	db %01001101
;.96 Unused (Chargin' Chuck clone)
	db %01001101
;.97 Puntin' Chuck
	db %01001101
;.98 Pitchin' Chuck
	db %01001101
;.99 Volcano Lotus
	db %01001001
;.9A Sumo Brother
	db %01000100
;.9B Hammer Brother
	db %00001101
;.9C Flying blocks for Hammer Brother
	db %00111111
;.9D Bubble with sprite
	db %11111111
;.9E Ball and Chain
	db %00011111
;.9F Banzai Bill
	db %00000010
;.A0 Activates Bowser scene
	db %00111111
;.A1 Bowser's bowling ball
	db %00001111
;.A2 MechaKoopa
	db %01001101
;.A3 Grey platform on chain
	db %00111111
;.A4 Floating Spike ball
	db %00000111
;.A5 Fuzzball/Sparky, ground-guided
	db %00100000
;.A6 HotHead, ground-guided
	db %00000010
;.A7 Iggy's ball
	db %00000010
;.A8 Blargg
	db %00000010
;.A9 Reznor
	db %00010010
;.AA Fishbone
	db %00000010
;.AB Rex
	db %10000101
;.AC Wooden Spike, moving down and up
	db %00111111
;.AD Wooden Spike, moving up/down first
	db %00111111
;.AE Fishin' Boo
	db %00000010
;.AF Boo Block
	db %00000010
;.B0 Reflecting stream of Boo Buddies
	db %00000010
;.B1 Creating/Eating block
	db %00111111
;.B2 Falling Spike
	db %00000010
;.B3 Bowser statue fireball
	db %00100000
;.B4 Grinder, non-line-guided
	db %00000010
;.B5 Sinking fireball used in boss battles
	db %00100000
;.B6 Reflecting fireball
	db %00100000
;.B7 Carrot Top lift, upper right
	db %00111111
;.B8 Carrot Top lift, upper left
	db %00111111
;.B9 Info Box
	db %00111111
;.BA Timed lift
	db %00111111
;.BB Grey moving castle block
	db %00111111
;.BC Bowser statue
	db %00000010
;.BD Sliding Koopa without a shell
	db %00000001
;.BE Swooper bat
	db %00000001
;.BF Mega Mole
	db %00001101
;.C0 Grey platform on lava
	db %00011111
;.C1 Flying grey turnblocks
	db %00111111
;.C2 Blurp fish
	db %00000001
;.C3 Porcu-Puffer fish
	db %00001101
;.C4 Grey platform that falls
	db %00111011
;.C5 Big Boo Boss
	db %00011111
;.C6 Dark room with spot light
	db %00111111
;.C7 Invisible mushroom
	db %00111111
;.C8 Light switch block for dark room
	db %00111111
;.C9 Bullet Bill shooter
	db %00011111
;.CA Torpedo Launcher
	db %00011111
;.CB Eerie, generator
	db %00011111
;.CC Para-Goomba, generator
	db %00011111
;.CD Para-Bomb, generator
	db %00011111
;.CE Para-Bomb and Para-Goomba, generator
	db %00011111
;.CF Dolphin, left, generator
	db %00011111
;.D0 Dolphin, right, generator
	db %00011111
;.D1 Jumping fish, generator
	db %00011111
;.D2 Turn off generator 2 (sprite E5)
	db %00011111
;.D3 Super Koopa, generator
	db %00011111
;.D4 Bubble with Goomba and Bob-omb, generator
	db %00011111
;.D5 Bullet Bill, generator
	db %00011111
;.D6 Bullet Bill surrounded, generator
	db %00011111
;.D7 Bullet Bill diagonal, generator
	db %00011111
;.D8 Bowser statue fire breath, generator
	db %00011111
;.D9 Turn off standard generators
	db %00011111
;.DA Green Koopa shell
	db %00000001
;.DB Red Koopa shell
	db %00000001
;.DC Blue Koopa shell
	db %00000001
;.DD Yellow Koopa shell
	db %00000001
;.DE Group of 5 eeries, wave motion
	db %00000000
;.DF Green bouncing Koopa shell
	db %00000000
;.E0 3 platforms on chains
	db %00010011
;.E1 Ghost ceiling
	db %00010011
;.E2 Boo Buddies, counter clockwise
	db %00010011
;.E3 Boo Buddies, clockwise
	db %00010011
;.E4 Swooper bat ceiling
	db %00010011
;.E5 Reappearing ghost, generator 2
	db %00010011
;.E6 Candle flame background
	db %00010011
;.E7 Auto-Scroll, Unused?
	db %00010011
;.E8 Auto-Scroll
	db %00010011
;.E9 Layer 2 Smash
	db %00010011
;.EA Layer 2 Scroll
	db %00010011
;.EB Unused
	db %00010011
;.EC Unused
	db %00010011
;.ED Layer 2 Falls
	db %00010011
;.EE Unused
	db %00010011
;.EF Layer 2 Scroll
	db %00010011
;.F0 Unused
	db %00010011
;.F1 Unused
	db %00010011
;.F2 Layer 2 On/Off Switch controlled
	db %00010011
;.F3 Auto-Scroll level
	db %00010011
;.F4 Fast BG scroll
	db %00010011
;.F5 Layer 2 sink/rise
	db %00010011
;.F6 Unused, fatal error
	db %00010011
;.F7 Unused, fatal error
	db %00010011
;.F8 Unused, fatal error
	db %00010011
;.F9 Unused, fatal error
	db %00010011
;.FA Unused, fatal error
	db %00010011
;.FB Unused, fatal error
	db %00010011
;.FC Unused, fatal error
	db %00010011
;.FD Unused, fatal error
	db %00010011
;.FE Unused, fatal error
	db %00010011
;.FF Unused, fatal error
	db %00010011