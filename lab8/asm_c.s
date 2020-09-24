	.file	"asm_c.c"
	.text
	.align	2
	.global	main
	.type	main, %function
main:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	mov	ip, sp
	stmfd	sp!, {fp, ip, lr, pc}
	sub	fp, ip, #4
	ldr	r2, .L2
	mov	r3, #0
	str	r3, [r2, #0]
	LDR    r2, =mostra
	LDR    r3, =1
	STR    r3, [r2, #0]
	
	ldr	r2, .L2
	ldr	r3, .L2
	ldr	r3, [r3, #0]
	add	r3, r3, #1
	str	r3, [r2, #0]
	mov	r3, #0
	mov	r0, r3
	ldmfd	sp, {fp, sp, pc}
.L3:
	.align	2
.L2:
	.word	mostra
	.size	main, .-main
	.comm	mostra,4,4
	.ident	"GCC: (GNU) 3.4.3"
