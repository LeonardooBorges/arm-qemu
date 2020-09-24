@ arm-elf-gcc -Wall -g -o item-4-5-3 item-4-5-3.s
@ arm-elf-gdb item-4-5-3
	.text
 	.globl  main

main:
	MOV	r1, #10
	ADR	r0, array
	BL	bubble
	SWI	0x0

bubble:
	MOV	r8, #0
	SUB	r6, r1, #1
	
loop2:
	CMP	r8, r6
	MOVEQ	pc, lr
	ADD	r8, r8, #1
	MOV	r7, #0
loop:
	CMP	r7, r6
	BEQ	loop2
	ADD	r5, r0, r7, LSL #2
	ADD	r7, r7, #1
	LDMIA	r5, {r2, r3}
	CMP	r2, r3
	BMI	loop
        EOR     r2, r2, r3
        EOR     r3, r2, r3
        EOR     r2, r2, r3
	STMIA	r5, {r2, r3}
	B	loop
		
stack:
	LDR	r1, =0x1
	LDR	r0, =0xfeeddeaf
	STMFD	sp!, {r0,r1}
	LDR	r0, =0xbabe2222
	STMFD	sp!, {r0}
	LDR	r0, =0x12340000
	STMFD	sp!, {r0}
	MOV	r0, #0
	MOV	r1, #9
	LDMFD	sp!, {r0,r1}	
	SWI	0x0
regs:
	MOV	r0, #7
	MOV	r1, #8
	MOV	r2, #3
	STMIA	r3, {r0,r1,r2}
	MOV	r0, #0
	MOV	r1, #9
	MOV	r2, #6
	LDMIA	r3!, {r0}
	LDMIA	r3!, {r1}
	LDMIA	r3!, {r2}
	SWI	0x0

array: .word 0,6,8,456,88,23,6,76,87,4

