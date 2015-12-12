.org 00h
	ljmp main
	
.org 0bh
TOISR:
	lcall makestep
	lcall dolaser
	reti
	
.org 100h
main:
	lcall initclock
	lcall circle
loop:
	;;mov dptr, #0FE15h		; Check the line status register to
	;;movx a, @dptr			; see if a byte has been received.
	;;anl a, #01h
	;;jz loop

	;;mov dptr, #0FE10h		; REad in a byte from the buffer reg
	;;movx a, @dptr
	
	lcall getchr
	mov b, a
	lcall sndchr
	mov P1, b				; and display in on the lights
	mov a, b				; move back to acc
	cjne a, #30h, next1		; circle
	lcall circle
	sjmp loop
next1:
	cjne a, #31h, next2		; tiefighter
	lcall tiefighter
	sjmp loop
next2:
	cjne a, #32h, next3		; onefour
	lcall onefour
	sjmp loop
next3:
	clr c
	subb a, #61h			; lower case 'a'
	mov r3, a				; set rotation
	sjmp loop
	
circle:
	mov r0, #96h			; X position high byte
	mov r1, #00h			; X position low byte
	mov r2, #04h			; X step high byte
	mov r3, #00h			; X step low byte
	mov r4, #56h			; Y position high byte
	mov r5, #00h			; Y position low byte
	mov r6, #04h			; Y step high byte
	mov r7, #00h			; Y step low byte
	ret
	
tiefighter:
	mov r0, #56h			; X position high byte
	mov r1, #00h			; X position low byte
	mov r2, #02h			; X step high byte
	mov r3, #00h			; X step low byte
	mov r4, #56h			; Y position high byte
	mov r5, #00h			; Y position low byte
	mov r6, #06h			; Y step high byte
	mov r7, #00h			; Y step low byte
	ret

onefour:
	mov r0, #56h			; X position high byte
	mov r1, #00h			; X position low byte
	mov r2, #02h			; X step high byte
	mov r3, #00h			; X step low byte
	mov r4, #56h			; Y position high byte
	mov r5, #00h			; Y position low byte
	mov r6, #08h			; Y step high byte
	mov r7, #00h			; Y step low byte
	ret
	
makestep:
	clr c
	mov a, r1				; put x position low byte in acc
	addc a, r3				; add the step low byte
	mov r1, a				; update the x position low byte
	mov a, r0				; put x position high byte in acc
	addc a, r2				; add the step high byte (with c)
	mov r0, a				; update the x position high byte

	clr c
	mov a, r5				; put y position low byte in acc
	addc a, r7				; add the step low byte
	mov r5, a				; update the y position low byte
	mov a, r4				; put y position high byte in acc
	addc a, r6				; add the step high byte (with c)
	mov r4, a				; update the y position high byte
	ret
	
dolaser:
	mov a, r0				; move msb of x position into acc
	mov dptr, #sinetable	; point dptr to sine table
	movc a, @a+dptr			; move real x value into acc
	mov dptr, #0FE18h		; point dptr to lazerdillo x-coord
	movx @dptr, a			; move mirror
	
	mov a, r4				; move msb of y position into acc
	mov dptr, #sinetable	; point dptr to sine table
	movc a, @a+dptr			; mov real y value into acc
	mov dptr, #0FE1Ah		; point dptr to lazerdillo y-coord
	movx @dptr, a			; move mirror
	ret

initclock:
	mov tmod, #22h			;; timer 0 in mode 2
	mov ie, #82h			; enable timer 0 interrupts
	mov th0, #04Ch			; set timer reset number
	mov th1, #0FDh			;; set timer for 9600 PC communication
	setb tr0				; start timer 0
	setb tr1				; start timer 1
	mov scon, #50h			; set serial control reg for 8 bits
	ret

getchr:
	jnb ri, getchr		; wait till character received
	mov a, sbuf		; get character and put it in the accumulator
	anl a, #7fh		; mask off 8th bit
	clr ri			; clear serial "receive status" flag
	ret

sndchr:
	clr ie.7
	clr scon.1		; clear the ti complete flag
	mov sbuf, a		; move a character from the acc to the sbuf
	txloop:
		jnb scon.1, txloop	; wait till chr is sent
	setb ie.7
	ret

sinetable:
	.db 040h, 041h, 043h, 044h, 046h, 047h, 049h, 04Ah
	.db 04Ch, 04Eh, 04Fh, 051h, 052h, 054h, 055h, 057h
	.db 058h, 059h, 05Bh, 05Ch, 05Eh, 05Fh, 060h, 062h
	.db 063h, 064h, 066h, 067h, 068h, 069h, 06Ah, 06Ch
	.db 06Dh, 06Eh, 06Fh, 070h, 071h, 072h, 073h, 074h
	.db 075h, 076h, 076h, 077h, 078h, 079h, 079h, 07Ah
	.db 07Bh, 07Bh, 07Ch, 07Ch, 07Dh, 07Dh, 07Eh, 07Eh
	.db 07Eh, 07Fh, 07Fh, 07Fh, 07Fh, 07Fh, 07Fh, 07Fh
	.db 07Fh, 07Fh, 07Fh, 07Fh, 07Fh, 07Fh, 07Fh, 07Fh
	.db 07Eh, 07Eh, 07Eh, 07Dh, 07Dh, 07Ch, 07Ch, 07Bh
	.db 07Bh, 07Ah, 079h, 079h, 078h, 077h, 076h, 076h
	.db 075h, 074h, 073h, 072h, 071h, 070h, 06Fh, 06Eh
	.db 06Dh, 06Ch, 06Ah, 069h, 068h, 067h, 066h, 064h
	.db 063h, 062h, 060h, 05Fh, 05Eh, 05Ch, 05Bh, 059h
	.db 058h, 057h, 055h, 054h, 052h, 051h, 04Fh, 04Eh
	.db 04Ch, 04Ah, 049h, 047h, 046h, 044h, 043h, 041h
	.db 040h, 03Eh, 03Ch, 03Bh, 039h, 038h, 036h, 035h
	.db 033h, 031h, 030h, 02Eh, 02Dh, 02Bh, 02Ah, 028h
	.db 027h, 026h, 024h, 023h, 021h, 020h, 01Fh, 01Dh
	.db 01Ch, 01Bh, 019h, 018h, 017h, 016h, 015h, 013h
	.db 012h, 011h, 010h, 00Fh, 00Eh, 00Dh, 00Ch, 00Bh
	.db 00Ah, 009h, 009h, 008h, 007h, 006h, 006h, 005h
	.db 004h, 004h, 003h, 003h, 002h, 002h, 001h, 001h
	.db 001h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
	.db 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
	.db 001h, 001h, 001h, 002h, 002h, 003h, 003h, 004h
	.db 004h, 005h, 006h, 006h, 007h, 008h, 009h, 009h
	.db 00Ah, 00Bh, 00Ch, 00Dh, 00Eh, 00Fh, 010h, 011h
	.db 012h, 013h, 015h, 016h, 017h, 018h, 019h, 01Bh
	.db 01Ch, 01Dh, 01Fh, 020h, 021h, 023h, 024h, 026h
	.db 027h, 028h, 02Ah, 02Bh, 02Dh, 02Eh, 030h, 031h
	.db 033h, 035h, 036h, 038h, 039h, 03Bh, 03Ch, 03Eh
