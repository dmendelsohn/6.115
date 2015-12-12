; The main loop or body of our typewriter program

.org 00h			; power up and reset vector
    sjmp main

.org 80h
main:	
    lcall init			; Start the serial port by calling subroutine "init"
    lcall getnum		; puts a byte in acc
    push acc			; pushes first number onto the stack
    lcall crlf			; new line
    lcall getnum		; gets second number
    push acc			; pushes second number onto the stack
    lcall crlf			; new line
    lcall getop			; acc now has 1 for add, 0 for subtract
    jnb acc, subtractor		; otherwise we're adding
    sjmp adder

adder:
    pop b			; b contains second number
    pop acc			; accumulator contains first number
    add a, b			; accumulator now contains sum
    sjmp continue

subtractor:
    pop b			; b contains second number
    pop acc			; accumulator contains first number
    clr c			; clear carry bit
    subb a, b			; accumulator now contains difference
    sjmp continue

continue:			; accumulator now contains result
    mov P1, acc			; display result on LED bank
    mov r0, acc			; store the value in r0
    lcall crlf			; line break
    mov a, r0			; restore the value back to the accumulator
    lcall display		; display contents of accumulator to screen
    sjmp main

init:
; set up serial port with a 11.0592 MHz crystal
; use timer 1 for 9600 baud serial communications
    mov tmod, #0A0h		; set time 1 for auto reload - mode 2
    mov tcon, #40h		; run timer 1
    mov th1, #0FDh		; set 9600 baud with xtal=11.059mhz (th1 = 253)
    mov scon, #50h		; set serial control reg for 8 bit data and mode 1
    ret

getchr:
; This routine "gets" or receives a character from the PC, transmitted over
; the serial port. RI is the same as SCON.0 - the assembler recognizes
; either shorthand.  The 7-bit ASCII code is returned in the accumulator

    jnb ri, getchr		; wait till character received
    mov a, sbuf		; get character and put it in the accumulator
    anl a, #7fh			; mask off 8th bit
    clr ri			; clear serial "receive status" flag
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

crlf:
; This routine inserts a carriage return and line feed
    mov a, #13			; fill accumulator with ASCII code for carriage return
    lcall sndchr		; send contents of accumulator
    mov a, #10			; fill accumulator with ASCII code for line feed
    lcall sndchr		; send contents of accumulator
    ret

getnum:
; This routine takes in the digits from the user and puts the appropriate number in acc
    mov r0, #3		; run this loop three times to get three digits
    mov b, #00h
    loop:
        lcall getchr		; <- gets a character from the PC keyboard
        lcall sndchr		; -> and then echoes the character to the PC screen
	lcall concatdigit  	; concat the digit we just got to the number we're "building"
	djnz r0, loop
    mov a, b			; Moves the buffer value from reg b to the accumulator
    ret

concatdigit:
; This routine takes the value in the accumulator and decrements it by 30 to get
; the value of the digit that should be represented.  It then multiplies
; the value in reg b by 10 and adds the new value in the accumulator
; effectively, this concatenates a digit to the end of a base-10 number.
    clr c
    subb a, #30h		; convert ascii to actual value
    mov r2, a			; Store a away in r2
    mov a, #10			; load up multiplier
    mul ab			; a now holds 10*b
    add a, r2			; add new digit
    mov b, a			; put back in b register
    ret
	
getop:
; This routine accepts a "+" or "-" from the user, and loads the value
; 1 into the accumulator in the former case and 0 in the latter.
    lcall getchr
    mov r0, #00h
    cjne a, #43, gotdash	; jump if the accumulator DOESNT contain the "+" character
    mov r0, #01h		; this is reached if entry was "+"
gotdash:			; at this point r0 contains the value we want to return
    mov a, r0			; load our return value in the accumulator
    ret

display:
; This method prints out the contents of the accumulator, in base 10
    pop b
    mov r7, b			; store one byte of data needed to return from call
    pop b
    mov r6, b			; store other byte of data needed to return from call
    mov r0, #3
calcdigit:
    mov b, #10			; load the constant 10 into reg b
    div ab
    push b			; push digits of base 10 number onto stack (in reverse order)
    djnz r0, calcdigit
; at this point the top three entries in the stack are the three digits we want to display
    mov r0, #3
displaydigit:
    pop acc
    add a, #30h			; convert digit to unicode value
    lcall sndchr
    djnz r0, displaydigit	; loop 3 times
    lcall crlf
    lcall crlf
	
    mov r6, b			; the next four lines restore data that lcall put on the stack
    push b
    mov r7, b
    push b
    

