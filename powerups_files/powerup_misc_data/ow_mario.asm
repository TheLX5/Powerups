;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Easier OW Mario Change
;
;what this patch does is easliy edit OW Mario's palette and tiles
;(the Mario you control and walk around with)
;without making a bunch of hex edits.
;
;I also included Yoshi stuff, so you can edit his tiles and palette (meh)
;
;No freespace required
;
;
;by Ladida
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Everything below this can be edited
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
!mario          = $24   ;palette value for Mario
!mariox         = $64   ;palette value for X-flipped Mario
 
 
;below are the palette values of the 'in water' tiles
 
!waterp         = $24   ;palette value for water tile
!waterpx        = $64   ;palette value for x-flipped water tile
 
 
;below are Yoshi's tiles and palette
 
!yoship         = $22   ;palette value for Blue Yoshi
!yoshipx        = $62   ;palette value for x-flipped Blue Yoshi
 
 
;the above values must be in YXPPCCCT format
 
 
 
;all values below are Mario's tiles. each 4 entries are one frame, and each are one 8x8 tile. 
;the entries go like this: 1st = top left 8x8 tile, 2nd = bottom left 8x8 tile,
;3rd = top right 8x8 tile, 4th = bottom right 8x8 tile.
 
!walkl2ul       = $06
!walkl2dl       = $16   ;this is the frame for walking left
!walkl2ur       = $07
!walkl2dr       = $17
 
!walklul        = $08
!walkldl        = $18   ;this is the frame for walking left, but not moving legs
!walklur        = $09
!walkldr        = $19
 
!walkr2ul       = $06
!walkr2dl       = $16   ;this is the frame for walking right
!walkr2ur       = $07
!walkr2dr       = $17
 
!walkrul        = $08
!walkrdl        = $18   ;this is the frame for walking right, but not moving legs
!walkrur        = $09
!walkrdr        = $19
 
!standful       = $0A
!standfdl       = $1A   ;this frame is facing towards the screen
!standfur       = $0B
!standfdr       = $1B
 
!standf2ul      = $0C
!standf2dl      = $1C   ;this frame is walking towards the screen
!standf2ur      = $0D
!standf2dr      = $1D
 
!walkbul        = $0E
!walkbdl        = $1E   ;this frame is facing away from the screen
!walkbur        = $0F
!walkbdr        = $1F
 
!walkb2ul       = $4C
!walkb2dl       = $5C   ;this frame is walking away from the screen
!walkb2ur       = $4D
!walkb2dr       = $5D
 
!enterul        = $24
!enterdl        = $34   ;this frame is when you enter a level
!enterur        = $25
!enterdr        = $35
 
!climbul        = $46
!climbdl        = $56   ;this frame is when you are climbing a ladder/vine/whatever
!climbur        = $47
!climbdr        = $57
 
!climb2ul       = $46
!climb2dl       = $56   ;this frame is when you are climbing a ladder/vine/whatever (can use for 2nd frame)
!climb2ur       = $47
!climb2dr       = $57
 
!ridelul        = $64
!rideldl        = $74   ;this frame is riding Yoshi, left
!ridelur        = $65
!rideldr        = $75
 
!riderul        = $64
!riderdl        = $74   ;this frame is riding Yoshi, right
!riderur        = $65
!riderdr        = $75
 
!ridebul        = $66
!ridebdl        = $76   ;this frame is riding Yoshi, going away from the screen
!ridebur        = $67
!ridebdr        = $77
 
!rideful        = $0A
!ridefdl        = $1A   ;this frame is riding Yoshi, facing the screen
!ridefur        = $0B
!ridefdr        = $1B
 
!wadel2ul       = $06
!wadel2ur       = $07   ;this is the frame for swimming left, 2nd frame
 
!wadelul        = $08
!wadelur        = $09   ;this is the frame for swimming left
 
!wader2ul       = $06
!wader2ur       = $07   ;this is the frame for swimming right, 2nd frame
 
!waderul        = $08
!waderur        = $09   ;this is the frame for swimming right
 
!wadeful        = $0A
!wadefur        = $0B   ;this frame is swimming towards the screen, stationary
 
!wadef2ul       = $0C
!wadef2ur       = $0D   ;this frame is swimming towards the screen, 2nd frame
 
!wadebul        = $0E
!wadebur        = $0F   ;this frame is swimming away from the screen
 
!wadeb2ul       = $4C
!wadeb2ur       = $4D   ;this frame is swimming away from the screen, 2nd frame
 
 
 
;below are the tile numbers for the 'in water' tiles
 
