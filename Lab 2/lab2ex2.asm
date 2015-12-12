.org 00h
main:
	mov a, #00h
	mov p1, acc
	setb p1.2
	sjmp main
.db 50h, 61h, 72h, 74h
.db 79h, 20h, 6Fh, 6Eh
.db 20h, 69h, 6Eh, 20h
.db 36h, 2Eh, 31h, 31h
.db 35h, 21h
