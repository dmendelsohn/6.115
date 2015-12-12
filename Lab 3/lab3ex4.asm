.org 00h
	ljmp start

.org 100h
start:
	lcall init
loop:
	mov dptr, #0FE15h		; Check the line status register to
	movx a, @dptr			; see if a byte has been received.
	anl a, #01h
	jz loop
	
	mov dptr, #0FE10h		; REad in a byte from the buffer reg
	movx a, @dptr
	mov P1, a				; and display in on the lights
	sjmp loop
	
init:
	mov a, #83h		; set 8bit char, no parity, 1 stop bit, DLAB=1
	mov dptr,	#0FE13h		; line control address
	movx @dptr, a
	
	mov a, #0Dh				; set div for 9600 baud with xtal=2Mhz
	mov dptr, #0FE10h		; divisor latch address
	movx @dptr, a
	mov a, #00h
	mov dptr, #0FE11h
	movx @dptr, a
	
	mov a, #03h				; set DLAB=0
	mov dptr, #0FE13h		; line control address
	movx @dptr, a
	
	mov a, #00h				; disable interrupts
	mov dptr, #0FE11h		; interrupt enable register
	movx @dptr, a
	ret
