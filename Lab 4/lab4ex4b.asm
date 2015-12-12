.org 8000h
main:
	mov dptr, #0FE13h		; control register
	mov a, #80h				; control word for output
	movx @dptr, a			; move word into register
	mov dptr, #0FE10h		; port A register
	mov a, #0FFh			; byte to output to port A
loop:
	cpl a
	movx @dptr, a			; output to port A
	lcall shortwait
	sjmp loop
	
longwait:		;; delays for 0.25 seconds
	mov r0, #0FFh
	mov r1, #0FFh
longloop:
	djnz r0, longloop
	mov r0, #0FFh
	djnz r1, longloop
	ret

shortwait:		;; delays for 0.1 milliseconds
	mov r0, #28h		;
shortloop:
	djnz r0, shortloop
	ret
