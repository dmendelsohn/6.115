.org 0000h
ljmp main

.org 100h
main:
	mov dptr, #0FE18h
	mov a, #00h					; put some value in a
	movx @dptr, a				; write to ADC to refresh
	movx a, @dptr				; read voltage
	mov P1, a					; display on LED
	lcall quartersec			; do a delay
	sjmp main
	
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
