.org 8000h
main:
	mov r0, #00h				; r0 stores table offset
mainloop:
	clr c
	mov dptr, #sinewave			; dtpr points to table
	mov a, r0					; acc now holds offset
	movc a, @a+dptr				; load acc with table value
	mov dptr, #0FE08h			; point dptr to 558 chip
	movx @dptr, a				; write data to 558 chip
	inc r0						; increment offset
	sjmp mainloop				; repeat loop
	
sinewave:
.db 080h, 083h, 086h, 089h, 08Ch, 08Fh, 092h, 095h
.db 098h, 09Ch, 09Fh, 0A2h, 0A5h, 0A8h, 0ABh, 0AEh
.db 0B0h, 0B3h, 0B6h, 0B9h, 0BCh, 0BFh, 0C1h, 0C4h
.db 0C7h, 0C9h, 0CCh, 0CEh, 0D1h, 0D3h, 0D5h, 0D8h
.db 0DAh, 0DCh, 0DEh, 0E0h, 0E2h, 0E4h, 0E6h, 0E8h
.db 0EAh, 0ECh, 0EDh, 0EFh, 0F0h, 0F2h, 0F3h, 0F5h
.db 0F6h, 0F7h, 0F8h, 0F9h, 0FAh, 0FBh, 0FCh, 0FCh
.db 0FDh, 0FEh, 0FEh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
.db 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FEh, 0FEh
.db 0FDh, 0FCh, 0FCh, 0FBh, 0FAh, 0F9h, 0F8h, 0F7h
.db 0F6h, 0F5h, 0F3h, 0F2h, 0F0h, 0EFh, 0EDh, 0ECh
.db 0EAh, 0E8h, 0E6h, 0E4h, 0E2h, 0E0h, 0DEh, 0DCh
.db 0DAh, 0D8h, 0D5h, 0D3h, 0D1h, 0CEh, 0CCh, 0C9h
.db 0C7h, 0C4h, 0C1h, 0BFh, 0BCh, 0B9h, 0B6h, 0B3h
.db 0B0h, 0AEh, 0ABh, 0A8h, 0A5h, 0A2h, 09Fh, 09Ch
.db 098h, 095h, 092h, 08Fh, 08Ch, 089h, 086h, 083h
.db 080h, 07Ch, 079h, 076h, 073h, 070h, 06Dh, 06Ah
.db 067h, 063h, 060h, 05Dh, 05Ah, 057h, 054h, 051h
.db 04Fh, 04Ch, 049h, 046h, 043h, 040h, 03Eh, 03Bh
.db 038h, 036h, 033h, 031h, 02Eh, 02Ch, 02Ah, 027h
.db 025h, 023h, 021h, 01Fh, 01Dh, 01Bh, 019h, 017h
.db 015h, 013h, 012h, 010h, 00Fh, 00Dh, 00Ch, 00Ah
.db 009h, 008h, 007h, 006h, 005h, 004h, 003h, 003h
.db 002h, 001h, 001h, 000h, 000h, 000h, 000h, 000h
.db 000h, 000h, 000h, 000h, 000h, 000h, 001h, 001h
.db 002h, 003h, 003h, 004h, 005h, 006h, 007h, 008h
.db 009h, 00Ah, 00Ch, 00Dh, 00Fh, 010h, 012h, 013h
.db 015h, 017h, 019h, 01Bh, 01Dh, 01Fh, 021h, 023h
.db 025h, 027h, 02Ah, 02Ch, 02Eh, 031h, 033h, 036h
.db 038h, 03Bh, 03Eh, 040h, 043h, 046h, 049h, 04Ch
.db 04Fh, 051h, 054h, 057h, 05Ah, 05Dh, 060h, 063h
.db 067h, 06Ah, 06Dh, 070h, 073h, 076h, 079h, 07Ch
