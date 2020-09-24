    .text
    .globl  main
main:
    LDR     r1, =9345213   @ r1 dividend
    LDR     r2, =1000     @ r2 divisor
    LDR     r3, =0      @ r3 quotient
    LDR     r4, =0      @ r4 remainder
    BL      division

end:
    SWI     0x0

division:
    MOV     r5, r1      @ r5 copy of dividend
    MOV     r6, r2      @ r6 copy of divisor
    CMP     r5, r6
    MOVMI   r4, r5
    BMI     end

shift_divisor:
    MOV     r6, r6, LSL #1
    CMP     r6, r5
    BMI     shift_divisor

loop_division:
    CMP     r5, r6
    SUBPL   r5, r5, r6
    MOV     r3, r3, LSL #1
    ADDPL   r3, r3, #1
    MOV     r6, r6, LSR #1
    CMP     r6, r2
    BPL     loop_division

end_division:
    MOV     r4, r5
    MOV     pc, lr

