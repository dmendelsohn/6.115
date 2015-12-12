clr a
mov P1, a			; turn off all LEDs
setb P1.0			; turns lights 0, 3, 4, and 7 on.
setb P1.3
setb P1.4
setb P1.7
loop:
	sjmp loop
