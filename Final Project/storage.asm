.equ HORY, 6000h			; location where horiz. ycor is stored
.equ HORX1, 6001h			; location where horiz. xcor (initial) ""
.equ HORX2, 6002h			; location where horiz. xcor (finish) ""
.equ HORSTEP, 6003h			; location where horiz. step size ""

.equ VERX, 6004h			; location where vert. xcor is stored
.equ VERY1, 6005h			; location where vert. ycor (initial) ""
.equ VERY2, 6006h			; location where vert. ycor (finish) ""
.equ VERSTEP, 6007h			; location where vert. step size ""

draw_point_test:
	mov a, #40h
	mov b, #99h
	lcall draw_point
	sjmp draw_point_test
	
draw_square_test:
	mov a, #80h
	mov b, #40h
	lcall draw_square
	
	mov a, #92h
	mov b, #40h
	lcall draw_square
	
	ret

top_wall_test:
	mov dptr, #HORY
	mov a, #0FFh
	movx @dptr, a
	
	mov dptr, #HORX1
	mov a, #00h
	movx @dptr, a
	
	mov dptr, #HORX2
	mov a, #0FFh
	movx @dptr, a
	
	mov dptr, #HORSTEP
	mov a, #6h
	movx @dptr, a
	
	lcall draw_horizontal_line
	ret
	
bottom_wall_test:
	mov dptr, #HORY
	mov a, #00h
	movx @dptr, a
	
	mov dptr, #HORX1
	mov a, #00h
	movx @dptr, a
	
	mov dptr, #HORX2
	mov a, #0FFh
	movx @dptr, a
	
	mov dptr, #HORSTEP
	mov a, #6h
	movx @dptr, a
	
	lcall draw_horizontal_line
	ret
	
;================================================================
; push_reg - this routine looks at the value in the acc
; TODO
;===============================================================


;===================================================================
; draw_vertical_line - this routine draws a vertical line,
;		the x coordinate is specificed at memory location #VERX
;		the start y coordinate is specified at memory location #VERY1
;		the end y coordinate is specified at memory location #VERY2
;		the step size is specified at memory location #VERSTEP
; modifies: acc, dptr
;====================================================================	
draw_vertical_line:
	mov dptr, #VERX
	movx a, @dptr
	mov r0, a
	mov dptr, #VERY1
	movx a, @dptr
	mov r1, a
	mov dptr, #VERY2
	movx a, @dptr
	mov r2, a
	mov dptr, #VERSTEP
	movx a, @dptr
	mov r3, a
	
	clr c
	mov a, r2
	subb a, r1				; calculate Delta y
	mov b, r3
	div ab					; calculate num steps
	inc a					; add 1
	mov r2, a				; r2 now stores num points
	
	mov a, r0
	mov b, r1
	lcall draw_point					; load up the initial point
	
	mov dptr, #YDAC
	mov a, r1
vert_line_loop:
	djnz r2, vert_line_loop_cont
	ret
vert_line_loop_cont:
	add a, r3
	movx @dptr, a
	sjmp vert_line_loop

;================================================================
; draw_square - this routine draws a square with the bottom-left
; 		corner at coordinates (acc,b).  The number of steps, and
;		the size of those steps is represented by the constants
;		SQUARESTEPSIZE and NUMSQUARESTEPS
;===============================================================
draw_square:
	clr c
	mov r0, a					; lower left X
	mov r1, b					; lower left Y
	mov r4, b					; r4 stores dynamic ycor
	lcall draw_point			; draw lower left corner
	
	mov a, r0					; X_0 is in acc
	mov r2, #NUMSQUARESTEPS		; x direction counter
	mov r3, #NUMSQUARESTEPS		; y direction counter
	mov dptr, #XDAC
	
draw_square_loop_right:
	djnz r2, continue_right
	sjmp up_a_level_right
continue_right:
	add a, #SQUARESTEPSIZE
	movx @dptr, a
	sjmp draw_square_loop_right
up_a_level_right:
	djnz r3, up_a_level_right_cont
	sjmp draw_square_finish
