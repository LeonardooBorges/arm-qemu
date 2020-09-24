@ arm-elf-gcc -Wall -g -o item-6-5-1 item-6-5-1.s
@ arm-elf-gdb item-6-5-1
	.text
 	.globl  main

main:
	MOV	r1, #10
	ADR	r0, array

bubble:
	MOV	r8, #0
	SUB	r6, r1, #1	
loop_i:
	CMP	r8, r6
	BEQ	end
	ADD	r8, r8, #1
	MOV	r7, #0
loop_j:
	CMP	r7, r6
	BEQ	loop_i
	ADD	r5, r0, r7, LSL #2
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

array: .word 0,6,8,456,88,23,6,76,87,4

