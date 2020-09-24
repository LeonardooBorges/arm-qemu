	.file	"imprime_stack.c"
	.section	.rodata
	.align	2
.LC0:
	.ascii	"numero = %d\n\000"
	.text
	.align	2
	.global	imprime
	.type	imprime, %function
imprime:
	@ args = 4, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	mov	ip, sp
	stmfd	sp!, {fp, ip, lr, pc}
	sub	fp, ip, #4
	sub	sp, sp, #20
	str	r0, [fp, #-16]
	str	r1, [fp, #-20]
	str	r2, [fp, #-24]
	str	r3, [fp, #-28]
	ldr	r3, [fp, #-16]
	cmp	r3, #0
	bge	.L2
	b	.L1
.L2:
	ldr	r0, .L3
	ldr	r1, [fp, #-16]
	bl	printf
	ldr	r3, [fp, #-16]
	sub	r1, r3, #1
	ldr	r3, [fp, #-20]
	sub	r3, r3, #1
	mov	lr, r3
	str	lr, [fp, #-20]
	ldr	r3, [fp, #-24]
	sub	r3, r3, #1
	mov	r2, r3
	str	r2, [fp, #-24]
	ldr	r3, [fp, #-28]
	sub	r3, r3, #1
	mov	ip, r3
	str	ip, [fp, #-28]
	ldr	r3, [fp, #4]
	sub	r3, r3, #1
	str	r3, [fp, #4]
	str	r3, [sp, #0]
	mov	r0, r1
	mov	r1, lr
	mov	r3, ip
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
	sub	sp, sp, #4
	mov	r3, #21
	str	r3, [sp, #0]
	mov	r0, #5
	mov	r1, #7
	mov	r2, #8
	mov	r3, #9
	bl	imprime
	mov	r3, #0
	mov	r0, r3
	ldmfd	sp, {r3, fp, sp, pc}
	.size	main, .-main
	.ident	"GCC: (GNU) 3.4.3"
