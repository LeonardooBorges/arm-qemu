	.file	"asm_c.c"
	.global	mostra
	.data
	.align	2
	.type	mostra, %object
	.size	mostra, 4
mostra:
	.word	99
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
	ldr	r3, .L2
	mov	r2, #47
	str	r2, [r3, #0]
	mov	r3, #0
	mov	r0, r3
	ldmfd	sp, {fp, sp, pc}
.L3:
	.align	2
.L2:
	.word	mostra
	.size	main, .-main
	.ident	"GCC: (GNU) 3.4.3"
