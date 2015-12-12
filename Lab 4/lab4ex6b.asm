.org 0000h
ljmp main

.org 0Bh
ljmp toisr

.org 100h
main:
	lcall init
mainloop:
	sjmp mainloop
	
;============================================================================
; init - this command sets up initial conditions.  Namely it writes the control
;	word to the 8255 chip, disables the 74C922, and starts timer 0 in mode 2
; uses acc, dptr, P3.2
;=============================================================================	
init:
	mov dptr, #0FE13h			; control reg of 8255
	mov a, #80h					; output on all ports
	movx @dptr, a
	setb P3.2					; disable output for 74C922
	mov ie, #82h				; enable timer 0 interrupts only
	mov tmod, #02h				; timer 0 in mode 2
	mov th0, #04Ch				; set timer reset number
	setb tr0					; start timer 0
	ret

;==========================================================================
;toisr - this command scans the 5 input bits from the robot arm keypad.  The first
;	scan checks for positive connections and the second for negative connections.
;	if a switch is activated, we move the robot arm appropriately and reti, otherwise
;	do nothing and reti
; uses acc, r6, r7, dptr, P1
;===========================================================================
toisr:
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
	lcall to_port_A				; pushes value in acc to port A
	inc r7						; increment the in-table pointer
	mov dptr, #portout			; dptr is used by to_port_A, so we need to reset
	mov a, r7
	movc a, @a+dptr				; load port B value
	lcall to_port_B				; pushes value in acc to port B
	sjmp scan_finish
scan_null:						; if we get here, the robot should be stationary
	mov a, #00h
	lcall to_port_A
	mov a, #00h
	lcall to_port_B				; push stationary values to both ports
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
