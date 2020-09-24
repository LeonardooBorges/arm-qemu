;@ arm-elf-gcc -Wall -g -o p1 p1.s
;@ arm-elf-gdb p1
    .text
    .globl  main

main:
    ADR     r0, divide
    LDR     r2, =240
    BL      find_divisors
end:
    SWI     0x0

return:
    LDMFD   sp!, {pc}

find_divisors:
    STMFD   sp!, {lr}
    MOV     r7, r0                  ;@ r7 = r0
    MOV     r3, r2, LSR #1          ;@ r3 = upper bound
    MOV     r4, #2                  ;@ r4 = current divisor
fp_loop_div:
    CMP     r3, r4                  ;@ n/2 - divisor
    BMI     finish
    STMFD   sp!, {r0-r7}            ;@ push local registers
    STMFD   sp!, {r2, r4}           ;@ push arguments
    BL      div
    LDMFD   sp!, {r11, r12}         ;@ pop return
    LDMFD   sp!, {r0-r7}            ;@ pop local registers
    CMP     r12, #0
    STREQ   r4, [r7], #4            ;@ save divisor
    ADD     r4, r4, #1              ;@ divisor += 1
    B       fp_loop_div
finish:
    LDR     r8, =0xffffffff
    STR     r8, [r7], #4
    B       return

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

divide:
    .word 0
