@ arm-elf-gcc -Wall -g -o item-4-5-2 item-4-5-2.s
@ arm-elf-gdb item-4-5-2
@
	.text
	.globl main
main:
	MOV	r1, #1			@ algum valor pra r1 (y)
	ADR	r2, array_a		@ carrega endreco do array_a[0]
	MOV	r3, #5			@ indice load = 5
load:
	LDR	r8, [r2], #20		@ post-indexed
	LDR	r4, [r2]		@ array[5]
	ADR	r2, array_a		@ carrega endreco do array_a[0] de novo
	LDR	r4, [r2, r3, LSL #2]	@ pre-indexed (array_a[5])
	ADD	r0, r1, r4		@ r0 = array_a[5] + r1    (x = array[5] + y)   = 7
store:
	MOV	r3, #10			@ indice store = 10
	ADR	r2, array_a		@ carrega endreco do array_a[0] de novo
	LDR	r8, [r2], #40		@ post-indexed
	STR	r0, [r2]		@ array[10]
	ADR	r2, array_a		@ carrega endreco do array_a[0] de novo
	STR	r0, [r2, r3, LSL #2]	@ pre-indexed
	SWI	0x123456
array_a:	.word	0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24
