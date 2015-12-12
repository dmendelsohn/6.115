.org 0000h
ljmp main
dummyloop:
	sjmp dummyloop

.org 0100h
main:
	lcall init
mainloop:
	lcall get_voltage			; put voltage reading in accumulator
	lcall convert_voltage		; leaves first digit in acc, second digit in b
	lcall display_voltage		; displays the voltage held in acc and b
	lcall quartersec			; quarter-second delay
	lcall clear_display			; clear the display
	sjmp mainloop

;====================================================================
; init - sets up LCD for input
;======================================================================
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
	
	lcall clear_display			; clear the display
	
	mov dptr, #0FE0Ah			; Port C
	mov a, #00h					; lower the "E" line
	lcall push_and_wait
	mov dptr, #0FE08h			; Port A
	mov a, #80h					; Set RAM address to zero
	lcall push_and_wait
	lcall latch
	ret
	
;=======================================================================	
; latch - latches a value to the LCD display by toggling the "E" line
;		- assumes RS bit is low
;=======================================================================
latch:
	mov dptr, #0FE0Ah			; port C
	mov a, #04h					; raise the "E" line
	lcall push_and_wait
	mov a, #00h					; lower the "E" line
	lcall push_and_wait
	ret
	
;=========================================================================
; push_and_wait - this routine sends value in acc to @dptr and then blocks
;		for 256 machine cycles
;=========================================================================
push_and_wait:
	movx @dptr, a				; push value to LCD board
	mov r0, #0FFh
wait_loop:
	djnz r0, wait_loop
	ret

;=========================================================================
; quartersec - this commands creates a quarter second delay
;=========================================================================	
quartersec:
	mov r0, #0FFh
	mov r1, #0FFh
quartersecloop:
	djnz r0, quartersecloop
	mov r0, #0FFh
	djnz r1, quartersecloop
	ret

;========================================================================
; clear_display - clears the LCD display
;=========================================================================
clear_display:
	mov dptr, #0FE08h			; port A
	mov a, #01h					; clear display
	lcall push_and_wait
	lcall latch					; raise and lower the "E" line
	ret

;=========================================================================
; get_voltage - get 8 bit voltage value from ADC and put it into acc
;==========================================================================
get_voltage:
	mov dptr, #0FE18h			; point to ADC
	mov a, #00h					; any data is fine
	lcall push_and_wait
	movx a, @dptr				; read voltage in
	ret

;===========================================================================
; convert_voltage - interprets the 8 bit value of acc, and scales to a voltage
;		between 0 and 5.  It puts the value of the first digit in the acc
;		and the value of the second (tenths) digit into b
;==========================================================================		
convert_voltage:				; from acc, first digit in acc, second into b
	mov b, #51d					; divisor
	div ab
	mov r7, a					; first digit is now in r7
	mov P1, b 	;Debugging
	mov a, b
	mov b, #05d					; new divisor
	div ab
	cjne a, #10d, convert_finish   ; made sure lower digit is not overflowing
	mov a, #09d						; if it is, make it 9
convert_finish:
	mov b, a					; b now stores second digit
	mov a, r7					; acc now stores first digit
	ret

;============================================================================
; display_voltage - displays the digit represented in acc, then displays a decimal,
;		point then displays the digit represented in b
;============================================================================
display_voltage:				; displays voltage in accumulator
	mov r6, a					; first digit
	mov r7, b					; second digit
	mov a, #30h					; corresponds to "0" on LCD
	add a, r6					; now a holds digit we want to display
	lcall display_char			; display it
	mov a, #2Eh					; corresponds to decimal point character
	lcall display_char			; display decimal point
	mov a, #30h					; "0" character
	add a, r7					; digit we want
	lcall display_char			; display digit
	ret
	
;=============================================================================
; display_char - this routine displays the character whose hex value is
;	 	initially in the accumulator
;============================================================================
display_char:
	mov r1, a					; r1 stores value to display
	
	mov dptr, #0FE0Ah			; port C
	mov a, #01h					; lower the "E" line
	lcall push_and_wait
	
	mov dptr, #0FE08h			; port A
	mov a, r1					; value to dipslay
	lcall push_and_wait
	
	mov dptr, #0FE0Ah			; port C
	mov a, #05h					; lower the "E" line
	lcall push_and_wait
	mov a, #01h					; raise the "E" line
	lcall push_and_wait
	ret
	