@ arm-elf-gcc -Wall -g -o item-5-5-5 item-5-5-5.s
@ arm-elf-gdb item-5-5-5
	.text
	.globl main
main:
	LDR	r0, =0x5555AAAA		;@ r0 (1010101010101011010101010101010)
	BL	parity			;@ parity algorithm
	LDR	r0, =0x7455B		;@ r0 (1110100010101011011)
	BL	parity			;@ parity algorithm
	SWI	0x123456

parity:
	MOV	r2, #0 			;@ count
	MOV	r7, r0 			;@ copy of r0
	MOV	r1, #0
loop:
	CMP	r2, #33			;@ stop condition
	BEQ	check
	MOVS	r7, r7, LSL #1 		;@ shift left r7 and set flags
	ADDCS	r1, r1, #1		;@ sum 1 in r1 if carry flag set
	ADD	r2, r2, #1		;@ update count	
	B	loop
check:
	MOVS	r1, r1, LSR #1		;@ shift right r1 and set flags
	MOVCS	r1, #1			;@ if carry set, number of 1s is odd
	MOVCC	r1, #0			;@ if carry not set, number of 1s is even
	MOV	pc, lr
