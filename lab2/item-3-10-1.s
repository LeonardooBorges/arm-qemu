	.text
	.globl	main
main:
	LDR	r0, =0xFFFF0000
	LDR	r1, =0x87654321
	ADDS 	r2, r1, r0
	LDR	r0, =0xFFFFFFFF
	LDR	r1, =0x12345679
	ADDS 	r3, r1, r0
	LDR	r0, =0x67654321
	LDR	r1, =0x23110000
	ADDS 	r2, r1, r0
	SWI	0x0
