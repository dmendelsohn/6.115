.org 0000h
ljmp main

.org 100h
main:
	lcall read_from_adc
	lcall write_to_dac
	sjmp main
	
;===========================================================================
; read_from_adc - this routine reads a value from the adc and stores
;	it in the accumulator
;============================================================================
read_from_adc:
	mov dptr, #0FE18h		; point to ADC
	mov a, #00h				; any data
	movx @dptr, a			; write to adc to latch new data
	lcall delay
	lcall delay
	movx a, @dptr			; read to digital value
	ret

;=========================================================================
; write_to_dac - this routine writes the value in the accumulator to the DAC
;===========================================================================
write_to_dac:
	mov dptr, #0FE10h		; point to DAC
	movx @dptr, a			; write to DAC
	ret

;===========================================================================
; delay - this routine delays by 487 microseconds
;=============================================================================
delay:
	mov r0, #0F2h			; sets up delay command to take 487 microseconds
delayloop:
	djnz r0, delayloop
	ret
	
	
	