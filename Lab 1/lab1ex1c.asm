clr a
mov P1, a			; turn off all lights
setb P1.0			; turn on light corresponding to low order bit
loop:
	sjmp loop
