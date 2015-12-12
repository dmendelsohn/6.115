.org 0000h
ljmp main


.org 100h
main:
	lcall init
mainloop:
	lcall getchr					; wait for any character
	lcall sndchr					; show user the character
	lcall do_process				; run the entire program
	sjmp mainloop
	
;========================================================================
; do_process - this command runs the entire program, which steps the motor
;	24 times, and does a full scan of the LEDs at each step, outputting the
;	data result to the serial port
;	uses acc, dptr, sbuf, scon.1, ri, P3.2, tmod, tcon, scon, th1
;			r0, r1, r2, r5, r6, r7
;=========================================================================
do_process:
	mov r7, #24d				; r7 counts rotational ticks
	mov r6,	#16d				; r6 counts scan
	mov r5,	#00h				; r5 keeps track of where we are in the firing seq
do_process_loop:
	cjne r7, #00h, do_process_cont	; check that we're not done rotating
	ret							; we've done 24 and we're done
do_process_cont:
	dec r7						; decrement rotation counter
	lcall do_move				; move 15 degrees
	lcall delay					; give time for move to happen
	lcall do_scan				; scan across all LEDs and photoresistors
	sjmp do_process_loop

;========================================================================
; do_move - this command performs the physical movement, one step of the motor
;	uses acc, dptr, r5
;=======================================================================
do_move:
	mov dptr, #firing_table		; point to firing table
	mov a, r5					; load table offset into acc
	movc a, @a+dptr				; move data value to load into acc
	lcall to_port_A				; make the move
	inc r5
	cjne r5, #04h, do_move_finish	; check if r5 hits 4 (maximum)
	mov r5, #00h				; reset to 0 (since 4 is 0 mod 4)
do_move_finish:
	ret
firing_table:
	.db 40h, 20h, 80h, 10h	
	
do_scan:
	cjne r6, #00h, do_scan_cont	; turn the light on and get a reading
	mov r6, #16d				; restore count when we're done
	lcall crlf					; new line
	ret
do_scan_cont:
	lcall do_light
	sjmp do_scan				; move on to next light

do_light:
	dec r6
	mov a, r6					; move current nibble to analyze into a
	lcall to_port_C				; send nibble to port C
	clr P1.7					; turn on light
	lcall delay					; wait for ADC to settle
	lcall read_value			; read voltage value into acc
	lcall print_value			; print hex value from acc onto screen
	setb P1.7					; turn off the LED on Spindude
	ret
	
read_value:
	mov dptr, #0FE18h			; point to ADC
	movx @dptr, a				; prompt ADC to latch new output value
	movx a, @dptr				; read from ADC into a
	ret
	
;===============================================================
; subroutine print_value
; this routine takes the contents of the acc and prints it out
; as a 2 digit ascii hex number.  then it prints a space
;===============================================================
print_value:
   push acc
   lcall binasc           ; convert acc to ascii
   lcall sndchr           ; print first ascii hex digit
   mov   a,  r2           ; get second ascii hex digit
   lcall sndchr           ; print it
   mov a, #20h			  ; ascii for space character
   lcall sndchr			  ; print space character
   pop acc
   ret
   
;===============================================================
; subroutine binasc
; binasc takes the contents of the accumulator and converts it
; into two ascii hex numbers.  the result is returned in the
; accumulator and r2.
;===============================================================
binasc:
   mov   r2, a            ; save in r2
   anl   a,  #0fh         ; convert least sig digit.
   add   a,  #0f6h        ; adjust it
   jnc   noadj1           ; if a-f then readjust
   add   a,  #07h
noadj1:
   add   a,  #3ah         ; make ascii
   xch   a,  r2           ; put result in reg 2
   swap  a                ; convert most sig digit
   anl   a,  #0fh         ; look at least sig half of acc
   add   a,  #0f6h        ; adjust it
   jnc   noadj2           ; if a-f then re-adjust
   add   a,  #07h
noadj2:
   add   a,  #3ah         ; make ascii
   ret

crlf:
; This routine inserts a carriage return and line feed
	push acc
    mov a, #13			; fill accumulator with ASCII code for carriage return
    lcall sndchr		; send contents of accumulator
    mov a, #10			; fill accumulator with ASCII code for line feed
    lcall sndchr		; send contents of accumulator
    pop acc
    ret
	
;========================================================================
; init - command to set up 8255 output, timer and serial stuff
; 	uses acc, dptr, P3.2, tmod, tcon, th1, scon
;=========================================================================
init:
	mov dptr, #0FE13h			; control reg of 8255
	mov a, #80h					; output on all ports
	movx @dptr, a
	setb P3.2					; disable output for 74C922
	mov tmod, #0A0h		; set time 1 for auto reload - mode 2
	mov tcon, #40h		; run timer 1
	mov th1, #0FDh		; set 9600 baud with xtal=11.059mhz (th1 = 253)
	mov scon, #50h		; set serial control reg for 8 bit data and mode 1
	ret


;========================================================================
; to_port_A	- command to push the value in the acc to port A on the 8255
; uses acc, dptr
;=========================================================================
to_port_A:
	mov dptr, #0FE10h			; point dptr to port A on 8255
	movx @dptr, a				; move value in acc to that location
	ret
	
;========================================================================
; to_port_C	- command to push the value in the acc to port C on the 8255
; uses acc, dptr
;=========================================================================
to_port_C:
	mov dptr, #0FE12h			; point dptr to port C on 8255
	movx @dptr, a				; move value in acc to that location
	ret

;==========================================================================
; delay - this command does a certain number of quartersec calls,
; uses acc, r0, r1, r2
;==========================================================================
delay:
	mov r2, #02h				; 2 call to quartersec
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
	