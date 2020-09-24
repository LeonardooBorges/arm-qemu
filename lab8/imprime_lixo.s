	.file	"imprime_lixo.c"
	.section	.rodata
	.align	2
.LC0:
	.ascii	"numero = %d\n\000"
	.text
	.align	2
	.global	imprime
	.type	imprime, %function
imprime:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	mov	ip, sp
	stmfd	sp!, {fp, ip, lr, pc}
	sub	fp, ip, #4
	sub	sp, sp, #8
	str	r0, [fp, #-16]
	str	r1, [fp, #-20]
	ldr	r2, [fp, #-20]
	ldr	r3, [fp, #-16]
	cmp	r2, r3
	blt	.L2
	b	.L1
.L2:
	ldr	r3, [fp, #-20]
	add	r3, r3, #1
	str	r3, [fp, #-20]
	ldr	r0, .L3
	mov	r1, r3
	bl	printf
	ldr	r0, [fp, #-16]
	ldr	r1, [fp, #-20]
	bl	imprime
.L1:
	sub	sp, fp, #12
	ldmfd	sp, {fp, sp, pc}
.L4:
	.align	2
.L3:
	.word	.LC0
	.size	imprime, .-imprime
	.align	2
	.global	main
	.type	main, %function
main:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	mov	ip, sp
	stmfd	sp!, {fp, ip, lr, pc}
	sub	fp, ip, #4
	mov	r0, #7
	mov	r1, #0
	bl	imprime
	mov	r3, #0
	mov	r0, r3
	ldmfd	sp, {fp, sp, pc}
	.size	main, .-main
	.ident	"GCC: (GNU) 3.4.3"
