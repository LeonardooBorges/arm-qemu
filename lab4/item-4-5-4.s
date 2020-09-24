@ arm-elf-gcc -Wall -g -o item-4-5-4 item-4-5-4.s
@ arm-elf-gdb item-4-5-4 
    .text
    .globl  main

main:     
    ADR     r1, a                   @ load a address into r1
    MOV     r2, #10                 @ s
    MOV     r3, #0                  @ i
    MOV     r5, #0
    BL      loop_pre 
    ADR     r1, b                   @ load b address into r1
    MOV     r2, #10                 @ s
    ADR     r3, r1                  @ p
    MOV     r5, #0
    BL      loop_pos 
    SWI     0x123456 

loop_pre:
    CMP     r3, r2
    MOVEQ   pc, lr
    STRB    r5, [r1, r3]
    ADD     r3, r3, #1
    B       loop_pre
    
loop_pos:
    CMP     r3, r2
    MOVEQ   pc, lr
    STRB    r5, [r3], #1
    B       loop_pos

a: .byte 1,2,3,4,5,6,7,8,9,10
b: .byte 1,2,3,4,5,6,7,8,9,10
