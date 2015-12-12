.org 00h			; power up and reset vector
    ljmp start			;when the micro wakes up, jump to the beginning of
				;the main body or loop in the program called "start"
.org 100h			; and located at address location 100h ni external mem

start:
    lcall init			; Start the serial port by calling subroutine "init"
    loop:
        lcall getchr		; <- gets a character from the PC keyboard
        lcall sndchr		; -> and then echoes the character to the PC screen
	mov a, #0FFh
	lcall delay		; delay a quarter of a second
    sjmp loop

init:
; set up serial port with a 11.0592 MHz crystal
; use timer 1 for 9600 baud serial communications
    mov tmod, #0A0h			; set time 1 for auto reload - mode 2
    mov tcon, #40h		      	; run timer 1
    mov th1, #0FDh			; set 9600 baud with xtal=11.059mhz (th1 = 253)
    mov scon, #50h			; set serial control reg for 8 bit data and mode 1
    mov P1, #0FFh
    ret

getchr:
; This routine "gets" or receives a character from the PC, transmitted over
; the serial port. RI is the same as SCON.0 - the assembler recognizes
; either shorthand.  The 7-bit ASCII code is returned in the accumulator
    jnb P3.3, getchr                    ; wait till character received
    clr P3.2				; enable output from keypad
    mov a, P1				; get character and put it in the accumulator
    setb P3.2			     	; disable output from keypad
    lcall convertpress			; puts unicode of keypad response form acc into acc
    ret

sndchr:
; This routine "sends" or transmits a character to the PC, using the serial
; port.  The character to be sent is stored in the accumulator. SCON.1 and
; TI are the same as far as the assembler is concerned.

    clr scon.1			; clear the ti complete flag
    mov sbuf, a			; move a character from the acc to the sbuf
    txloop:
        jnb scon.1, txloop	; wait till chr is sent	
    ret

convertpress:
    anl a, #0fh			; mask off high order nibble
    mov dptr, #keytab 		; store table address in dptr register
    movc a, @a+dptr		; load accumulator with ascii value
    ret
keytab:
    .db 31h, 32h, 33h, 43	; these lines map keypad values to ASCII values
    .db 34h, 35h, 36h, 45
    .db 37h, 38h, 39h, 67
    .db 88, 30h, 88, 68

delay:
;This method causes a delay based on whatever value is in a and b 
    djnz b, delay
    mov b, #0FFh
    djnz acc, delay
    ret



