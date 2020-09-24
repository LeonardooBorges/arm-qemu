	.text
	.globl	main
main:
	LDR	r0, =0xFFFF0000
	LDR	r1, =0x87654321
	ADDS 	r2, r1, r0
	SWI	0x0