!water          = $38   ;this is the 'in water' tile
!water2         = $39   ;this is the second frame of the 'in water' tile
 
 
 
;below are the tile numbers for Yoshi
 
!yoshiful       = $2E
!yoshifdl       = $3E   ;this frame is Yoshi facing towards the screen
!yoshifur       = $2F
!yoshifdr       = $3F
 
!yoshif2ul      = $2E
!yoshif2dl      = $3E   ;this frame is Yoshi facing towards the screen, 2nd frame
!yoshif2ur      = $2F
!yoshif2dr      = $3F
 
!yoshibul       = $2E
!yoshibdl       = $3E   ;this frame is Yoshi walking away from the screen
!yoshibur       = $2F
!yoshibdr       = $3F
 
!yoshib2ul      = $2E
!yoshib2dl      = $3E   ;this frame is Yoshi walking away from the screen, 2nd frame
!yoshib2ur      = $2F
!yoshib2dr      = $3F
 
!yoshil2ul      = $40
!yoshil2dl      = $50   ;this frame is Yoshi walking left
!yoshil2ur      = $41
!yoshil2dr      = $51
 
!yoshilul       = $42
!yoshildl       = $52   ;this frame is Yoshi walking left, not moving legs
!yoshilur       = $43
!yoshildr       = $53
 
!yoshir2ul      = $40
!yoshir2dl      = $50   ;this frame is Yoshi walking right
!yoshir2ur      = $41
!yoshir2dr      = $51
 
!yoshirul       = $42
!yoshirdl       = $52   ;this frame is Yoshi walking right, not moving legs
!yoshirur       = $43
!yoshirdr       = $53
 
 
 
;!!!!!!!!!!!!!!!WARNING!!!!!!!!!!!!!!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;Actual data below, I advise you
;not touch it unless you know what
;you are doing.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;!!!!!!!!!!!!!!!GNINRAW!!!!!!!!!!!!!!
 
 
 
header
lorom
 
