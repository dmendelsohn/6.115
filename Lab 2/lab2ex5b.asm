.org 8000h
main:
	mov p1, #00h			; signal initialized low
	mov dph, #90h			; init msb of pointer to high clock
mainloop:
	mov dpl, #00h			; point to higher clock
	movx a, @dptr			; load high clock value into acc
	mov r0, a				; and store it in r0
	mov dpl, #01h			; now point to low clock
	movx a, @dptr			; load low clock value into acc
	mov r1, a				; and store it in r1
loop:
	djnz r1, loop			; loop <low clock> times
	mov r1, #0FFh			; reset low clock as high as possible
	djnz r0, loop			; loop <high clock> times
	cpl p1.0				; toggle the signal
	sjmp mainloop			; and do it again
	
;; NOTE: set R0 one higher than you want
