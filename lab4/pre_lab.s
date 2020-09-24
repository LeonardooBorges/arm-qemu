    .text
    .globl  main

main:     
    ADR     r0, a 
    ADR     r1, b
    MOV     r7, #0
    BL      arraycopy
    SWI     0x123456 


arraycopy:
    RSB     r3, r7, #7 
    LDR     r2, [r1, r3, LSL #2]
    STR     r2, [r0, r7, LSL #2]
    ADD     r7, r7, #1
    CMP     r7, #8 
    BNE     arraycopy 
    MOV     pc, lr 

a: .word 0,0,0,0,0,0,0,0
b: .word 7,6,5,4,3,2,1,0
