@ arm-elf-gcc -Wall -g -o item-4-5-5 item-4-5-5.s
@ arm-elf-gdb item-4-5-5 
    .text
    .globl  main

main:     
    ADR     r0, bytes               @ load bytes address into r0
    MOV     r7, #2                  @ counter
    MOV     r1, #1                  @ constant 1
    STRB    r1, [r0, #1]            @ save f(1) into bytes array
    BL      fibo 
    SWI     0x123456 

fibo:
    SUB     r5, r7, #1
    SUB     r6, r7, #2
    LDRB    r1, [r0, r5]
    LDRB    r2, [r0, r6]
    ADD     r1, r1, r2
    STRB    r1, [r0, r7]
    ADD     r7, r7, #1
    CMP     r7, #12
    BNE     fibo
    MOV     pc, lr

bytes: 
    .byte 0,0,0,0,0,0,0,0,0,0,0,0
