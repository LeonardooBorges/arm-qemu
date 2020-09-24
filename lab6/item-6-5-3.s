@ arm-elf-gcc -Wall -g -o item-6-5-3 item-6-5-3.s
@ arm-elf-gdb item-6-5-3
	.text
 	.globl  main

main:
	MOV	r0, #3
	ADR	r1, magic_square
	MUL	r3, r0, r0		;@ calculate magic number0
	ADD	r3, r3, #1	
	MUL	r2, r0, r3
	MOV	r2, r2, LSR #1
	BL	magic
	B	end

check_sum:
	CMP	r2, r5
	MOVEQ	pc, lr
	MOV	r9, #0
	B	end

return:
	LDMFD	sp!, {pc}

check_line:
	STMFD	sp!, {lr}
	MOV	r8, #0			;@ i
	MOV	r6, r1
l_loop_i:
	CMP	r8, r0
	BEQ	return
	MOV	r7, #0			;@ j
	MOV	r5, #0			;@ sum acc
l_loop_j:
	CMP	r7, r0
	BLEQ	check_sum
	ADDEQ	r8, r8, #1
	BEQ	l_loop_i
	LDR	r3, [r6], #4
	ADD	r5, r5, r3
	ADD	r7, r7, #1
	B	l_loop_j


check_column:
	STMFD	sp!, {lr}
	MOV	r8, #0			;@ i
c_loop_i:
	CMP	r8, r0
	BEQ	return
	MOV	r7, #0			;@ j
	MOV	r5, #0			;@ sum acc
c_loop_j:
	CMP	r7, r0
	BLEQ	check_sum
	ADDEQ	r8, r8, #1
	BEQ	c_loop_i
	MUL	r6, r0, r7
	MOV	r6, r6, LSL #2
	ADD	r6, r6, r8, LSL #2
	LDR	r3, [r1, r6]
	ADD	r5, r5, r3
	ADD	r7, r7, #1
	B	c_loop_j

check_diag_p:
	STMFD	sp!, {lr}
	MOV	r8, #0			;@ i
	ADD	r7, r0, #1		;@ (N+1)
	MOV	r7, r7, LSL #2		;@ (N+1)*4
	MOV	r6, r1
	MOV	r5, #0			;@ sum acc
d_loop_p:
	CMP	r8, r0
	BLEQ	check_sum
	BEQ	return
	LDR	r3, [r6], r7
	ADD	r5, r5, r3
	ADD	r8, r8, #1
	B	d_loop_p

check_diag_s:
	STMFD	sp!, {lr}
	MOV	r8, #0			;@ i
	SUB	r7, r0, #1
	MOV	r7, r7, LSL #2		;@ (N-1)*4
	ADD	r6, r1, r7
	MOV	r5, #0			;@ sum acc
d_loop_s:
	CMP	r8, r0
	BLEQ	check_sum
	BEQ	return
	LDR	r3, [r6], r7
	ADD	r5, r5, r3
	ADD	r8, r8, #1
	B	d_loop_s

magic:	
	STMFD	sp!, {lr}
	BL	check_line
	BL	check_column
	BL	check_diag_p
	BL	check_diag_s
	BL 	check_numbers
	MOV	r9, #1
	B	return

check_numbers:
	STMFD	sp!, {lr}
	BL	bubble	
	MUL	r6, r0, r0
	MOV	r7, #0
	SUB	r6, r6, #1	
cn_loop_i:
	CMP	r7, r6
	BEQ	return
	ADD	r5, r1, r7, LSL #2
	LDMIA	r5, {r2, r3}
	CMP	r2, r3
	BEQ	end
	ADD	r7, r7, #1
	B	cn_loop_i

bubble:
	STMFD	sp!, {lr}
	MUL	r6, r0, r0
	MOV	r8, #0
	SUB	r6, r6, #1	
loop_i:
	CMP	r8, r6
	BEQ	return
	ADD	r8, r8, #1
	MOV	r7, #0
loop_j:
	CMP	r7, r6
	BEQ	loop_i
	ADD	r5, r1, r7, LSL #2
	ADD	r7, r7, #1
	LDMIA	r5, {r2, r3}
	CMP	r3, r2
	BLMI	swap
	B	loop_j
		
swap:
        EOR     r2, r2, r3
        EOR     r3, r2, r3
        EOR     r2, r2, r3
	STMIA	r5, {r2, r3}
	MOV	pc, lr

end:
	SWI	0x0
magic_square: 	.word 2,7,6,9,5,1,4,3,8
@magic_square: 	.word 5,5,5,5,5,5,5,5,5
@magic_square: 	.word 16,3,2,13,5,10,11,8,9,6,7,12,4,15,14,1
