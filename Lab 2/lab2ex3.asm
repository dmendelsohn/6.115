.org 8000h
main:
	mov p1, #02h			; debugging
	lcall init				; puts operands in r0 and r1
	lcall adder				; puts sum of operands in 9002h
	lcall subtract			; puts diff of operands in 9003h
	lcall multiply			; puts product in 9004-9005h
	lcall divide			; puts quotient in 9006h and
							; 	puts remainder in 9007h
    mov a, #00h
	push acc
	mov a, #00h
	push acc
	ret						; go to address 0, beginning of MINMON
	
;===========================================================
; init command - loads dptr with last used data address (9001h)
;					loads r0 with contents of 9000h
;					loads r1 with contents of 9001h
;============================================================
init:
	mov dph, #090h
	mov dpl, #00h
	movx a, @dptr			; loads acc with contents of 9000h
	mov r0, acc				; and moves the data to r0
	inc dptr
	movx a, @dptr			; loads acc with contents of 9001h
	mov r1, acc				; and moves the data to r1
	ret
	
;==============================================================
; adder command - puts sum of r0 and r1 in #9002h
;==============================================================

adder:
	mov a, r0
	add a, r1				; acc now holds sum of r0 and r1
	inc dptr				; increment dptr to next empty spot
	movx @dptr, a			; load data into that location
	ret

;==============================================================
; subtract command - puts r0 minus r1 in #9003h
;==============================================================

subtract:
	mov a, r0
	clr c
	subb a, r1				; acc now holds r0-r1
	inc dptr				; increment dptr to next empty spot
	movx @dptr, a			; load data into that location
	ret

;==============================================================
; multiply command - puts product of r0 and r1 in #9004-5h,
;				msb in #9004h, lsb in #9005h
;==============================================================

multiply:
	mov a, r0
	mov b, r1
	mul ab					; acc now has lsb, b has msb
	xch a, b				; acc now has msb, b has lsb
	inc dptr				; increment dptr to next empty spot
	movx @dptr, a			; load msb into that location
	inc dptr				; increment dptr to next empty spot
	mov a, b
	movx @dptr, a			; load lsb into that location
	ret
	
;==============================================================
; divide command - puts r1 divided by r0 in #9006-7h
;				- quotient in #9006h, remainder in #9007h
;==============================================================

divide:
	mov a, r0
	mov b, r1
	div ab					; acc has quotient, b has remainder
	inc dptr				; increment dptr to next empty spot
	movx @dptr, a			; load quotient into that location
	inc dptr				; increment dptr to next empty spot
	mov a, b
	movx @dptr, a			; load remainder into that location
	ret