org $0487CB
 
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Walking away from screen
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
db !walkbul,!mario,!walkbur,!mario,!walkbdl,!mario,!walkbdr,!mario
db !walkb2ul,!mario,!walkb2ur,!mario,!walkb2dl,!mario,!walkb2dr,!mario
db !walkbul,!mario,!walkbur,!mario,!walkbdl,!mario,!walkbdr,!mario
db !walkb2ul,!mario,!walkb2ur,!mario,!walkb2dr,!mariox,!walkb2dl,!mariox
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Walking towards screen/ standing
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
db !standful,!mario,!standfur,!mario,!standfdl,!mario,!standfdr,!mario
db !standf2ul,!mario,!standf2ur,!mario,!standf2dl,!mario,!standf2dr,!mario
db !standful,!mario,!standfur,!mario,!standfdl,!mario,!standfdr,!mario
db !standf2ul,!mario,!standf2ur,!mario,!standf2dr,!mariox,!standf2dl,!mariox
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Walking left
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
db !walklul,!mario,!walklur,!mario,!walkldl,!mario,!walkldr,!mario
db !walkl2ul,!mario,!walkl2ur,!mario,!walkl2dl,!mario,!walkl2dr,!mario
db !walklul,!mario,!walklur,!mario,!walkldl,!mario,!walkldr,!mario
db !walkl2ul,!mario,!walkl2ur,!mario,!walkl2dl,!mario,!walkl2dr,!mario
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Walking right
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
db !walkrur,!mariox,!walkrul,!mariox,!walkrdr,!mariox,!walkrdl,!mariox
db !walkr2ur,!mariox,!walkr2ul,!mariox,!walkr2dr,!mariox,!walkr2dl,!mariox
db !walkrur,!mariox,!walkrul,!mariox,!walkrdr,!mariox,!walkrdl,!mariox
db !walkr2ur,!mariox,!walkr2ul,!mariox,!walkr2dr,!mariox,!walkr2dl,!mariox
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Swimming away from screen
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
db !wadebul,!mario,!wadebur,!mario,!water,!waterp,!water,!waterpx
db !wadeb2ul,!mario,!wadeb2ur,!mario,!water2,!waterp,!water2,!waterpx
db !wadebul,!mario,!wadebur,!mario,!water,!waterp,!water,!waterpx
db !wadeb2ul,!mario,!wadeb2ur,!mario,!water2,!waterp,!water2,!waterpx
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Swimming towards screen/ wading
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
db !wadeful,!mario,!wadefur,!mario,!water,!waterp,!water,!waterpx
db !wadef2ul,!mario,!wadef2ur,!mario,!water2,!waterp,!water2,!waterpx
db !wadeful,!mario,!wadefur,!mario,!water,!waterp,!water,!waterpx
db !wadef2ul,!mario,!wadef2ur,!mario,!water2,!waterp,!water2,!waterpx
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Swimming left
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
db !wadelul,!mario,!wadelur,!mario,!water,!waterp,!water,!waterpx
db !wadel2ul,!mario,!wadel2ur,!mario,!water2,!waterp,!water2,!waterpx
db !wadelul,!mario,!wadelur,!mario,!water,!waterp,!water,!waterpx
db !wadel2ul,!mario,!wadel2ur,!mario,!water2,!waterp,!water2,!waterpx
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Swimming right
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
db !waderur,!mariox,!waderul,!mariox,!water,!waterp,!water,!waterpx
db !wader2ur,!mariox,!wader2ul,!mariox,!water2,!waterp,!water2,!waterpx
db !waderur,!mariox,!waderul,!mariox,!water,!waterp,!water,!waterpx
db !wader2ur,!mariox,!wader2ul,!mariox,!water2,!waterp,!water2,!waterpx
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Entering level
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
db !enterul,!mario,!enterur,!mario,!enterdl,!mario,!enterdr,!mario
db !enterul,!mario,!enterur,!mario,!enterdl,!mario,!enterdr,!mario
db !enterul,!mario,!enterur,!mario,!enterdl,!mario,!enterdr,!mario
db !enterul,!mario,!enterur,!mario,!enterdl,!mario,!enterdr,!mario
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Entering level, in water
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
db !enterul,!mario,!enterur,!mario,!water,!waterp,!water,!waterpx
db !enterul,!mario,!enterur,!mario,!water,!waterp,!water,!waterpx
db !enterul,!mario,!enterur,!mario,!water,!waterp,!water,!waterpx
db !enterul,!mario,!enterur,!mario,!water,!waterp,!water,!waterpx
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Climbing
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
db !climbul,!mario,!climbur,!mario,!climbdl,!mario,!climbdr,!mario
db !climb2ur,!mariox,!climb2ul,!mariox,!climb2dr,!mariox,!climb2dl,!mariox
db !climbul,!mario,!climbur,!mario,!climbdl,!mario,!climbdr,!mario
db !climb2ur,!mariox,!climb2ul,!mariox,!climb2dr,!mariox,!climb2dl,!mariox
db !climbul,!mario,!climbur,!mario,!climbdl,!mario,!climbdr,!mario
db !climb2ur,!mariox,!climb2ul,!mariox,!climb2dr,!mariox,!climb2dl,!mariox
db !climbul,!mario,!climbur,!mario,!climbdl,!mario,!climbdr,!mario
db !climb2ur,!mariox,!climb2ul,!mariox,!climb2dr,!mariox,!climb2dl,!mariox
 
 
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;Below are the Yoshi frames and the Mario riding Yoshi frames
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 
 
