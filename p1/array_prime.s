;@ find prime number closest to nusp
;@  
    .text
    .globl  main

main:
    ADR     r0,array
    MOV     r1, #30
    BL      find_primes
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

find_primes:
    STMFD   sp!, {lr}
    MOV     r2, #2                  ;@ r2 current prime
    STR     r2, [r0]                ;@ first prime
    ADD     r2, r2, #1
    MOV     r7, #1                  ;@ counter
fp_loop:
    CMP     r7, r1
    BEQ     return
    MOV     r3, r2, LSR #1          ;@ r3 = upper bound
    MOV     r4, #3                  ;@ r4 = current divisor
fp_loop_div:
    CMP     r3, r4                  ;@ n/2 - divisor
    BMI     is_prime
    STMFD   sp!, {r0-r4}            ;@ push local registers
    STMFD   sp!, {r2, r4}           ;@ push arguments
    BL      div
    LDMFD   sp!, {r11, r12}         ;@ pop return
    LDMFD   sp!, {r0-r4}            ;@ pop local registers
    ADD     r4, r4, #2              ;@ divisor += 2
    CMP     r12, #0
    BNE     fp_loop_div
not_prime:
    ADD     r2, r2, #2              ;@ prime += 2
    B       fp_loop
is_prime:
    STR     r2, [r0, r7, LSL #2]
    ADD     r2, r2, #2              ;@ prime +=2     
    ADD     r7, r7, #1              ;@ counter++
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

array:
    .word 0
