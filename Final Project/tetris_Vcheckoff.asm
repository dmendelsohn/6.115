;================= hardware constants ==============================
.equ XDAC, 0FE40h			; memory-mapped DAC address
.equ YDAC, 0FE50h			; memory-mapped DAC address

;================== memory constants =============================
;psuedo-registers
.equ CURBLOCK_0, 6000h		; data for the current block starts here
.equ CURBLOCK_1, 6001h
.equ CURBLOCK_2, 6002h
.equ CURBLOCK_3, 6003h
.equ CURBLOCK_TYPE, 6004h	; memory location for the current block type
.equ CURBLOCK_POS, 6005h		; memory location for the current block orientation
.equ TEMPBLOCK_0, 6010h		; for temporary positions, need to be checked
.equ TEMPBLOCK_1, 6011h
.equ TEMPBLOCK_2, 6012h
.equ TEMPBLOCK_3, 6013h

.equ CURSCORE_HIGH, 6020h		; current score
.equ CURSCORE_LOW, 6021h
.equ CURLINES, 6022h		; current number of lines eliminated
.equ CURLEVEL, 6023h		; current level
.equ BLOCK_SEQUENCE_COUNTER, 6024h	; counts our position in the block sequence

.equ DPL_STORE, 6030h		; saves a dpl byte
.equ DPH_STORE, 6031h		; saves a dph byte

.equ LONG_TIME_COUNTER, 6040h	; saves the long count (for timestep isr)

;data tables
.equ ROTATION_TABLE, 6200h	; rotation look up table starts here
.equ LEFT_TABLE, 6300h		; left move vector is here
.equ RIGHT_TABLE, 6310h		; right move vector is here
.equ DOWN_TABLE, 6320h		; down move vector
.equ UP_TABLE, 6330h		; up move vector, mostly for testing purposes
.equ INIT_BLOCK_POS, 6500h	; lookup table for initial positions
.equ BLOCK_TABLE, 7000h		; block data starts here
.equ BLOCK_SEQUENCE, 7100h	; block sequence data starts here

;================== display constants ===============================
.equ SQUARESTEPSIZE, 02h	; square step size is 3
.equ NUMSQUARESTEPS, 06h	; 6 steps per side of square
.equ BLOCKSIZE, 12h			; width allocated for one block

;=================== game constants ===================================
.equ NUMBLOCKX, 10d			; 10 blocks wide
.equ NUMBLOCKY, 14d			; 14 blocks high
.equ MAX_ROW, 12d			; only 12 rows are "in bounds"
.equ LINES_PER_LEVEL, 10d	; 10 lines per level
.equ WINNING_LEVEL, 6d			; 5 levels
.equ BLOCK_SEQ_SIZE, 28d	; repeats every 28 blocks

;=================== timing constants =================================
.equ SHORT_TIME_CONST, 0D0h		; this goes into th0 to reload in mode 1
.equ LONG_TIME_CONST, 60d		; every nth command isr, we do a timestep

;===================== internal constants ===============================
.equ NULL_BLOCK, 00h

;================= interface commands with PSoC =================
.equ RIGHT_BYTE, 64h		; d
.equ LEFT_BYTE, 61h			; a
.equ ROTATE_BYTE, 77h		; w
;.equ DROP_BYTE, 73h		; s
.equ DOWN_BYTE, 73h			; s


;===================== PROGRAM BODY ============================
.org 0000h
ljmp main

;====================== ISR STUFF ================================
.org 0Bh
ljmp get_command_isr			; run the isr

.org 100h
get_command_isr:
	mov th0, #SHORT_TIME_CONST			; reset counter for roughly 60Hz
	lcall check_command					; poll for a user command, and execute it
	mov dptr, #LONG_TIME_COUNTER
	movx a, @dptr					; what's the current long count?
	cjne a, #00h, get_command_isr_cont		; no need to do tetris time-step
	mov a, #LONG_TIME_CONST
	movx @dptr, a					; reset the long count
	lcall do_timestep_increment		; do tetris time-step
	sjmp get_command_isr_finish		; continue onward
get_command_isr_cont:
	dec a
	movx @dptr, a					; load new long count
get_command_isr_finish:
	lcall refresh_display
	reti

;================================================================
; dummy - this is for testing purposes
;=================================================================
dummy:
	mov ie, #00h	; DEBUG
	sjmp dummy
	
;==================================================================
; dummy_display - this is for testing purposes
;=================================================================
dummy_display:
	mov ie, #00h
	mov P1, #05h
	lcall refresh_display
	sjmp dummy_display

;================INITIALIZATION STUFF ==============================
.org 1000h
main:
	mov sp, #20h				; we put the sp high enough (away from acc, b, etc)
	mov dptr, #LONG_TIME_COUNTER
	mov a, #LONG_TIME_CONST
	movx @dptr, a				; set up the long count timing constant
	lcall set_up_game			; set up game variables
	lcall set_up_sfr			; set up sfr for serial and timer interrupts
loop:
	sjmp loop
	
;==============================================================
; set_up_game - this routine sets the number of lines, the score,
;		the level, and clears the board	
;==============================================================
set_up_game:
	lcall clear_block_table						; clear static blocks
	lcall clear_curblock						; clear current block
	lcall clear_tempblock						; clear other memory
	mov a, #00h
	mov dptr, #CURSCORE_HIGH
	movx @dptr, a
	mov dptr, #CURSCORE_LOW
	movx @dptr, a								; clear score
	mov dptr, #CURLEVEL
	movx @dptr, a								; clear level
	mov dptr, #CURLINES
	movx @dptr, a								; clear line count
	mov dptr, #BLOCK_SEQUENCE_COUNTER
	movx @dptr, a								; clear block sequence counter
	ret

