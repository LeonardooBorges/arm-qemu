@
@   
    .text
    .globl  main

main:
    LDR     r1, =15
    LDR     r2, =20
    BL      lcm
end:
    SWI     0x0

return:
    LDMFD   sp!, {pc}

save:
    STMFD   sp!, {r0-r12, lr}
    MOV     pc, lr

get:
    LDMFD   sp!, {r0-r12}
    MOV     pc, lr

gcd:
    LDMFD   sp!, {r0, r1}           ;@ pop arguments
gcd_loop:    
    CMP     r0,r1
    SUBGT   r0,r0,r1
    SUBLT   r1,r1,r0
    BNE     gcd_loop
    STMFD   sp!, {r0}              ; @ push return
    MOV     pc, lr

lcm:
    STMFD   sp!, {lr}               ;@ push return
    STMFD   sp!, {r1-r2}            ;@ push local registers
    STMFD   sp!, {r1, r2}           ;@ push arguments
    BL      gcd
    LDMFD   sp!, {r4}               ;@ pop return
    LDMFD   sp!, {r1-r2}            ;@ pop local registers
    MUL     r3, r1, r2
    STMFD   sp!, {r1-r4}            ;@ push local registers
    STMFD   sp!, {r3, r4}           ;@ push arguments
    BL      div
    LDMFD   sp!, {r5, r6}           ;@ pop return
    LDMFD   sp!, {r1-r4}            ;@ pop local registers
    MOV     r4, r5
    B       return

div:
    LDMFD   sp!, {r1, r2}           ; @ pop arguments
    LDR     r3, =0                  ; @ r3 quotient
    LDR     r4, =0                  ; @ r4 remainder
    MOV     r5, r1                  ; @ r5 copy of dividend
    MOV     r6, r2                  ; @ r6 copy of divisor
    CMP     r5, r6
    BMI     end_division

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
    STMFD   sp!, {r3, r4}           @ push return
    MOV     pc, lr

array:
    .word 15, 20, 30, 40
