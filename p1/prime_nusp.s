;@ find prime number closest to nusp
;@  
    .text
    .globl  main

main:
    LDR     r0, =9345280
    BL      find_prime
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

find_prime:
    STMFD   sp!, {lr}
    MOVS    r1, r0, LSR #1          ;@ r1 = prime (checks if nusp is even or odd)
    MOVCS   r1, r0                  ;@ if odd then r1 = nusp
    SUBCC   r1, r0, #1              ;@ if even then r1 = nusp-1
fp_loop:
    MOV     r2, r1, LSR #1          ;@ r2 = upper bound
    MOV     r3, #3                  ;@ r3 = current divisor
fp_loop_div:
    CMP     r2, r3                  ;@ n/2 - divisor
    BMI     return
    STMFD   sp!, {r0-r3}            ;@ push local registers
    STMFD   sp!, {r1, r3}           ;@ push arguments
    BL      div
    LDMFD   sp!, {r11, r12}         ;@ pop return
    LDMFD   sp!, {r0-r3}            ;@ pop local registers
    ADD     r3, r3, #2              ;@ divisor += 2
    CMP     r12, #0
    BNE     fp_loop_div
not_prime:
    SUB     r1, r1, #2              ;@ prime += 2
    B       fp_loop
    
div:
    LDMFD   sp!, {r1, r2}           ;@ pop arguments
    LDR     r3, =0                  ;@ r3 quotient
    LDR     r4, =0                  ;@ r4 remainder
    MOV     r5, r1                  ;@ r5 copy of dividend
    MOV     r6, r2                  ;@ r6 copy of divisor
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
    STMFD   sp!, {r3, r4}           ;@ push return
    MOV     pc, lr

