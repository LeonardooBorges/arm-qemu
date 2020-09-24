@
@   
    .text
    .globl  main

main:
    ADR     r0, array
    MOV     r1, #4
    BL      mmc
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

copy_array:                         @ copy array and store addr in r10
    STMFD   sp!, {lr}
    MOV     r7, #0
ca_loop:
    CMP     r7, r1
    BEQ     ca_return
    LDR     r12, [r0, r7, LSL #2]
    STMIA   r10!, {r12}
    ADD     r7, r7, #1
    B       ca_loop
ca_return:
    SUB     r10, r10, r1, LSL #2
    B       return

check_1:
    MOV     r7, #0
c1_loop:
    CMP     r7, r1
    BEQ     return
    LDR     r12, [r10, r7, LSL #2]
    CMP     r12, #1
    MOVNE   pc, lr
    ADD     r7, r7, #1
    B       c1_loop

mmc:
    STMFD   sp!, {lr}
    BL      copy_array
    MOV     r2, #1                  @ r2 = mmc
    MOV     r5, #2                  @ r5 = d
    
mmc_loop:
    BL      check_1
    MOV     r3, #0                  @ r3 = divisor flag
    MOV     r7, #0                  @ r7 = counter
mmc_loop_i:
    CMP     r7, r1                  @ count == array_size ?
    BEQ     mmc_update
    LDR     r4, [r10, r7, LSL #2]   @ r4 = array[count]
    STMFD   sp!, {r0-r10}           @ push local registers
    STMFD   sp!, {r4, r5}           @ push arguments
    BL      div
    LDMFD   sp!, {r11, r12}         @ pop return
    LDMFD   sp!, {r0-r10}           @ pop local registers
    CMP     r12, #0                 @ if r == 0 ?
    STREQ   r11, [r10, r7, LSL #2]  @ then: n = q
    ADDEQ   r3, r3, #1              @ then: flag++
    ADD     r7, r7, #1              @ count++
    B       mmc_loop_i
mmc_update:
    CMP     r3, #0                  @ r3 == 0 ? (d is divisor of any element?)
    ADDEQ   r5, r5, #1              @ if d not divisor then  d++ 
    MULNE   r12, r2, r5             @ if d is a divisor then mmc = mmc * d
    MOVNE   r2, r12
    B       mmc_loop

div:
    LDMFD   sp!, {r1, r2}           @ pop arguments
    LDR     r3, =0                  @ r3 quotient
    LDR     r4, =0                  @ r4 remainder
    MOV     r5, r1                  @ r5 copy of dividend
    MOV     r6, r2                  @ r6 copy of divisor
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
