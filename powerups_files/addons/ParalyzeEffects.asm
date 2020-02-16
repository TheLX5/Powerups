;>	Format is:
; ¬ FRAME 1  |   FRAME 2  |   FRAME 3  |   FRAME 4	 >	Frame 1
; ¬ FRAME 2  |   FRAME 3  |   FRAME 4  |   FRAME 1	 >	Frame 2
; ¬ FRAME 3  |   FRAME 4  |   FRAME 1  |   FRAME 2	 >	Frame 3
; ¬ FRAME 4  |   FRAME 1  |   FRAME 2  |   FRAME 3	 >	Frame 4
; -------p pppFF---

!no = $80

;16x16
db $00,$00 : db !no,!no : db !no,!no : db !no,!no
db $00,$00 : db !no,!no : db !no,!no : db !no,!no
db !no,!no : db !no,!no : db !no,!no : db !no,!no
db $00,$00 : db !no,!no : db !no,!no : db !no,!no

;32x32
db !no,!no : db $00,$10 : db $10,$00 : db $10,$10
db $10,$10 : db !no,!no : db $00,$10 : db $00,$00
db $10,$10 : db $00,$00 : db !no,!no : db $10,$00
db $10,$00 : db $00,$10 : db $00,$00 : db !no,!no

;16x32
db $00,$00 : db $00,$10 : db !no,!no : db !no,!no
db $00,$00 : db $00,$10 : db !no,!no : db !no,!no
db !no,!no : db $00,$00 : db !no,!no : db !no,!no
db !no,!no : db $00,$10 : db !no,!no : db !no,!no

;16x32, shifted 16px up
db $00,$F0 : db $00,$00 : db !no,!no : db !no,!no
db $00,$00 : db $00,$F0 : db !no,!no : db !no,!no
db !no,!no : db $00,$F0 : db !no,!no : db !no,!no
db !no,!no : db $00,$00 : db !no,!no : db !no,!no

;32x16
db $00,$00 : db $10,$00 : db !no,!no : db !no,!no
db $00,$00 : db $10,$00 : db !no,!no : db !no,!no
db !no,!no : db $00,$00 : db !no,!no : db !no,!no
db !no,!no : db $10,$00 : db !no,!no : db !no,!no

;48x16
db $00,$00 : db !no,!no : db $20,$00 : db $10,$00
db $10,$00 : db $00,$00 : db !no,!no : db !no,!no
db !no,!no : db $00,$00 : db !no,!no : db $20,$00
db $20,$00 : db $10,$00 : db !no,!no : db !no,!no

;64x16
db $00,$00 : db $10,$00 : db $20,$00 : db !no,!no
db $00,$00 : db $10,$00 : db !no,!no : db $30,$00
db $00,$00 : db !no,!no : db $20,$00 : db $30,$00
db !no,!no : db $10,$00 : db $20,$00 : db $30,$00

;80x16
db $10,$00 : db $20,$00 : db $30,$00 : db $40,$00
db $00,$00 : db $20,$00 : db $30,$00 : db $40,$00
db $10,$00 : db $00,$00 : db $20,$00 : db $40,$00
db $20,$00 : db $30,$00 : db $10,$00 : db $00,$00

;64x64, shifted 4px right
db $FC,$00 : db $1C,$10 : db $0C,$20 : db $2C,$30
db $0C,$00 : db $2C,$10 : db $FC,$20 : db $1C,$30
db $0C,$10 : db $2C,$00 : db $FC,$30 : db $1C,$20
db $FC,$10 : db $1C,$00 : db $0C,$30 : db $2C,$20

;64x64
db $00,$00 : db $20,$10 : db $10,$20 : db $30,$30
db $10,$00 : db $30,$10 : db $00,$20 : db $20,$30
db $10,$10 : db $30,$00 : db $00,$30 : db $20,$20
db $00,$10 : db $20,$00 : db $10,$30 : db $30,$20

;16x16, shifted 8px up & left
db $F8,$F8 : db !no,!no : db !no,!no : db !no,!no
db $F8,$F8 : db !no,!no : db !no,!no : db !no,!no
db !no,!no : db !no,!no : db !no,!no : db !no,!no
db $F8,$F8 : db !no,!no : db !no,!no : db !no,!no