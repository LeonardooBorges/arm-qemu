    .text
    .globl  main
main:
    B       ex4 

ex1:
    MOV     r7, #0
    MOV     r12, #0
    ADD     r3, r7, #360
    @MOV    r0, r3, LSL #5
    SUB     r11, r12, r3, LSL #5
    SWI     0x0

a:
    MOV     r4, #1
    MOV     r1, r4, LSL #7
    ADD     r2, r1, r4, LSL #2
    SWI     0x0

b:
    MOV     r1, #1
    @MOV     r4, r1, LSL #8
    @SUB     r2, r4, r1
    RSB     r2, r1, r4, LSL #8
    SWI     0x0

c:  
    MOV     r4, #1
    MOV     r1, r4, LSL #4
    ADD     r2, r1, r4, LSL #1
    SWI     0x0

d:
    MOV     r4, #1
    MOV     r2, r4, LSL #14
    SWI     0x0
    
ex3:
    LDR     r2, =0x111
    LDR     r3, =0x177
    LDR     r0, =0x111
    LDR     r1, =0x777
    SUBS    r4, r0, r2
    SUBEQS  r5, r1, r3
    SWI     0x0

ex4:
    LDR     r0, =0x80000001
    LDR     r1, =0x80000001
    MOVS    r1, r1, LSR #1
    MOV     r0, r0, RRX

ex5:
    LDR     r0, =0x80000001
    LDR     r1, =0x80000001
    MOV     r1, r1, LSL #1
    MOVS    r0, r0, LSL #1
    ADC     r1, r1, #0
    SWI 0x0