;==============================================================
; set_up_sfr - this routine sets up the serial port and another timer
;		the other timer triggers an interrupt at ~60Hz
;============================================================== 
set_up_sfr:
	mov tmod, #0A1h			; timer 1 in mode 2, timer 0 in mode 1
	mov scon, #50h			; set up serial port
	mov th1, #0FDh			; set serial control reg for 8 bit data and mode 1
	mov ie, #82h			; timer 0 interrupts only
	mov th0, #SHORT_TIME_CONST	; full 256 count interrupt timer
	setb tr0				; run it
	setb tr1				; run it
	ret
	
;================================================================
; clear_block_table - clears all block table values to 0
;===============================================================
clear_block_table:
	mov dptr, #BLOCK_TABLE	; point to block table
	mov a, #NUMBLOCKX
	mov b, #NUMBLOCKY
	mul ab					; assuming ab < 256, a now holds num spaces
	mov r0, a				; r0 now holds num spaces
clear_block_table_loop:
	dec r0
	mov a, #00h
	movx @dptr, a			; clear current data pointer spot
	inc dptr
	cjne r0, #00h, clear_block_table_loop		; continue clearing data
	ret
	
;======================================================================
; clear_curblock - clears the curblock memory
;======================================================================
clear_curblock:
	mov a, #00h
	mov dptr, #CURBLOCK_0
	movx @dptr, a					; clear
	mov dptr, #CURBLOCK_1
	movx @dptr, a					; clear
	mov dptr, #CURBLOCK_2
	movx @dptr, a					; clear
	mov dptr, #CURBLOCK_3
	movx @dptr, a					; clear
	mov dptr, #CURBLOCK_TYPE
	movx @dptr, a					; clear to null type
	mov dptr, #CURBLOCK_POS
	movx @dptr, a					; clear to position 0
	ret

;======================================================================
; clear_tempblock - clears the tempblock memory
;======================================================================
clear_tempblock:
	mov a, #00h
	mov dptr, #TEMPBLOCK_0
	movx @dptr, a					; clear
	mov dptr, #TEMPBLOCK_1
	movx @dptr, a					; clear
	mov dptr, #TEMPBLOCK_2
	movx @dptr, a					; clear
	mov dptr, #TEMPBLOCK_3
	movx @dptr, a					; clear
	ret

;======================== HIGH LEVEL GAME CODE========================

;====================================================================
; do_timestep_increment - driver function that makes the timestep happen.
;		if there is no CURBLOCK and the game is active, it creates a random
;		block in position 0, centered at the top of the screen.  If there is
;		a CURBLOCK, it will move it down.  If it cannot move down, it will lock it,
;		delete up to 4 lines as necessary, and increment score and level as
;		necessary.
;======================================================================
do_timestep_increment:
	setb rs1
	clr rs0						; we use REG BANK 2 for all related methods
	mov dptr, #CURBLOCK_TYPE
	movx a, @dptr				; get the current type
	cjne a, #NULL_BLOCK, do_gravity		; we have a current bloc, do gravity	
	lcall get_next_block_type		; get a next type between 0 and 6 inclusive
	lcall init_curblock			; build the block
	ret
do_gravity:
	lcall do_down				; raises error flag if problem
	cjne a, #00h, need_to_lock	; error means we can't move down, need to lock block
	ret							; we're done if no error
need_to_lock:
	lcall lock_block			; lock the block in
	mov r7, #00h				; lines deleted counter
delete_lines_as_needed_loop:
	lcall is_line_ready			; see if line is ready
	cjne a, #01h, no_lines_to_delete	; no more lines to delete
	lcall delete_line			; if we get here, we have a line to delete
	inc r7						; increment our lines deleted counter
	sjmp delete_lines_as_needed_loop	; continue deleting lines
no_lines_to_delete:
	mov a, r7					; acc holds number of lines deleted
	;lcall raise_score			; score is incremented according to acc
	mov a, r7
	;lcall increment_line_count	; line count is incremented by acc
	;lcall increment_level_if_needed	; level to reflect line count, no input var
	ret
	
;=====================================================================
; get_next_block_type - this routine grabs the next type in the table,
;		making sure to loop around.  Returns type num in acc
;====================================================================
get_next_block_type:
	mov dptr, #BLOCK_SEQUENCE_COUNTER
	movx a, @dptr		; get our position in the sequence
	cjne a, #BLOCK_SEQ_SIZE, get_type_cont
	mov a, #00h					; start the sequence over
get_type_cont:					; at this point acc holds index to get
	mov b, a					; store it in b
	mov dptr, #BLOCK_SEQUENCE
	movc a, @a+dptr				; grab type
	xch	a,b						; sequence count is in a, cur-type is in b
	inc a
	mov dptr, #BLOCK_SEQUENCE_COUNTER
	movx @dptr, a				; push incremented value
	mov a, b					; type into acc
	ret
	
;============================================================
; init_curblock - this routine sets up the current block memory
;		for a new current block.  It takes a block type specified in a,
;		puts it in position 0, and sets up the location memory accordingly
;=============================================================
init_curblock:
	mov dptr, #CURBLOCK_TYPE
	movx @dptr, a					; set the type
	mov b, #8
	mul ab
	mov r4, a						; store table offset for init pos in r4
	mov dptr, #CURBLOCK_POS			; point to position reg
	mov a, #00h
	movx @dptr, a					; set initial position to 0
		
	; now we set up the position registers
	lcall get_ref_index				; reference index is in acc
	mov r3, a						; store ref index in r3
	mov r2, #00h					; store loop counter in r2
init_curblock_loop:
	cjne r2, #04h, init_curblock_cont		; we're not done
	ret										; we're done	
