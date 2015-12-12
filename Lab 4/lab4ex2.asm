.org 0000h
main:
	mov dptr, #0FE13h			; control reg of 8255
	mov a, #80h					; output on all ports
	movx @dptr, a
	mov dptr, #0FE11h			; port B of 8255
loop:
	mov a, #00h					; low voltage
	movx @dptr, a				; drive low
	lcall wait
	mov a, #0FFh				; high voltage
	movx@dptr, a				; drive high
	lcall wait
	sjmp loop
	
wait:
	mov r2, #10h
waitloop:
	lcall quick
	djnz r2, waitloop
	ret

quick:
	mov r0, #0FFh
	mov r1, #0FFh
quickloop:
	djnz r0, quickloop
	mov r0, #0FFh
	djnz r1, quickloop
	ret
