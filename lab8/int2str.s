    .text
    .globl  int2str
			
int2str:                     	    ;@ Function "int2str" entry point. r0 = int, r1 = pointer
    STMFD   sp!, {lr}
    MOV     r2, r0                  ;@ n
    MOV     r3, #10                 ;@ divisor
    MOV     r4, #0                  ;@ counter
    
loop:
    ADD     r4, r4, #1
    STMFD   sp!, {r0-r4}            ;@ push local registers
    STMFD   sp!, {r2, r3}           ;@ push arguments
    BL      div
    LDMFD   sp!, {r7, r8}           ;@ pop return
    LDMFD   sp!, {r0-r4}            ;@ pop local registers
    ADD     r8, r8, #0x30           ;@ to ascii code
    STMFD   sp!, {r8}               ;@ push to stack
    MOV     r2, r7                  ;@ n=n/10
    CMP     r7, #0
    BNE     loop

pointer:
    MOV     r5, #0
loop_p:
    CMP     r4, r5
    BEQ     finish
    LDMFD   sp!, {r6}
    STRB    r6, [r1, r5]
    ADD     r5, r5, #1
    B       loop_p
finish:
    MOV     r6, #0
    STRB    r6, [r1, r5]
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

return:
    LDMFD   sp!, {pc}
