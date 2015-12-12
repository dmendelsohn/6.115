.org 8000h
ljmp main
dummyloop:
	sjmp dummyloop

.org 8100h
main:
	lcall init
	ljmp display_message
	
;====================================================================
; init - this command sets up the LCD module for input
;=====================================================================
init:
	mov dptr, #0FE0Bh			; control reg
	mov a, #80h					; all 3 ports output
	movx @dptr, a
	
	mov dptr, #0FE0Ah			; port C
	mov a, #00h					; lower the "E" line
	lcall push_and_wait
	mov dptr, #0FE08h			; port A
	mov a, #38h					; set display for 8 bit comm. 5x7 character set
	lcall push_and_wait
	lcall latch					; raise and lower the "E" line
	
	mov dptr, #0FE08h			; port A
	mov a, #0Ch					; turn on display, hide cursor
	lcall push_and_wait
	lcall latch
	
	mov dptr, #0FE08h			; port A
	mov a, #01h					; clear display
	lcall push_and_wait
	lcall latch					; raise and lower the "E" line
	
	mov dptr, #0FE0Ah			; Port C
	mov a, #00h					; lower the "E" line
	lcall push_and_wait
	mov dptr, #0FE08h			; Port A
	mov a, #80h					; Set RAM address to zero
	lcall push_and_wait
	lcall latch
	ret

;=================================================================
; latch - this routine latches by toggling the "E" line, 
;		assumes RS bit is low
;=================================================================
latch:
	mov dptr, #0FE0Ah			; port C
	mov a, #04h					; raise the "E" line
	lcall push_and_wait
	mov a, #00h					; lower the "E" line
	lcall push_and_wait
	ret

;=================================================================
; push_and_wait - sends value in acc to @dptr, and waits for 256
; 	machine cycles
;==================================================================	
push_and_wait:
	movx @dptr, a				; push value to LCD board
	mov r0, #0FFh
delay_loop:
	djnz r0, delay_loop
	ret

;=================================================================
; display_messase - this routine iterates through the db table, displaying the 
;	hex values that it reads
;=======================================================================		
display_message:
	mov r7, #12					; r7 = number of characters to display
	mov a, r7
	mov r2, a					; r2 = countdown reg (initially equal to r7)
display_loop:
	cjne r2, #00h, display_cont
	ljmp dummyloop				; end if we're done displaying all characters
display_cont:
	mov dptr, #message			; point to message table
	mov a, r7
	clr c
	subb a, r2					; acc holds (r7 - r0), index of character to be read
	movc a, @a+dptr				; grab ascii character
	lcall display_char
	dec r2						; decrement the countdown for num characters
	sjmp display_loop
	
;=============================================================
; display_char - this routine displays the character corresponding
;	to the hex value in the accumulator
;================================================================
display_char:
	mov r3, a					; r1 stores value to display
	
	mov dptr, #0FE0Ah			; port C
	mov a, #01h					; lower the "E" line
	lcall push_and_wait
	
	mov dptr, #0FE08h			; port A
	mov a, r3					; value to dipslay
	lcall push_and_wait
	
	mov dptr, #0FE0Ah			; port C
	mov a, #05h					; lower the "E" line
	lcall push_and_wait
	mov a, #01h					; raise the "E" line
	lcall push_and_wait
	ret
	
; this table holds the message to be displayed
message:						; encodes "Hello World!"
	.db 48h, 65h, 6Ch, 6Ch
	.db 6Fh, 90h, 57h, 6Fh
	.db 72h, 6Ch, 64h, 21h
