@ arm-elf-gcc -Wall -g -o item-4-5-3 item-4-5-3.s
@ arm-elf-gdb item-4-5-3 
    .text
    .globl  main

main:     
    ADR     r1, a                   @ load a address into r1
    ADR     r2, b                   @ load b address into r2
    MOV     r3, #0                  @ i
    MOV     r4, #4                  @ c
    BL      loop 
    SWI     0x123456
	 

loop:
    CMP     r3, #10
    MOVEQ   pc, lr
    LDR     r5, [r2, r3, LSL #2]
    ADD     r5, r5, r4
    STR     r5, [r1, r3, LSL #2]
    ADD     r3, r3, #1
    B       loop

a: .word 0,0,0,0,0,0,0,0,0,0
b: .word 1,2,3,4,5,6,7,8,9,10
