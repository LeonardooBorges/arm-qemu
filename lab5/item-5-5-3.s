@ arm-elf-gcc -Wall -g -o item-5-5-1 item-5-5-1.s
@ arm-elf-gdb item-5-5-1
	.text
	.globl main
main:
	ADR	r8, list		;@ carrega endereçoda list
	MOV	r1, #0			;@ max value
	BL	find_max
	SWI	0x123456            

find_max:
	MOV	r0, #0
loop:
	CMP	r0, #11
	MOVEQ	pc, lr
	LDR	r2, [r8, r0, LSL #2]
	CMP	r2, r1
	MOVHI	r1, r2
	ADD	r0, r0, #1
	B	loop	

list:  
	.word 15,2,73,64,5,7,245,455,76,927,118  
