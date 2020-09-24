	.text
	.globl	main
main:
	LDR	r0, =0xFFFFFFFF
	LDR	r1, =0x80000000
	MULS 	r2, r1, r0
	SMULLS	r3, r4, r1, r0
	UMULLS	r5, r6, r1, r0
	SWI	0x0
