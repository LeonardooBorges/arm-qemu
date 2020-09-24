	.text
	.globl	main
main:
	@LDR	r0, =0x1
	@LSL	r1, r0, #5
	MOV     r0, #0x2                                                                                                                                                                           
	MOV     r1, r0, ROR #5
	SWI	0x0
