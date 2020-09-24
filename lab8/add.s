    .text
    .globl   myadd
			
myadd:                     	@ Function "myadd" entry point.
    add     r0, r0, r1   	@ Function arguments are in R0 and R1. Add together and put the result in R0.
    mov     pc, lr              @  Return by branching to the address in the link register.
