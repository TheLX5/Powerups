;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This little patch checks if Mario should ride yoshi

fix_yoshi:		
		lda !ride_yoshi_flag
		bne .force_end_code
		lda $72
		beq .force_end_code
		jml $01ED3C|!base3
.force_end_code		
		jml $01ED70|!base3