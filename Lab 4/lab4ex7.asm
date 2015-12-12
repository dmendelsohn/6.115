.org 0000h
ljmp main


.org 100h
main:
	lcall init
mainloop:
	lcall getchr
	lcall sndchr
	lcall full_rotate
	sjmp mainloop

;========================================================================
; init - command to set up 8255 output, timer and serial stuff
; 	uses acc, dptr, P3.2, r6, tmod, tcon, th1, scon
;=========================================================================
init:
	mov dptr, #0FE13h			; control reg of 8255
	mov a, #80h					; output on all ports
	movx @dptr, a
	setb P3.2					; disable output for 74C922
	mov r6, #01h				; holds delay variable
	mov tmod, #0A0h		; set time 1 for auto reload - mode 2
	mov tcon, #40h		; run timer 1
	mov th1, #0FDh		; set 9600 baud with xtal=11.059mhz (th1 = 253)
	mov scon, #50h		; set serial control reg for 8 bit data and mode 1
	ret
;==========================================================================
; full_rotate - this command prompts a 24 step full rotation of SpinDude
; 	uses dptr, acc, r7
;==========================================================================	
full_rotate:
	mov r7, #06h				; we need to do 6*4=24 steps
rotate_loop:
	cjne r7, #00h, call_write_four	; as long as r7 more than 0
	sjmp rotate_finish
call_write_four:
	lcall write_four
	dec r7
	mov a, #04h					; 1 second delay
	sjmp rotate_loop
rotate_finish:					; we get here when we've done the 24 steps
	ret
	
;============================================================================
; write_four - this subroutine writes OBlYBr in order to SpinDude
;	uses dptr, acc
;============================================================================
write_four:
	mov a, #40h				; Orange is high
	lcall to_port_A
	lcall delay
	mov a, #20h				; Black is high
	lcall to_port_A
	lcall delay
	mov a, #80h				; Yellow is high
	lcall to_port_A
	lcall delay
	mov a, #10h				; Brown is high
	lcall to_port_A
	lcall delay
	ret

;========================================================================
; to_port_A	- command to push the value in the acc to port A on the 8255
; uses acc, dptr
;=========================================================================
to_port_A:
	mov dptr, #0FE10h			; point dptr to port A on 8255
	movx @dptr, a				; move value in acc to that location
	ret

;==========================================================================
; delay - this command does a certain number of quartersec calls,
;	specified by the value in r6
; uses acc, r0, r1, r2, r6
;==========================================================================
delay:
	mov a, r6					; number of quartersec calls is now in acc
	mov r2, a					; its now in r2
delayloop:
	cjne r2, #00h, delaycont	; jump to delaycont if more cycles
	ret							; ret if no more cycles
delaycont:
	lcall quartersec
	dec r2
	sjmp delayloop

;===========================================================================
; quartersec - this command creates a 0.25 second blocking delay
; uses r0 and r1
; =========================================================================	
quartersec:
	mov r0, #0FFh
	mov r1, #0FFh
quarterloop:
	djnz r0, quarterloop
	mov r0, #0FFh
	djnz r1, quarterloop
	ret
	
;===============================================================================
;getchr - This routine "gets" or receives a character from the PC, transmitted over
; the serial port. RI is the same as SCON.0 - the assembler recognizes
; either shorthand.  The 7-bit ASCII code is returned in the accumulator
; - uses acc, ri
;=================================================================================
getchr:
	jnb ri, getchr		; wait till character received
	mov a, sbuf		; get character and put it in the accumulator
	anl a, #7fh		; mask off 8th bit
	clr ri			; clear serial "receive status" flag
	ret

;==========================================================================
; sndchr - This routine "sends" or transmits a character to the PC, using the serial
; port.  The character to be sent is stored in the accumulator. SCON.1 and
; TI are the same as far as the assembler is concerned.
; uses scon.1, sbuf, acc
;===========================================================================
sndchr:
	clr scon.1		; clear the ti complete flag
	mov sbuf, a		; move a character from the acc to the sbuf
	txloop:
		jnb scon.1, txloop	; wait till chr is sent
		ret
	