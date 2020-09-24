    .text
    .globl  main
main:
    LDR     r0, =0x3
    LDR     r1, =0x2
    BL      multi
    LDR     r0, =0xfffffffe
    LDR     r1, =0xfffffffc
    BL      multi
    LDR     r0, =0xfffffffa
    LDR     r1, =0x5
    BL      multi
    SWI     0x0

multi:
    MOV     r7, #1
    MOV     r8, lr
    BL      absolute1
    BL      absolute2
    UMULL   r2, r3, r0, r1
    CMP     r7, #0
    BLMI    invert
    MOV     pc, r8

absolute1:
    SUBS    r0, r0, #0
    RSBMI   r0, r0, #0
    RSBMI   r7, r7, #0
    MOV     pc, lr

absolute2:
    SUBS    r1, r1, #0
    RSBMI   r1, r1, #0
    RSBMI   r7, r7, #0
    MOV     pc, lr
    

invert:
    MVN     r2, r2
    MVN     r3, r3
    ADD     r2, r2, #1
    MOV     pc, lr
