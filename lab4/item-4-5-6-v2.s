@ arm-elf-gcc -Wall -g -o item-4-5-6 item-4-5-6.s
@ arm-elf-gdb item-4-5-6
    .text
    .globl  main

main:
    MOV     r1, #12	@ n
    MOV     r5, #0	@ f(0) 
    MOV     r0, #1	@ f(1), r0 guarda f(n)
    MOV     r7, #1	@ contador = 1 
    CMP     r1, #1	@ se n == 1, f(n) já esta correto
    MOVMI   r0, #0	@ se n < 1, r0 = 0
    BLE	    end
    BL      fibo

end:
    SWI     0x123456

fibo:
    ADD     r4, r0, r5	@ fib(n) = fib(n-1) + fib(n-2)
    MOV     r5, r0	
    MOV     r0, r4
    ADD     r7, r7, #1	@ contador++
    CMP     r7, r1	@ checa contador < n
    BNE     fibo
    MOV     pc, lr
