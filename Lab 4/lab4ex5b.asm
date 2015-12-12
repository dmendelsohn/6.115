.org 0000h
ljmp main


.org 100h
main:
	mov dptr, #0FE03h		; point to control reg of 8254
	mov a, #0B4h			; clk2 in mode 2 (two byte input)
	movx @dptr, a			; load it
	mov a, #72h				; clk1 in mode 1 (two byte input)
	movx @dptr, a			; load it
	mov dptr, #0FE02h		; point to clock 2
	mov a, #00h				; lsb
	movx @dptr, a			; load it
	mov a, #01h				; msb
	movx @dptr, a			; load it
	mov dptr, #0FE01h		; point to clock 1
	mov a, #80h				; lsb
	movx @dptr, a			; load it
	mov a, #00h				; msb
	movx @dptr, a			; load it
loop:
	sjmp loop