init_curblock_cont:
	mov a, r3
	mov r0, a						; load r0 with reference index
	mov dptr, #INIT_BLOCK_POS
	mov a, r4						; put offset in a
	movc a, @a+dptr					; load value into a
	inc r4
	mov b, a						; b now holds the x offset for first block piece
	mov a, r4						; put offset in a
	movc a, @a+dptr
	inc r4
	xch a, b						; a holds x offset, b holds y offset
	lcall calc_index_from_offset
	;cjne b, #00h, 				; error SHOULD never happen in init_curblock
	mov dptr, #CURBLOCK_0
	xch a, r2						; acc holds loop counter, r2 holds index
	lcall add_acc_to_dptr			; dptr now points to the right subblock
	xch a, r2						; acc holds index, r2 holds loop counter
	inc r2							; increment loop counter
	movx @dptr, a					; put block index data into memory
	sjmp init_curblock_loop
	
;============================================================
; get_ref_index: sets the reference index for initializing new blocks
;=============================================================
get_ref_index:
	mov a, #NUMBLOCKX
	mov b, #NUMBLOCKY
	mul ab
	dec a				; a is highest space index now
	mov r0, a			; store in r0
	mov a, #NUMBLOCKX
	mov b, #2
	div ab				; take X/2
	xch a, r0			; acc now holds highest index, r0 holds X/2
	clr c
	subb a, r0			; a now holds reference index in top row
	ret
	
;====================================================================
; lock_block - takes the block in the CURBLOCK and finalizes them by
;			editing the block table.  Clears the CURBLOCK to #00h in the
;			index registers, #07h (null type) in the type register, and #00h
;			in the position register
;===================================================================
lock_block:
	mov dptr, #CURBLOCK_0
	movx a, @dptr						; grab first index
	lcall lock_single_block
	mov a, #00h
	mov dptr, #CURBLOCK_0
	movx @dptr, a						; reset CURBLOCK
	
	mov dptr, #CURBLOCK_1
	movx a, @dptr						; grab next index
	lcall lock_single_block
	mov dptr, #CURBLOCK_1
	movx @dptr, a						; reset CURBLOCK
	
	mov dptr, #CURBLOCK_2
	movx a, @dptr						; grab next index
	lcall lock_single_block
	mov dptr, #CURBLOCK_2
	movx @dptr, a						; reset CURBLOCK
	
	mov dptr, #CURBLOCK_3
	movx a, @dptr						; grab last index
	lcall lock_single_block
	mov dptr, #CURBLOCK_3
	movx @dptr, a						; reset CURBLOCK
	
	mov dptr, #CURBLOCK_TYPE
	mov a, #NULL_BLOCK
	movx @dptr, a						; reset type
	
	mov dptr, #CURBLOCK_POS
	mov a, #00h
	movx @dptr, a						; reset position
	ret

;==================================================================
; lock_single_block - helper function for lock_block whereby
;		we fill in block in a given space index (specified in acc)
;		also, if block is too high, you lose the game.  Specifically,
;		the index must be strictly less than NUMBLOCKX*MAX_ROW
;==================================================================
lock_single_block:
	mov r0, a							; store index in r0
	mov dptr, #BLOCK_TABLE
	lcall add_acc_to_dptr				; dptr points to right spot
	mov a, #01h							; spot is now full
	movx @dptr, a						; push the change to memory
	mov a, #NUMBLOCKX
	mov b, #MAX_ROW
	mul ab								; multiply
	xch a, r0							; our index is in a, too high index is in r0
	clr c
	subb a, r0
	jnc lock_too_high					; locked block is too high
	ret									; if overflow, we're ok, didn't lose
lock_too_high:
	ljmp you_lose
	
;==================================================================
; is_line_ready - boolean function that checks if the bottom line of
;		the blocktable is full.  If so, return #01h in the acc, otherwise
;		return #00h in the acc.  Uses r0, assumes long-scale reg bank, but not crucial
;===================================================================
is_line_ready:
	mov r0, #NUMBLOCKX					; initialize counter
is_line_ready_loop:
	cjne r0, #00h, is_line_ready_cont		; check if we're done
	sjmp line_is_ready					; finish the function
is_line_ready_cont:
	dec r0
	mov a, r0
	mov dptr, #BLOCK_TABLE
	movc a, @a+dptr						; load space value
	cjne a, #01h, line_not_ready		; not full spot implies not ready
	sjmp is_line_ready_loop
line_not_ready:
	mov a, #00h							; return false
	ret
line_is_ready:
	mov a, #01h							; return true
	ret

;=================================================================
; delete_line - deletes entire full line of blocks, effective strategy
;		is to delete top element from each column
;================================================================
delete_line:
	mov r1, #NUMBLOCKX			; loop counter, don't use r0 cause inner helper needs it
delete_line_loop:
	cjne r1, #00h, delete_line_loop_cont	; check if we are done
	sjmp delete_line_finish					; we're done
delete_line_loop_cont:
	dec r1
	mov a, r1								; current column number in acc
	lcall delete_top_element_in_col			; delete top element in that column
	cjne a, #01h, delete_line_loop			; no error, so we continue
	ret										; error in helper, so pass it on
delete_line_finish:
	mov a, #00h								; no error in helper, no error flag
	ret	
	
;=================================================================
; delete_top_element_in_col - takes column value in acc, and sets
;		the top filled space to empty.  This is a helper method for
;		delete_line
;=================================================================	
delete_top_element_in_col:	; specified in acc
	mov r0, a					;save col number in r0
	mov a, #NUMBLOCKY
	dec a						; y-1
	mov b, #NUMBLOCKX			; x
	mul ab
	mov b, r0					; our col number is in now in b
	add a, b					; a is now top index in desired column
	mov b, a					; store index in b
	mov r0, #NUMBLOCKY			; loop counter (maximum # loops)
delete_top_element_loop:
	cjne r0, #00h, delete_top_elt_cont
	sjmp no_top_element			; there is no top element
