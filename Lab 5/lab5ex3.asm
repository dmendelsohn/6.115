.org 0000h
ljmp main

.org 0Bh
ljmp toisr

.org 100h
main:
	lcall init_constants		; set up Vref and gain constants
	lcall init_clock			; set up clock interrupt
	lcall init_lcd				; set up the LCD for input
	lcall do_lcd_display		; have LCD display Vref and gain constants		
mainloop:
	sjmp mainloop				; infinite loop - all the work is done in the isr
	
;========================================================================
; init_clock - this routine sets up timer 0 in mode 2, as well as our
;		counting registers that allow us to only go into a relevant routine
;		every nth interrupt
;=========================================================================
init_clock:
	mov tmod, #02h				; clock 0 in mode 2 (8 bit autoreload)
	mov ie, #082h				; set up timer 0 interrupt
	mov th0, #155d				; interrupt every 101 machine cycles
	mov r7, #73d				; we want to only run the feedback loop every 73rd time
	mov r4, #250d				; every 250th time the 125Hz sample happens, we
								; switch Vref from high to low or vice versa
	setb tr0					; start the timer
	ret

;=====================================================================
; init_constants - this routine sets up our Vref and gain constants
;=====================================================================	
init_constants:
	mov r3, #80h				; THIS IS OUR DESIRED REFERENCE VOLTAGE
	mov r5, #30d				; THIS IS OUR DESIRED GAIN
	mov a, r3
	mov r6, a					; initially our current actual voltage (r6)
								; is high (r3), not 0.
	ret

;====================================================================
; init_lcd - sets up LCD for input
;======================================================================
init_lcd:
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

;========================================================================
; clear_lcd_display - clears the LCD display
;=========================================================================
clear_lcd_display:
	mov dptr, #0FE08h			; port A
	mov a, #01h					; clear display
	lcall push_and_wait
	lcall latch					; raise and lower the "E" line
	ret

;===================================================================
; do_lcd_display - this routine displays the voltage and the gain to
;		the LCD display
;==================================================================
do_lcd_display:
	mov a, #56h					; V
	lcall display_char
	mov a, #72h					; r
	lcall display_char
	mov a, #65h					; e
	lcall display_char
	mov a, #66h					; f
	lcall display_char
	mov a, #3Ah				; COLON
	lcall display_char
	mov a, #90h					; SPACE
	lcall display_char	
	mov a, r6					; acc now holds Vref byte
	lcall convert_voltage		; acc holds high dec digit, b holds low dec digit
	lcall display_voltage		; dipslay those digits to screen
	mov a, #2Ch					; COMMA
	lcall display_char
	mov a, #90h					; SPACE
	lcall display_char
	mov a, #47h					; G
	lcall display_char
	mov a, #61h					; a
	lcall display_char
	mov a, #69h					; i
	lcall display_char
	mov a, #6Eh					; n
	lcall display_char
	mov a, #3Ah					; COLON
	lcall display_char
	mov a, #90h					; SPACE
	lcall display_char
	mov a, r5					; acc holds gain value
	lcall display_num			; display gain
	ret

;===========================================================================
; convert_voltage - interprets the 8 bit value of acc, and scales to a voltage
;		between 0 and 5.  It puts the value of the first digit in the acc
;		and the value of the second (tenths) digit into b
;==========================================================================		
convert_voltage:				; from acc, first digit in acc, second into b
	mov b, #51d					; divisor
	div ab
	mov r0, a					; first digit is now in r0
	mov a, b
	mov b, #05d					; new divisor
	div ab
	cjne a, #10d, convert_finish   ; made sure lower digit is not overflowing
	mov a, #09d						; if it is, make it 9
convert_finish:
	mov b, a					; b now stores second digit
	mov a, r0					; acc now stores first digit
	ret

;============================================================================
; display_voltage - displays the digit represented in acc, then displays a decimal,
;		point then displays the digit represented in b
;============================================================================	
display_voltage:				; displays voltage in accumulator, b
	mov r1, b					; acc holds first digit, r1 holds second digit					
	lcall display_digit			; display first digit, which is in acc
	mov a, #2Eh					; DECIMAL POINT
	lcall display_char
	mov a, r1
	lcall display_digit			; display second digit	
	mov a, #56h					; V
	lcall display_char			; display character
	ret

