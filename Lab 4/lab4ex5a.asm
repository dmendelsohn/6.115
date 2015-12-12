.org 0000h
ljmp main

.org 000Bh
TOISR:
	cjne r2, #01h, lowtohigh
hightolow:			; switching duty to non duty
	mov a, #0FFh
	clr c
	subb a, r1		; a now holds count up for rH
	mov th0, a		; set th0
	mov r2, #00h	; set boolean flag to indicate low cycle
	mov a, #00h		; low data
	movx @dptr, a	; send data to port A
	reti
lowtohigh:			; switching non-duty to duty
	mov r2, #01		; set boolean flag to indicate duty cycle
	mov a, r0
	clr c
	subb a, r1		; a now holds rL
	mov b, a
	mov a, #0FFh
	clr c
	subb a, b		; a now holds count up for rL
	mov th0, a		; set th0
	mov a, #0FFh	; high data
	movx @dptr, a	; send data to port A
	reti
	
.org 0100h
main:
	mov dptr, #0FE13h			; point to control reg
	mov a, #80h					; output control work
	movx @dptr, a
	mov dptr, #0FE10h			; point to port A
	mov tmod, #02h				; timer 0 in mode 2
	mov ie, #82h				; enable timer 0 interrupts
	mov r0, #80h				; this controls the frequency
	mov r1, #40h				; this controls the duty cycle
	mov r2, #01h				; r2 = #01 iff in the duty cycle
	mov th0, #0F0h				; th0 will cause jump to isr soon
	setb tr0					; run timer 0
loop:
	sjmp loop
