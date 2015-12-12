.org 8000h
main:
	mov p1, #00h				; signal initialized low
	mov dph, #90h				; init msb of pointer
	mov dpl, #00h				; init lsb of pointer
mainloop:
	movx a, @dptr				; load data value into acc
	mov r0, a					; set up r0
innerloop:
	djnz r0, innerloop			; loop for certain # of cycles
	cpl p1.0					; toggle the signal
	sjmp mainloop				; reload and do it again
