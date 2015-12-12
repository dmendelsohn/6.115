.org 0000h
ljmp main

.org 0Bh
ljmp scan_isr

.org 13h
ljmp key_isr

.org 1Bh
ljmp pwm_isr

.org 100h
main:
	lcall init
mainloop:
	sjmp mainloop
maindummy:
	mov ie, #00h
maindummyloop:
	mov P1, a			; DEBUGGING
	sjmp maindummyloop
	
;============================================================================
; init - this command sets up initial conditions.  Namely it writes the control
;	word to the 8255 chip, disables the 74C922, and starts timer 0 in mode 2
; uses acc, dptr, P3.2, r3, r4, r5
;=============================================================================	
init:
	mov dptr, #0FE13h			; control reg of 8255
	mov a, #80h					; output on all ports
	movx @dptr, a
	setb P3.2					; disable output for 74C922
	mov ie, #8Eh				; enable timers /0 and 1 intr, and ext1 intr
	;;mov ie, #8Ah				; use this value if telephone keypad not needed
	mov tmod, #22h				; timers 0 and 1 in mode 2
	mov th0, #00h				; set timer reset number
	mov th1, #00h				; this value will be changed in the intr routine
	setb tr0					; start timer 0
	setb tr1					; start timer 1
	mov r3, #0FFh				; this controls the frequency of the pwm
	mov r4, #80h				; 80h is D=0.5, 48h is D=0.25, BBh is D=1.0
	mov r5, #01h				; r5 = #01 iff in the duty cycle of the pwm
	ret

;==========================================================================
;key_isr - this command handles a key press from the telephone keypad,
;	and changes the PWM accordingly
; uses acc, P1, P3.2, P3.3, r4
;==========================================================================
key_isr:
	clr P3.2					; enable output from tele keypad
	mov a, P1					; get data from keypad
	anl a, #0Fh					; mask high order nibble
	cjne a, #00h, not_low		; jump if we DONT get D=0.25 (1 on keypad)
	mov r4, #48h				; set up low duty cycle (D=0.25)
	sjmp key_finish 
not_low:
	cjne a, #01h, not_mid		; jump if we DONT get D=0.5 (2 on keypad)
	mov r4, #80h				; set up mid duty cycle (D=0.5)
	sjmp key_finish
not_mid:
	cjne a, #02h, key_finish	; jump if we DONT get D=1.0 (3 on keypad)
	mov r4, #0BBh				; set up high duty cycle (D=1.0)
key_finish:
	setb P3.2					; disable output from tele keypad
	reti						; done with interrupt routine
	
;==========================================================================
; pwm_isr - this command toggles the port A and port B values between their
	; "true" values and 0, thus creating a PWM
; uses acc, dptr, r1, r2, r3, r4, 
;==========================================================================
pwm_isr:
	cjne r5, #01h, lowtohigh
hightolow:			; switching duty to non duty
	mov a, #0FFh
	clr c
	subb a, r4		; a now holds count up for rH
	mov th0, a		; set th0
	mov r5, #00h	; set boolean flag to indicate low cycle
	mov a, #00h		; low data
	lcall to_port_A ; send to port A
	mov a, #00h		; low data
	lcall to_port_B	; send to portB
	reti
lowtohigh:			; switching non-duty to duty
	mov r5, #01		; set boolean flag to indicate duty cycle
	mov a, r3
	clr c
	subb a, r4		; a now holds rL
	mov b, a
	mov a, #0FFh
	clr c
	subb a, b		; a now holds count up for rL
	mov th0, a		; set th0
	mov a, r1		; stored port A value into acc (note r1 holds port A word)
	lcall to_port_A	; send to port A
	mov a, r2		; stored port B value into acc (note r2 holds port B word)
	lcall to_port_B
	reti

;==========================================================================
;scan_isr - this command scans the 5 input bits from the robot arm keypad.  The first
;	scan checks for positive connections and the second for negative connections.
;	if a switch is activated, we move the robot arm appropriately and reti, otherwise
;	do nothing and reti
; uses acc, r6, r7, dptr, P1
;===========================================================================
scan_isr:
	mov r7, #00h				; r7 counts many checks we've done
	mov r6, #00h				; r6 is 0 when we have not yet completed pos. scan
	clr P1.0
	setb P1.7					; first do positive scan
	sjmp scan_loop
scan_again:
	mov r6, #01h				; r6 is 1 once we have completed the positive scan
	setb P1.0
	clr P1.7					; second do negative scan
	sjmp scan_loop
scan_loop:
	jnb P1.1, move_robot			; check wrist terminal, r7 = 0 or 5
	inc r7
	jnb P1.2, move_robot			; check shoulder terminal, r7 = 1 or 6
	inc r7
	jnb P1.4, move_robot			; check base terminal, r7 = 2 or 7
	inc r7
	jnb P1.5, move_robot			; check elbow terminal, r7 = 3 or 8
	inc r7
	jnb P1.6, move_robot			; check gripper terminal, r7 = 4 or 9
	inc r7
	cjne r6, #00h, scan_null	; if this isn't our first scan, we're done
	sjmp scan_again				; if we get here, we still need negative scan
move_robot:						; r7 indicates which values to write
	mov a, r7
	add a, r7
	mov r7, a					; double r7, since table is of size 2*(num states)
	mov dptr, #portout			; point to beginning of table
	mov a, r7
	movc a, @a+dptr				; load port A value
	mov r1, a					; put port A data into r1 (pwm will load it eventually)
	inc r7						; increment the in-table pointer
	mov dptr, #portout			; dptr is used by to_port_A, so we need to reset
	mov a, r7
	movc a, @a+dptr				; load port B value
	mov r2, a					; put port B data into r2 (pwm will load it eventually)
	sjmp scan_finish
scan_null:						; if we get here, the robot should be stationary
	mov r1, #00h				; put low data in port A storage reg
	mov r2, #00h				; put low data in port B storage reg
scan_finish:
	reti						; leave interrupt routine
	
;========================================================================
; to_port_A	- command to push the value in the acc to port A on the 8255
; uses acc, dptr
;=========================================================================
to_port_A:
	mov dptr, #0FE10h			; point dptr to port A on 8255
	movx @dptr, a				; move value in acc to that location
	ret

;========================================================================
; to_port_B	- command to push the value in the acc to port B on the 8255
; uses acc, dptr
;=========================================================================
to_port_B:
	mov dptr, #0FE11h			; point dptr to port B on 8255
	movx @dptr, a				; move value in acc to that location
	ret
		
portout:			; OLD VALUES
.db 10h, 00h					; positive wrist
.db 40h, 00h					; positive shoulder
.db 00h, 10h					; positive base
.db 00h, 40h					; positive elbow
.db 00h, 04h					; positive gripper
.db 20h, 00h					; negative wrist
.db 80h, 00h					; negative shoulder
.db 00h, 20h					; negative base
.db 00h, 80h					; negative elbow
.db 00h, 08h					; negative gripper