org $0489DE
 
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Riding Yoshi away from the screen
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
db !ridebul,!mario,!ridebur,!mario,!ridebdl,!mario,!ridebdr,!mario
db !yoshib2ur,!yoshipx,!yoshib2ul,!yoshipx,!yoshib2dr,!yoshipx,!yoshib2dl,!yoshipx
db !ridebul,!mario,!ridebur,!mario,!ridebdl,!mario,!ridebdr,!mario
db !yoshibul,!yoship,!yoshibur,!yoship,!yoshibdl,!yoship,!yoshibdr,!yoship
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Riding Yoshi towards the screen
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
db !yoshif2ur,!yoshipx,!yoshif2ul,!yoshipx,!yoshif2dr,!yoshipx,!yoshif2dl,!yoshipx
db !rideful,!mario,!ridefur,!mario,!ridefdl,!mario,!ridefdr,!mario
db !yoshiful,!yoship,!yoshifur,!yoship,!yoshifdl,!yoship,!yoshifdr,!yoship
db !rideful,!mario,!ridefur,!mario,!ridefdl,!mario,!ridefdr,!mario
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Riding Yoshi to the left
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
db !ridelul,!mario,!ridelur,!mario,!rideldl,!mario,!rideldr,!mario
db !yoshil2ul,!yoship,!yoshil2ur,!yoship,!yoshil2dl,!yoship,!yoshil2dr,!yoship
db !ridelul,!mario,!ridelur,!mario,!rideldl,!mario,!rideldr,!mario
db !yoshilul,!yoship,!yoshilur,!yoship,!yoshildl,!yoship,!yoshildr,!yoship
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Riding Yoshi to the right
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
db !riderur,!mariox,!riderul,!mariox,!riderdr,!mariox,!riderdl,!mariox
db !yoshir2ur,!yoshipx,!yoshir2ul,!yoshipx,!yoshir2dr,!yoshipx,!yoshir2dl,!yoshipx
db !riderur,!mariox,!riderul,!mariox,!riderdr,!mariox,!riderdl,!mariox
db !yoshirur,!yoshipx,!yoshirul,!yoshipx,!yoshirdr,!yoshipx,!yoshirdl,!yoshipx
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Seems to be Riding Yoshi away from screen in Water
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
db !water,!waterp,!water,!waterpx,!ridebul,!mario,!ridebur,!mario
db !ridebdl,!mario,!ridebdr,!mario,$FF,$FF,$FF,$FF
db !water2,!waterp,!water2,!waterpx,!ridebul,!mario,!ridebur,!mario
db !ridebdl,!mario,!ridebdr,!mario,$FF,$FF,$FF,$FF
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Riding Yoshi towards screen in Water
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
db !water,!waterp,!water,!waterpx,!yoshif2ur,!yoshipx,!yoshif2ul,!yoshipx
db !rideful,!mario,!ridefur,!mario,!ridefdl,!mario,!ridefdr,!mario
db !water2,!waterp,!water2,!waterpx,!yoshiful,!yoship,!yoshifur,!yoship
db !rideful,!mario,!ridefur,!mario,!ridefdl,!mario,!ridefdr,!mario
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Riding Yoshi to the left in Water
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
db !water,!waterp,!water,!waterpx,!ridelul,!mario,!ridelur,!mario
db !rideldl,!mario,!rideldr,!mario,!yoshil2ul,!yoship,!yoshil2ur,!yoship
db !water2,!waterp,!water2,!waterpx,!ridelul,!mario,!ridelur,!mario
db !rideldl,!mario,!rideldr,!mario,!yoshilul,!yoship,!yoshilur,!yoship
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Riding Yoshi to the right in Water
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
db !water,!waterp,!water,!waterpx,!riderur,!mariox,!riderul,!mariox
db !riderdr,!mariox,!riderdl,!mariox,!yoshir2ur,!yoshipx,!yoshir2ul,!yoshipx
db !water2,!waterp,!water2,!waterpx,!riderur,!mariox,!riderul,!mariox
db !riderdr,!mariox,!riderdl,!mariox,!yoshirur,!yoshipx,!yoshirul,!yoshipx
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Entering a level on Yoshi
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
db !yoshif2ur,!yoshipx,!yoshif2ul,!yoshipx,!yoshif2dr,!yoshipx,!yoshif2dl,!yoshipx
db !enterul,!mario,!enterur,!mario,!enterdl,!mario,!enterdr,!mario
db !yoshiful,!yoship,!yoshifur,!yoship,!yoshifdl,!yoship,!yoshifdr,!yoship
db !enterul,!mario,!enterur,!mario,!enterdl,!mario,!enterdr,!mario
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Entering a level on Yoshi, in Water
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
db !water,!waterp,!water,!waterpx,!yoshif2ur,!yoshipx,!yoshif2ul,!yoshipx
db !enterul,!mario,!enterur,!mario,!enterdl,!mario,!enterdr,!mario
db !water2,!waterp,!water2,!waterpx,!yoshiful,!yoship,!yoshifur,!yoship
db !enterul,!mario,!enterur,!mario,!enterdl,!mario,!enterdr,!mario
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Climbing with Yoshi
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
db !ridebul,!mario,!ridebur,!mario,!ridebdl,!mario,!ridebdr,!mario
db !yoshib2ur,!yoshipx,!yoshib2ul,!yoshipx,!yoshib2dr,!yoshipx,!yoshib2dl,!yoshipx
db !ridebul,!mario,!ridebur,!mario,!ridebdl,!mario,!ridebdr,!mario
db !yoshibul,!yoship,!yoshibur,!yoship,!yoshibdl,!yoship,!yoshibdr,!yoship
db !ridebul,!mario,!ridebur,!mario,!ridebdl,!mario,!ridebdr,!mario
db !yoshib2ur,!yoshipx,!yoshib2ul,!yoshipx,!yoshib2dr,!yoshipx,!yoshib2dl,!yoshipx
db !ridebul,!mario,!ridebur,!mario,!ridebdl,!mario,!ridebdr,!mario
db !yoshibul,!yoship,!yoshibur,!yoship,!yoshibdl,!yoship,!yoshibdr,!yoship
 
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;END OF EXTREMELY LONG AND BORING STUFF THAT I HAD TO DISASSEMBLE AND COMMENT D:
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;