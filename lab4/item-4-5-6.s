@ arm-elf-gcc -Wall -g -o item-4-5-6 item-4-5-6.s
@ arm-elf-gdb item-4-5-6 
    .text
    .globl  main

main:     
    MOV     r1, #0
    MOV     r5, #0                  
    MOV     r0, #1                  
    MOV     r7, #1
    CMP     r1, #1
    MOVMI   r0, #0
    BLE     end
    BL      fibo

end:
    SWI     0x123456 

fibo:
    ADD     r4, r0, r5
    MOV     r5, r0
    MOV     r0, r4
    ADD     r7, r7, #1
    CMP     r7, r1
    BNE     fibo
    MOV     pc, lr

bytes: 
    .byte 0,0,0,0,0,0,0,0,0,0,0,0