delete_top_elt_cont:			; keep looking
	mov dptr, #BLOCK_TABLE
	mov a, b					; grab updated top unsearched index in col
	movc a, @a+dptr				; grab value
	cjne a, #00h, got_top_element		; b holds index of thing to be deleted
	mov a, b					; no dice, we need to move down in our search
	clr c
	subb a, #NUMBLOCKX
	mov b, a					; b holds updated top unsearched index in col
	dec r0						; decrement loop counter
	sjmp delete_top_element_loop
no_top_element:
	mov a, #01h					; error flag
	ret
got_top_element:
	mov a, b
	mov dptr, #BLOCK_TABLE
	lcall add_acc_to_dptr		; dptr now points where we want
	mov a, #00h					; empty val
	movx @dptr, a				; delete block
	mov a, #00h					; no error flag
	ret

;=============================================================================
; raise_score - takes in num lines just deleted from acc, multiplies
;		it by the current level number, and adds it to the current score
;=============================================================================
raise_score:
	mov b, a					; num lines in b
	mov dptr, #CURLINES
	movx a, @dptr				; get current number of lines
	mul ab						; if < 256, acc now holds score diff
	lcall add_acc_to_score
	ret
	
;============================================================================
; add_acc_to_score - does what it says
;============================================================================
add_acc_to_score:
	clr c
	mov b, a					; store acc in b
	mov dptr, #CURSCORE_LOW		;
	movx a, @dptr				; grab low byte of score
	add a, b					; add amount
	movx @dptr, a				; put it back
	jc incr_high_score_byte
	ret
incr_high_score_byte:
	mov dptr, #CURSCORE_HIGH
	movx a, @dptr				; grab high byte
	inc a						; increment it
	movx @dptr, a				; put it back
	ret
	
increment_line_count:
	mov b, a					; store num lines in b
	mov dptr, #CURLINES
	movx a, @dptr				; grap current number of lines
	add a, b					; add the appropriate amount
	movx @dptr, a				; put it back
	ret

;===========================================================================
; increment_level_if_needed - level is floor of line count / LINES_PER_LEVEL
;===========================================================================
increment_level_if_needed:
	mov dptr, #CURLINES
	movx a, @dptr
	mov b, #LINES_PER_LEVEL
	div ab				; so now a holds what the current level should be
	mov b, a			; acc and b hold should_be_curlevel
	mov dptr, #CURLEVEL
	movx a, @dptr		; check what it currently is
	xch a, b			; should-be in acc, what it is in b
	clr c
	subb a, b			; delta between the two in a
	cjne a, #00h, increment_level
	ret					; no level incrementing
increment_level:
	add a, b			; add back b to get what level should be
	movx @dptr, a		; update current level
	cjne a, #WINNING_LEVEL, increment_level_cont		; just increment, game not over
	ljmp you_win
increment_level_cont:
	;;TODO, do stuff with timing here
	ret

;===========================================================================
; you_win - this routine lights up P1 and loops (while displaying) forever
;===========================================================================
you_win:
	mov ie, #00h		; turn off interrupts
	mov P1, #0C1h		; C1 onto P1
	lcall refresh_display
	sjmp you_win		; loop forever
	
;===========================================================================
; you_lose - this routine lights up P1 and loops (while displaying) forever
;===========================================================================
you_lose:
	mov ie, #00h		; turn off interrupts
	mov P1, #0C0h		; C0 onto P1
	lcall refresh_display
	sjmp you_lose		; loop forever
	
;================= LOW-LEVEL GAME CODE =============================

;==================================================================
; check_command - checks to see if a value is ready from the serial port
;		if so, it puts that value in the acc and calls do_move
;===================================================================
check_command:
	jnb ri, no_command	; if no character received, nothing to do
	mov a, sbuf		; get character and put it in the accumulator
	anl a, #7fh		; mask off 8th bit
	clr ri			; clear serial "receive status" flag
	mov P1, a	; DEBUGGING
	;;ljmp dummy
	;;lcall sndchr	; repeat it back to terminal
	lcall do_move	; perform the specified move
	ret
no_command:
	ret
	
;===================================================================
; sndchr - sends the byte in the accumulator to the serial port
;		does not alter acc
;==================================================================
sndchr:
	clr scon.1		; clear the ti complete flag
	mov sbuf, a		; move a character from the acc to the sbuf
	txloop:
		jnb scon.1, txloop	; wait till chr is sent
	ret

;===================================================================
; do_move - alters the data in the CURBLOCK locations appropriately,
;		uses acc to determine which command is used.  The commands
;		supported are:
;			LEFT: 'a' <- ASCII encoding
;			RIGHT: 'd'
;			ROTATE: 'w'
;			HARD DROP: 's'
; USES REG BANK 1 (the action register bank)
;====================================================================
do_move:
	setb RS1
	setb RS0							; select reg bank 3
	cjne a, #LEFT_BYTE, not_left		; check for left command
	lcall do_left
	sjmp finish_move
not_left:
	cjne a, #RIGHT_BYTE, not_right		; check for right command
	lcall do_right
	sjmp finish_move
not_right:
	cjne a, #ROTATE_BYTE, not_rotate	; check for rotate command
	lcall do_rotation
	sjmp finish_move
not_rotate:
	cjne a, #DOWN_BYTE, not_down		; check for down command
	lcall do_down
	sjmp finish_move
not_down:
finish_move:
	ret
		
