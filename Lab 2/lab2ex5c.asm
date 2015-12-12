.org 00h
ljmp main

.org 00Bh
toggle:
	cpl p1.0				; toggle the signal
	reti					; return to main loop

.org 30h
main:
	mov tmod, #02h			; set timer 0 for auto reload mode 2
	mov dph, #010h			; set data pointer msb
	mov dpl, #00h			; set data pointer lsb
	movx a, @dptr			; load accumulator
	mov th0, acc			; move value to th0
	mov p1, #01h			; initialize signal
	setb TR0				; turn timer 0 on
	mov IE, #082h
	loop:
		sjmp loop
