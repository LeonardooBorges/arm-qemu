	.text
	.globl main
main:
	MOV	r0, #0			@ f(n)
	LDR	r1, =1			@ valor final (n = 10)
	MOV	r2, #0			@ f(n-1)
	MOV	r3, #1			@ f(n-2)
	MOV	r4, #2			@ n
fibonacci:
	CMP	r4, r1			@ n <= 10 ?
	BGT	finish
	ADD	r0, r2, r3		@ f(n) = f(n-1) + f(n-2)
	MOV	r3, r2			@ f(n-2) = f(n-1)
	MOV	r2, r0			@ f(n-1) = f(n)
	ADD	r4, r4, #1		@ incrementa n
	B 	fibonacci
finish:
	SWI	0x123456