;=================================================================
; do_rotation - alters the data in the CURBLOCK locations appropriately
;		to reflect a single clockwise rotation according to the SRS
;		rotation protocol.  If the rotation is not possible, the 
;		CURBLOCK memory is left unchanged
;================================================================
do_rotation:
	;point to the right transition bytes
	mov dptr, #CURBLOCK_TYPE
	movx a, @dptr				; get current block type
	mov b, #20h					; 32
	mul ab
	mov r0, a
	mov dptr, #CURBLOCK_POS	
	movx a, @dptr				; get current block orientation id
	mov b, #08h					; 8
	mul ab
	add a, r0					; acc now holds offset data block for this rotation
	mov dptr, #ROTATION_TABLE
	lcall add_acc_to_dptr		; dptr now holds the spot we want
	
	;finish the rotation
	lcall build_temp_block		; store in memory our 4 desired block locations
	cjne a, #00h, cant_move		; cannot move if out of bounds flag is raised
	lcall check_temp_block		; confirm that they are empty
	cjne a, #01, cant_move		; check came back false, can't move
	lcall move_temp_block		; perform the move
	lcall increment_block_orientation
	mov a, #00h					; no error
	ret
	
;=====================================================================
; increment_block_orientation - increment block orientation (mod 4)
;====================================================================
increment_block_orientation:
	mov dptr, #CURBLOCK_POS			; point to orientation location
	movx a, @dptr					; load value into acc
	inc a
	cjne a, #04h, finish_increment	; we're done!
	mov a, #00h						; 4 == 0 (mod 4)
finish_increment:
	movx @dptr, a					; load value back into orientation loc.
	ret

;=================================================================
; do_left - alters the data in the CURBLOCK locations appropriately
;		to reflect a single shift left.  If the move is not possible, the 
;		CURBLOCK memory is left unchanged
;================================================================
do_left:
	mov dptr, #LEFT_TABLE
	lcall build_temp_block		; store in memory our 4 desired block locations
	cjne a, #00h, cant_move		; cannot move if out of bounds flag is raised
	lcall check_temp_block		; confirm that they are empty
	cjne a, #01, cant_move		; check came back false, can't move
	lcall move_temp_block		; perform the move
	mov a, #00h					; no error
	ret
;=================================================================
; do_right - alters the data in the CURBLOCK locations appropriately
;		to reflect a single shift left.  If the move is not possible, the 
;		CURBLOCK memory is left unchanged
;================================================================
do_right:
	mov dptr, #RIGHT_TABLE
	lcall build_temp_block		; store in memory our 4 desired block locations
	cjne a, #00h, cant_move		; cannot move if out of bounds flag is raised
	lcall check_temp_block		; confirm that they are empty
	cjne a, #01, cant_move		; check came back false, can't move
	lcall move_temp_block		; perform the move
	mov a, #00h					; no error
	ret
	
;=================================================================
; do_up - alters the data in the CURBLOCK locations appropriately
;		to reflect a single shift up.  If the move is not possible, the 
;		CURBLOCK memory is left unchanged.  This is basically used only for testing
;================================================================
do_up:
	mov dptr, #UP_TABLE
	lcall build_temp_block		; store in memory our 4 desired block locations
	cjne a, #00h, cant_move		; cannot move if out of bounds flag is raised
	lcall check_temp_block		; confirm that they are empty
	cjne a, #01, cant_move		; check came back false, can't move
	lcall move_temp_block		; perform the move
	mov a, #00h					; no error
	ret
	
;=================================================================
; do_down - alters the data in the CURBLOCK locations appropriately
;		to reflect a single shift down.  If the move is not possible, the 
;		CURBLOCK memory is left unchanged
;================================================================
do_down:
	mov dptr, #DOWN_TABLE
	lcall build_temp_block		; store in memory our 4 desired block locations
	cjne a, #00h, cant_move		; cannot move if out of bounds flag is raised
	lcall check_temp_block		; confirm that they are empty
	cjne a, #01, cant_move		; check came back false, can't move
	lcall move_temp_block		; perform the move
	mov a, #00h					; no error
	ret

;====================================================================
; cant_move - called by the other move functions if the move cannot
;		be performed
;====================================================================
cant_move:	; we can augment subroutine this to make a sound or something
	mov a, #01h					; error flag
	ret
	
;===================================================================
; build_temp_block: uses the 8 bytes at the dptr, together with the
;		values in CURBLOCK to get 4 TEMPBLOCK values.
;		returns #01h in the acc if there is an out_of_bounds_error
;		otherwise it returns #00h in the acc
;==================================================================
build_temp_block:
	lcall save_dptr				; save the current dptr
	mov r2, #00h				; r2 is our loop counter
build_temp_block_loop:
	cjne r2, #04h, build_temp_block_cont	; not done yet
	mov a, #00h					; we are done!  without out of bounds error
	ret
