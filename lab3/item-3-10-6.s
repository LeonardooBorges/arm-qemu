    .text
    .globl  main
main:
    LDR     r0, =0x535
    BL      absolute
    LDR     r0, =0xfffffff5
    BL      absolute
    SWI     0x0

absolute:
    SUBS    r1, r0, #0
    RSBMI   r1, r0, #0
    MOV     pc, lr 
