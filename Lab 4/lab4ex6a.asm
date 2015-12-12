.org 0000h
ljmp main

.org 100h
main:
	lcall init
	ljmp scan
	
init:
	mov dptr, #0FE13h			; control reg of 8255
	mov a, #80h					; output on all ports
	movx @dptr, a
	mov r7, #00h				; r7 will be out pointer within the data table
	ret

;==========================================================================
;scan - this command scans through the portout data table, alternately
;	pushing values to port A and port B.  Between each pair of pushes (1 to
;	each port), it waits for a while
; uses acc, r0, r1, r7, dptr
;===========================================================================
scan:
	mov dptr, #portout			; point to beginning of table
	mov a, r7
	movc a, @a+dptr				; load port A value
	lcall to_port_A				; pushes value in acc to port A
	inc r7						; increment the in-table pointer
	mov dptr, #portout			; dptr is used by to_port_A, so we need to reset
	mov a, r7
	movc a, @a+dptr				; load port B value
	lcall to_port_B				; pushes value in acc to port B
	inc r7
	cjne r7, #20d, continue		; if r7 is 20, then we need to set it to 0
	mov r7, #00h				; reset r7, this is reached only if r7 was 20	
continue:
	mov a, #08h					; specify 2 second delay
	lcall delay					; do delay
	sjmp scan
	
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
;	specified by the value in acc
; uses acc, r0, r1, r2
;==========================================================================
delay:
	mov r2, acc					; number of quartersec calls is now in r2
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
		
portout:
.db 10h, 00h
.db 20h, 00h
.db 40h, 00h
.db 80h, 00h
.db 00h, 10h
.db 00h, 20h
.db 00h, 40h
.db 00h, 80h
.db 00h, 04h
.db 00h, 08h