;===========================================================================
; display_num - this routine displays the value in acc as a 3-digit decimal
;		number
;============================================================================
display_num:					; displays a number
	mov b, #100d				; divisor = 100d
	div ab						; a holds hundreds place, b holds the rest
	lcall display_digit			; displays the hundreds place
	mov a, b					; acc hold number 0-99
	mov b, #10d					; divisor = 10d
	div ab						; a holds tens place, b holds ones place
	lcall display_digit
	mov a, b					; a holds ones place
	lcall display_digit
	ret

;=========================================================================
; display_digit - this routine displays the value (00h-09h) in the accumulator
;		as a digit on the LCD screen
;===========================================================================	
display_digit:
	add a, #30h					; convert to digit to character encoding
	lcall display_char			; display the digit character
	ret

;=============================================================================
; display_char - this routine displays the character whose hex value is
;	 	initially in the accumulator
;============================================================================	
display_char:
	mov r2, a
	;--------------------------------------------------
	mov dptr, #0FE0Ah			; port C
	mov a, #01h					; lower the "E" line
	lcall push_and_wait
	;--------------------------------------------------
	mov dptr, #0FE08h			; port A
	mov a, r2					; value to dipslay
	lcall push_and_wait
	;-------------------------------------------------
	mov dptr, #0FE0Ah			; port C
	mov a, #05h					; lower the "E" line
	lcall push_and_wait
	;--------------------------------------------------
	mov a, #01h					; raise the "E" line
	lcall push_and_wait
	ret

;=========================================================================
; push_and_wait - this routine sends value in acc to @dptr and then blocks
;		for 256 machine cycles
;=========================================================================
push_and_wait:
	movx @dptr, a				; push value to LCD board
	mov a, #0FFh
	lcall delay					; delay to let LCD board read value in
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

;================================================================
; toisr - this is the top-level isr routine
;===============================================================	
toisr:
	cjne r7, #00d, no_feedback	; 72 out of 73 interrupts, we do nothing
	mov r7, #73d				; reset counter to 73
	lcall do_feedback			; run our feedback routine
	reti
no_feedback:
	dec r7
	reti

;================================================================
; do_feedback - this routine is invoked when we want to sample from
;		the ADC, interpret the value, and write a value to compensate
;		for error
;==================================================================	
do_feedback:
	cjne r4, #00h, do_feedback_cont	; jump if no need to toggle Vref
toggle:
	mov r4, #250d				; reset toggle counter
	cjne r6, #00h, toggle_low	; jump if we are currently high	
toggle_high:
	mov a, r3
	mov r6, a					; set Vref value high
	sjmp toggle_finish
toggle_low:
	mov r6, #00h				; set Vref value low
	sjmp toggle_finish
toggle_finish:
	lcall clear_lcd_display		; clear the display
	lcall do_lcd_display		; rewrite the display
do_feedback_cont:
	dec r4
	lcall read_from_adc			; get voltage value from adc
	mov r0, a					; r0 holds our voltage reading
	clr c
	mov a, r6					; acc holds ref voltage
	subb a, r0					; compute error
	jc neg_error				; if error is negative, output 0 to DAC
	mov b, r5					; put gain constant in b
	mul ab						; multiply error by gain
	cjne a, #00h, overflow		; if a > 0, then we have multiplication overflow
	mov a, b					; acc holds desired "command" for DAC
	lcall write_to_dac			; push value to the DAC
	ret
neg_error:
	mov a, #00h					; if neg error, we write command 0
	lcall write_to_dac
	ret
overflow:
	mov a, #0FFh				; if error*gain > FFh, we write command FFh	
	lcall write_to_dac
	ret

;===========================================================================
; read_from_adc - this routine reads a value from the adc and stores
;	it in the accumulator
;============================================================================	
read_from_adc:
	mov dptr, #0FE18h		; point to ADC
	mov a, #00h				; any data
	movx @dptr, a			; write to adc to latch new data
	mov a, #40h
	lcall delay				; delay to allow ADC to latch value
	movx a, @dptr			; read to digital value
	ret

;=========================================================================
; write_to_dac - this routine writes the value in the accumulator to the DAC
;===========================================================================
write_to_dac:
	mov dptr, #0FE10h		; point to DAC
	movx @dptr, a			; write to DAC
	ret
	
;===========================================================================
; delay - this routine delays proportionally to the value initially in the acc
;=============================================================================
delay:
	djnz acc, delay
	ret
	