build_temp_block_cont:
	mov dptr, #CURBLOCK_0
	mov a, r2
	movc a, @a+dptr				; grab current block index
	mov r0, a					; store in r0
	mov a, r2
	add a, r2					; acc holds 2*r1 (2*loop#), it's our offset from dptr
	mov r3, a					; save it in r3 for a second
	lcall retrieve_dptr
	mov a, r3					; put offset back in acc
	movc a, @a+dptr				; grab X offset value
	mov b, a					; put it in b
	inc dptr
	mov a, r3					; put offset back in acc
	movc a, @a+dptr				; grab first Y offset value
	clr c
	dec dpl
	jc also_decrement_dph		; just decrementing the dptr
	sjmp build_temp_block_cont_2		; otherwise we're good
also_decrement_dph:
	dec dph
build_temp_block_cont_2:
	xch a, b					; X offset in acc, Y offset in b
	lcall calc_index_from_offset		; get the offset
	xch a, b
	cjne a, #00h, build_out_of_bounds	; invalid build if error flag is raised
	xch a, b
	mov r0, a					; put index in r0 for now
	mov dptr, #TEMPBLOCK_0
	mov a, r2					; which block number we're on
	lcall add_acc_to_dptr
	mov a, r0					; index is now in a
	movx @dptr, a				; load index value into memory
	inc r2						; increment loop counter
	sjmp build_temp_block_loop
build_out_of_bounds:
	mov a, #01h					; out of bounds error flag
	ret
	
;==================================================================
; check_temp_blocks - checks the 4 temporary block positions, and
;		ensures that those positions have no static blocks.  Returns
;		1 if all spots are available, 0 otherwise.  Return value in acc.
;==================================================================
check_temp_block:
	mov dptr, #TEMPBLOCK_0				; data pointer to first pos
	movx a, @dptr
	mov dptr, #BLOCK_TABLE
	movc a, @a+dptr
	cjne a, #00h, no_room				; jump if spot is taken
	mov dptr, #TEMPBLOCK_1				; data pointer to first pos
	movx a, @dptr
	mov dptr, #BLOCK_TABLE
	movc a, @a+dptr
	cjne a, #00h, no_room				; jump if spot is taken
	mov dptr, #TEMPBLOCK_2				; data pointer to first pos
	movx a, @dptr
	mov dptr, #BLOCK_TABLE
	movc a, @a+dptr
	cjne a, #00h, no_room				; jump if spot is taken
	mov dptr, #TEMPBLOCK_3				; data pointer to first pos
	movx a, @dptr
	mov dptr, #BLOCK_TABLE
	movc a, @a+dptr
	cjne a, #00h, no_room				; jump if spot is taken
yes_room:
	mov a, #01h							; confirm all spots are empty
	ret
no_room:
	mov a, #00h							; not all spots are empty
	ret

;==================================================================
; move_temp_block - takes the temp block and loads value into CURBLOCK
;==================================================================	
move_temp_block:
	mov dptr, #TEMPBLOCK_0
	movx a, @dptr
	mov dptr, #CURBLOCK_0
	movx @dptr, a
	mov dptr, #TEMPBLOCK_1
	movx a, @dptr
	mov dptr, #CURBLOCK_1
	movx @dptr, a
	mov dptr, #TEMPBLOCK_2
	movx a, @dptr
	mov dptr, #CURBLOCK_2
	movx @dptr, a
	mov dptr, #TEMPBLOCK_3
	movx a, @dptr
	mov dptr, #CURBLOCK_3
	movx @dptr, a
	ret

;=================================================================
; do_hard_drop - alters the data in the CURBLOCK locations appropriately
;		to reflect a hard drop.  The hard drop also locks the block in place,
;		triggering all actions that happen after locking
;================================================================
do_hard_drop:
	lcall get_drop_distance			; get the number of spaces the hard drop is
	lcall do_drop_distance			; uses the result of the last call
	lcall lock_block				; lock the block in place
	ret
	
get_drop_distance: ;TODO, if time to implement hard drop

do_drop_distance: ;TODO, if time to implement hard drop
	
;================= DISPLAY DRIVER FUNCTIONS ============================

;==========================================================
; refresh_display - this command draws the display again entirely
;		it uses register bank 0 (display mode)
;==========================================================
refresh_display:
	clr rs0
	clr rs1				; select reg bank 0
	lcall draw_static_board
	lcall draw_dynamic_block
	;; MORE TODO, walls, words, extras
	ret
	
;===============================================================
; draw_board - this routine draws the entire grid of blocks
;		based on their current state
; time = 12*(num spaces) + 211*(num occupied spaces)
;===============================================================
draw_static_board:
	mov a, #NUMBLOCKX
	mov b, #NUMBLOCKY
	mul ab					; assuming ab < 256, a now holds num spaces
	mov r2, a				; store num spaces in r2
draw_board_loop:
	dec r2
	mov a, r2				; load current space into acc
	mov dptr, #BLOCK_TABLE
	movc a, @a+dptr			; acc now holds data value for current block
	cjne a, #00h, draw_board_loop_yes		; if a is 1, draw
	sjmp draw_board_loop_finish
draw_board_loop_yes:
	mov a, r2							; current block index into acc
	lcall get_coord_from_index
	lcall draw_square
draw_board_loop_finish:
	cjne r2, #00, draw_board_loop		; keep drawing blocks
	ret

;===========================================================
; draw_dynamic_block - this command draws the dynamic block,
;		the location of which it gets from a fixed memory location
;===========================================================
draw_dynamic_block:
	;; TODO, maybe some cursor moving (purely aesthetic change)
	mov dptr, #CURBLOCK_TYPE
	movx a, @dptr
	cjne a, #NULL_BLOCK, draw_dynamic_block_cont	; check to make sure curblock not null
	ret					; don't draw anything if block is null

draw_dynamic_block_cont:
	mov dptr, #CURBLOCK_0			; first block
	movx a, @dptr					; get index of first block
	lcall get_coord_from_index		; but X and Y coords in a and b
	lcall draw_square				; use a and b values to render
	
	mov dptr, #CURBLOCK_1			; next block
	movx a, @dptr					; get index of block
	lcall get_coord_from_index		; but X and Y coords in a and b
	lcall draw_square				; use a and b values to render
	
	mov dptr, #CURBLOCK_2			; next block
	movx a, @dptr					; get index of block
	lcall get_coord_from_index		; but X and Y coords in a and b
	lcall draw_square				; use a and b values to render
	
	mov dptr, #CURBLOCK_3			; next block
	movx a, @dptr					; get index of block
	lcall get_coord_from_index		; but X and Y coords in a and b
	lcall draw_square				; use a and b values to render
	ret

;================================================================
; draw_square - this routine draws outline of square with the bottom-left
; 		corner at coordinates (acc,b).  The number of steps, and
;		the size of those steps is represented by the constants
;		SQUARESTEPSIZE and NUMSQUARESTEPS
;       requires 28*(NUMSQUARESTEPS)+18 machine cycles
;===============================================================
draw_square:
	;ljmp draw_point		; DEBUGGING
	clr c
	mov r0, a
	mov r1, b
	
	mov dptr, #XDAC
	movx @dptr, a
	mov dptr, #YDAC
	mov a, b
	movx @dptr, a
	
draw_square_bottom:
	mov a, r0							; a holds current X coordinate
	mov b, #NUMSQUARESTEPS				; b is our loop counter
	mov dptr, #XDAC						; point to xdac
draw_square_bottom_loop:
	djnz b, draw_square_bottom_cont
	mov r0, a							; save final x cor in r0
	sjmp draw_square_right				; now draw the right side
draw_square_bottom_cont:
	add a, #SQUARESTEPSIZE
	movx @dptr, a						; push new X value to DAC
	sjmp draw_square_bottom_loop
	
draw_square_right:
	mov a, r1							; a holds current Y coordinate
	mov b, #NUMSQUARESTEPS				; b is our loop counter
	mov dptr, #YDAC						; point to ydac
draw_square_right_loop:
	djnz b, draw_square_right_cont
	mov r1, a							; save final Y cor in r1
	sjmp draw_square_top				; now draw the top side
draw_square_right_cont:
	add a, #SQUARESTEPSIZE
	movx @dptr, a						; push new X value to DAC
	sjmp draw_square_right_loop
	
draw_square_top:
	mov a, r0							; a holds current X coordinate
	mov b, #NUMSQUARESTEPS				; b is our loop counter
	mov dptr, #XDAC						; point to xdac
draw_square_top_loop:
	djnz b, draw_square_top_cont
	sjmp draw_square_left				; now draw the left side
draw_square_top_cont:
	subb a, #SQUARESTEPSIZE
	movx @dptr, a						; push new X value to DAC
	sjmp draw_square_top_loop
	
draw_square_left:
	mov a, r1							; a holds current Y coordinate
	mov b, #NUMSQUARESTEPS				; b is our loop counter
	mov dptr, #YDAC						; point to ydac
draw_square_left_loop:
	djnz b, draw_square_left_cont
	ret									; we're done!
draw_square_left_cont:
	subb a, #SQUARESTEPSIZE
	movx @dptr, a						; push new X value to DAC
	sjmp draw_square_left_loop

;===========================================================
; draw_point - this routine outputs the value in acc to the xdac
;	and outputs the value in b to the ydac
; modifies: acc, dptr
;=============================================================
draw_point:
	mov dptr, #XDAC
	movx @dptr, a
	mov dptr, #YDAC
	mov a, b
	movx @dptr, a
	ret
	
;===============================================================
; get_coord_from_index - input (in acc) is index of block in
;			block table.  Output is x coord on screen (returned
;			in acc), y coord on screen (returned in b)
; time = 21
;===============================================================
get_coord_from_index:
	mov b, #NUMBLOCKX			; width of grid
	div ab						; a holds y-index, b holds x-index
	mov r0, b
	mov b, #BLOCKSIZE
	mul ab
	xch a, r0					; r0 now holds y-coordinate. acc: x-index
	mov b, #BLOCKSIZE
	mul ab						; acc now holds x-coordinate
	mov b, r0					; b now holds y-coordinate
	ret	
		
;=================  GENERIC UTILITY FUNCTIONS =========================

;=======================================================================
; calc_index_from_offset - this routine takes in a space index in r0,
;		an x offset in acc, and a y offset in b.  It calculates the index
;		of that space and returns it in the acc
;		b holds 01h if there is an out of bounds error.  Else it holds 0.
; modifies r0
;=========================================================================
calc_index_from_offset:
	xch a, r0						; acc now holds space index
	mov r1, b						; so offsets are no stored in r0, r1
	mov b, #NUMBLOCKX			; divisor
	div ab						; a holds row #, b holds col #
	
	; adjust row value
	add a, r1					; add y offset to row #
	clr c
	mov r1, #NUMBLOCKY
	subb a, r1					; subtract off num rows
	jnc calc_out_of_bounds_y	; if carry isn't set, out row number > max_row
	add a, r1					; restore a to the row value
	
	; adjust col value
	xch a, b					; b now holds final row value, a holds initial col
	add a, r0					; add x offset to col #
	clr c
	mov r0, #NUMBLOCKX
	subb a, r0					; subtract off NUMBLOCKX
	jnc calc_out_of_bounds_x		; carry bit not set => col # too high
	add a, r0					; restore a to the final col value
	
	; col value in a, row in b, now we need to calculate the index #
	mov r0, a					; save col value in r0
	mov a, #NUMBLOCKX
	mul ab						; a holds NUMBLOCKX*row#
	add a, r0					; acc holds index
	mov b, #00h					; indicate that there is no out of bounds error
	ret
calc_out_of_bounds_x:
	mov b, #01h					; indicate that there is an out of bounds error
	ret
calc_out_of_bounds_y:
	mov b, #01h					; indicate that there is an out of bounds error
	ret
	
	
;===================================================================
; add_acc_to_dptr	- add acc to dptr, leave acc unchanged
;==================================================================
add_acc_to_dptr:
	push acc					; store acc
	add a, dpl
	mov dpl, a					; dpl holds new dpl
	mov a, dph
	addc a, #00h
	mov dph, a					; dph holds new dph
	pop acc						; restore acc
	ret
	
;=====================================================================
; save_dptr - saves the dptr
;=====================================================================
save_dptr:
	mov a, dph
	mov b, dpl
	mov dptr, #DPH_STORE
	movx @dptr, a				; save the high byte
	mov dptr, #DPL_STORE
	mov a, b
	movx @dptr, a				; save the low byte
	ret
	
;=======================================================================
; retrieve_dptr - retrieves the dptr
;=======================================================================
retrieve_dptr:
	mov dptr, #DPL_STORE
	movx a, @dptr
	mov b, a					; b has dpl
	mov dptr, #DPH_STORE
	movx a, @dptr				; a has dph
	mov dph, a					; dph is updated
	mov dpl, b					; dpl is updated
	ret
	
.org ROTATION_TABLE		; specifies block rotation offsets
;null type
.db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h			;Type 0, pos 0 -> pos 1
.db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h			;		pos 1 -> pos 2
.db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h			;		pos 2 -> pos 3
.db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h			;		pos 3 -> pos 0

.db 02h, 01h, 01h, 00h, 00h, 0FFh, 0FFh, 0FEh		;Type 1, pos 0 -> pos 1
.db 01h, 0FEh, 00h, 0FFh, 0FFh, 00h, 0FEh, 01h		;		pos 1 -> pos 2
.db 0FEh, 0FFh, 0FFh, 00h, 00h, 01h, 01h, 02h		;		pos 2 -> pos 3
.db 0FFh, 02h, 00h, 01h, 01h, 00h, 02h, 0FFh		;		pos 3 -> pos 0

.db 02h, 00h, 01h, 01h, 00h, 00h, 0FFh, 0FFh		;Type 2, pos 0 -> pos 1
.db 00h, 0FEh, 01h, 0FFh, 00h, 00h, 0FFh, 01h		;		pos 1 -> pos 2
.db 0FEh, 00h, 0FFh, 0FFh, 00h, 00h, 01h, 01h		;		pos 2 -> pos 3
.db 00h, 02h, 0FFh, 01h, 00h, 00h, 01h, 0FFh		;		pos 3 -> pos 0

.db 00h, 0FEh, 0FFh, 0FFh, 00h, 00h, 01h, 01h		;Type 3, pos 0 -> pos 1
.db 0FEh, 00h, 0FFh, 01h, 00h, 00h, 01h, 0FFh		;		pos 1 -> pos 2
.db 00h, 02h, 01h, 01h, 00h, 00h, 0FFh, 0FFh		; 		pos 2 -> pos 3
.db 02h, 00h, 01h, 0FFh, 00h, 00h, 0FFh, 01h		;		pos 3 -> pos 0

;square type
.db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h			;Type 4, pos 0 -> pos 1
.db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h			;		pos 1 -> pos 2
.db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h			;		pos 2 -> pos 3
.db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h			;		pos 3 -> pos 0

.db 01h, 01h, 00h, 00h, 01h, 0FFh, 00h, 0FEh		;Type 5, pos 0 -> pos 1
.db 01h, 0FFh, 00h, 00h, 0FFh, 0FFh, 0FEh, 00h		;		pos 1 -> pos 2
.db 0FFh, 0FFh, 00h, 00h, 0FFh, 01h, 00h, 02h		;		pos 2 -> pos 3
.db 0FFh, 01h, 00h, 00h, 01h, 01h, 02h, 00h			;		pos 3 -> pos 0

.db 01h, 01h, 00h, 00h, 0FFh, 0FFh, 01h, 0FFh		;Type 6, pos 0 -> pos 1
.db 01h, 0FFh, 00h, 00h, 0FFh, 01h, 0FFh, 0FFh		;		pos 1 -> pos 2
.db 0FFh, 0FFh, 00h, 00h, 01h, 01h, 0FFh, 01h		;		pos 2 -> pos 3
.db 0FFh, 01h, 00h, 00h, 01h, 0FFh, 01h, 01h		;		pos 3 -> pos 0

.db 02h, 00h, 01h, 0FFh, 00h, 00h, 0FFh, 0FFh		;Type 7, pos 0 -> pos 1
.db 00h, 0FEh, 0FFh, 0FFh, 00h, 00h, 0FFh, 01h		;		pos 1 -> pos 2
.db 0FEh, 00h, 0FFh, 01h, 00h, 00h, 01h, 01h		;		pos 2 -> pos 3
.db 00h, 02h, 01h, 01h, 00h, 00h, 01h, 0FFh			;		pos 3 -> pos 0

.org LEFT_TABLE			; specifies move-left offsets
.db 0FFh, 00h, 0FFh, 00h, 0FFh, 00h, 0FFh, 00h		; all blocks move one to the left

.org RIGHT_TABLE		; specifies move-right offsets
.db 01h, 00h, 01h, 00h, 01h, 00h, 01h, 00h			; all blocks move one to the right

.org UP_TABLE			; specifies move-up offsets (for testing)
.db 00h, 01h, 00h, 01h, 00h, 01h, 00h, 01h			; all blocks move one up

.org DOWN_TABLE			; specifies move-down offests
.db 00h, 0FFh, 00h, 0FFh, 00h, 0FFh, 00h, 0FFh		; all blocks move one down

.org INIT_BLOCK_POS		; specifies the relative positions of each of the 4 squares
.db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h		; null type
.db 0FFh, 0FFh, 00h, 0FFh, 01h, 0FFh, 02h, 0FFh		; type 1 initial offset from ref
.db 0FFh, 00h, 0FFh, 0FFh, 00h, 0FFh, 01h, 0FFh		; type 2 initial offset from ref
.db 01h, 00h, 01h, 0FFh, 00h, 0FFh, 0FFh, 0FFh		; type 3 initial offset from ref
.db 00h, 0FFh, 00h, 00h, 01h, 00h, 01h, 0FFh		; type 4 initial offset from ref
.db 0FFh, 0FFh, 00h, 0FFh, 00h, 00h, 01h, 00h		; type 5 initial offset from ref
.db 0FFh, 0FFh, 00h, 0FFh, 01h, 0FFh, 00h, 00h		; type 6 initial offset from ref
.db 0FFh, 00h, 00h, 00h, 00h, 0FFh, 01h, 0FFh		; type 7 initial offset from ref

.org BLOCK_SEQUENCE		; the sequence of block types seen in the game (it repeats)
.db 02h, 03h, 04h, 05h
.db 03h, 07h, 02h, 01h
.db 03h, 06h, 01h, 02h
.db 07h, 05h, 04h, 03h
.db 05h, 02h, 06h, 02h
.db 04h, 01h, 02h, 05h
.db 07h, 02h, 04h, 06h
