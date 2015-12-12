.org 8000h
ljmp main

.org 8030h
main:
	lcall init
courseloop:
	jnb	p1.0, fineloop		; loop until we're in striking zone
	mov r2, #10h			; choose coarse incrementing value
	lcall adder				; increment our guess
	lcall makefreq			; send our guess to the 8254 chip
	lcall wait				; delay for a quarter of a second
	lcall wait
	sjmp courseloop
fineloop:
	jb p1.0, doneloop		; loop until lamp is ON
	mov r2, #02h			; choose fine incrementing value
	lcall adder				; increment our guess
	lcall makefreq			; send our guess to the 8254 chip
	lcall wait				; delay for a quarter of a second
	lcall wait
	sjmp fineloop
doneloop:
	sjmp doneloop			; block forever
	
;============================================================
; init command: writes control byte to 8254 chip, then sets the
; 	dptr to point to clock 0 on the 8252 chip.  It also
;	initializes r0 and r1, which hold the low and high byte,
;	respectively, of our current guess.
;=============================================================
init:
	setb p1.0				; allows us to read bit w/o issues
	mov dph, #0feh			; load dptr with FF03 (control)
	mov dpl, #03h
	mov a, #76h				; control byte for 16 bit clock
	movx @dptr, a			; write byte to 8254 chip
	mov dpl, #01h			; set dptr to point to clock 1 reg
	mov r1, #00h			; high byte of guess is 0
	mov r0, #0C8h			; low byte of guess is 200
	ret	

;==========================================================
; makefreq command: sends the low byte and then the high byte
; 	of the value we want to put into the clock 0 reg of the
;	8254 chip.  Note that dptr has the value #FF00h, thanks
;	to the init command.
;============================================================
makefreq:
	mov a, r0
	movx @dptr, a			; write low byte to clock 0 reg
	mov a, r1
	movx @dptr, a			; write high byte to clock 0 reg
	ret

;===========================================================
; adder command: increments the 16 bit number (r1 is the
; 	high byte, r0 is the low byte) by the value in r2
;===========================================================
adder:
	clr c
	mov a, r0
	add a, r2			; accumulator now holds r0+r2
	mov r0, a			; r0 is now incremented by value in r2
	mov a, r1
	addc a, #00h		; add the carry to r1 (in the acc)
	mov r1, a			; put back in r1
	ret

;==========================================================
; wait command - blocks for a quarter of a second.  This is
;	so that we don't guess too quickly.  If we wanted to run
;	another program concurrently, we could use interrupts,
;	but that is not implemented here.
;==========================================================
wait:
	mov a, #0ffh		; load a to highest value
	mov b, #0ffh		; load b to highest value
loop:
	djnz b, loop		; decrement b
	mov b, #0FFh		; set b high again after it hits 0
	djnz acc, loop		; decrement once each time b hits 0
	ret
