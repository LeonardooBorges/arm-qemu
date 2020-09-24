@ arm-elf-gcc -Wall -g -o item-4-5-1 item-4-5-1.s
@ arm-elf-gdb item-4-5-1
	.text
	.globl main
main:
	MOV	r1, #1			;@ y = 1
	MOV	r4, #5			;@ indice desejado = 5
@post-indexed
	ADR	r2, array_a		;@ endereco do array_a[0]
	LDR	r8, [r2], #20		;@ post-indexed
	LDR	r3, [r2]		;@ array[5]
	ADD	r0, r1, r3		;@ r0 = array_a[5] + r1    (x = array[5] + y)   = 7
@pre-indexed
	ADR	r2, array_a		;@ endreco do array_a[0]
	LDR	r3, [r2, r4, LSL #2]	;@ pre-indexed (array_a[5])
	ADD	r0, r1, r3		;@ r0 = array_a[5] + r1    (x = array[5] + y)   = 7
	SWI	0x123456
array_a:	
.word	0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24