up_a_level_right_cont:
	mov dptr, #YDAC
	mov r7, a						; save acc
	mov a, r4						; grab current ycor
	add a, #SQUARESTEPSIZE
	mov r4, a
	movx @dptr, a
	mov dptr, #XDAC					; put dptr back to XDAC
	mov r2, #NUMSQUARESTEPS			; restart x-direction count
	mov a, r7						; restore acc value w/ current xcor
	sjmp draw_square_loop_left
draw_square_loop_left:
	djnz r2, continue_left
	sjmp up_a_level_left
continue_left:
	subb a, #SQUARESTEPSIZE
	movx @dptr, a					; push new x value
	sjmp draw_square_loop_left
up_a_level_left:
	djnz r3, up_a_level_left_cont
	sjmp draw_square_finish
up_a_level_left_cont:
	mov dptr, #YDAC
	mov r7, a						; save acc
	mov a, r4						; grab current y cor
	add a, #SQUARESTEPSIZE
	mov r4, a
	movx @dptr, a
	mov dptr, #XDAC
	mov r2, #NUMSQUARESTEPS
	mov a, r7
	sjmp draw_square_loop_right
draw_square_finish:
	ret
	
draw_static_board_test:
	lcall clear_block_table

	mov dptr, #BLOCKTABLE
	mov a, #01h
	movx @dptr, a
	
	inc dptr
	inc dptr
	movx @dptr, a
	
	inc dptr
	inc dptr
	movx @dptr, a
	
	lcall draw_static_board
	
	ret
	
;TODO write spec	
ask_for_next_block:
	setb rs0
	setb rs1
	jnb ri, no_chr			; no character received
	mov a, sbuf
	anl a, #7fh
	clr ri
	;lcall sndchr			; send the received character back UNCOMMENT IF NEEDED
	cjne a, #30h, test_not_zero
	mov a, r0
	mov dptr, #BLOCKTABLE
	lcall add_acc_to_dptr		; data pointer points to correct spot
	mov a, #00h
	movx @dptr, a				; indicate block is there
	inc r0					; user said 0, increment r0
	sjmp ask_more
test_not_zero:
	cjne a, #31h, test_not_one
	mov a, r0
	mov dptr, #BLOCKTABLE
	lcall add_acc_to_dptr		; data pointer points to correct spot
	mov a, #01h
	movx @dptr, a				; indicate block is there
	inc r0
	sjmp ask_more
test_not_one:
	cjne a, #71h, no_chr		; unrecognized chr
	ret							; ret with acc = 71h
no_chr:
ask_more:
	mov a, #NUMBLOCKX
	mov b, #NUMBLOCKY
	mul ab
	dec a
	mov b, a					; b holds max index
	mov a, r0					; acc holds current index
	clr c
	subb a, b					; overflow means cur index was small enough!
	jc ask_more_cont 			; jump if overflow => no wrap around
	mov r0, #00h				; if wrap around, r0:=0
ask_more_cont:		
	mov a, #00h					; indicate we're not done yet!
	ret
	
test_isr:
	mov th0, #QUICK_CONST			; reset counter for roughly 56Hz
	mov dptr, #SETUPMODE
	movx a, @dptr			; a=1 if setup, 0 if test-run
	cjne a, #00h, go_to_setup		; setup if not 0
	ljmp get_command_isr
go_to_setup:
	ljmp setup_isr
	
	testmain:
	lcall clear_block_table
	mov dptr, #SETUPMODE
	mov a, #01h				; setup mode
	movx @dptr, a
	setb rs0
	setb rs1
	mov r0, #00h			; initial block is 0th
	lcall set_up_sfr
	mov a, #00h				; clear acc
testmainloop:
	cjne a, #071h, testmainloop
done_with_setup:
	mov th0, #QUICK_CONST			; full 256 counter
	mov dptr, #SETUPMODE
	mov a, #00h						; test-run mode
	movx @dptr, a
lastloop:
	sjmp lastloop
	
	.org 200h
setup_isr:
	lcall ask_for_next_block
	cjne a, #00h, exit_setup_mode
	lcall refresh_display
	clr acc
	reti
exit_setup_mode:
	reti
	