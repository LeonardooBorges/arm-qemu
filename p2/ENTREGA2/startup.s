;@ Em um terminal fazer: ./run_startup.sh
;@ Em um segundo terminal fazer: ./run_qemu.sh

.section INTERRUPT_VECTOR, "x"
.global _Reset
_Reset:
    B       Reset_Handler           /* Reset */
    B       Undefined_Handler       /* Undefined */
    B       . /* SWI */
    B       . /* Prefetch Abort */
    B       . /* Data Abort */
    B       . /* reserved */
    B       IRQ_Handler 
    B       . /* FIQ */
 
Reset_Handler:
    LDR     sp, =A_stack_top
    
    LDR     r0, =linhaB                         ;@ inicializacao linhaB
    LDR     r1, =B_stack_top                    ;@ inicializa stack pointer
    STR     r1, [r0, #52]                       ;@ sp = r13 = 13*4 = 52
    LDR     r1, =taskB                          ;@ inicializa pc
    STR     r1, [r0, #60]                       ;@ pc = r15 = 15*4 = 60
    MRS     r1, cpsr                            ;@ inicializa cpsr
    BIC     r1, r1, #0x80                       ;@ enable interrupts in the cpsr
    STR     r1, [r0, #64]

    MRS     r0, cpsr                            ;@ salvando o modo corrente em R0
    MSR     cpsr_ctl, #0b11011011               ;@ alterando o modo para undefined
    LDR     sp, =undefined_stack_top            ;@ a pilha de undefined eh setada
    MSR     cpsr, r0                            ;@ volta para o modo anterior
    
    MRS     r0, cpsr                            ;@ salvando o modo corrente em R0
    MSR     cpsr_ctl, #0b11010010               ;@ alterando o modo para IRQ
    LDR     sp, =IRQ_stack_top                  ;@ a pilha de undefined eh setada
    MSR     cpsr, r0                            ;@ volta para o modo anterior

    BL      Timer_Init
    
taskA:
    BL      processA

taskB:
    BL      processB
    
    B .

Timer_Init:
    LDR     r0, INTEN
    LDR     r1, =0x10                           ;@bit 4 for timer 0 interrupt enable
    STR     r1, [r0]
    LDR     r0, TIMER0L
    LDR     r1, =0xfff                          ;@setting timer value
    STR     r1, [r0]
    LDR     r0, TIMER0C
    MOV     r1, #0xE0                           ;@enable timer module
    STR     r1, [r0]
    MRS     r0, cpsr
    BIC     r0, r0, #0x80
    MSR     cpsr_c, r0                          ;@enabling interrupts in the cpsr
    MOV     pc, lr

Undefined_Handler:
    STMFD   sp!, {r0-r12,lr}                    ;@Empilha os registradores
    BL      undefined
    LDMFD   sp!, {r0-r12,pc}^

IRQ_Handler:                                    ;@Rotina de interrupções IRQ
    SUB     lr, lr, #4
    STMFD   sp!, {r0-r12,lr}                    ;@Empilha os registradores
    
    LDR     r0, INTPND                          ;@Carrega o registrador de status de interrupção
    LDR     r0, [r0]
    TST     r0, #0x0010                         ;@verifica se é uma interupção de timer
    BNE     Timer_Handler                       ;@vai para o rotina de tratamento da interupção de timer
    
    LDMFD   sp!, {r0-r12,pc}^

Timer_Handler:
    LDR     r0, TIMER0X
    MOV     r1, #0x0
    STR     r1, [r0]                            ;@Escreve no registrador TIMER0X para limpar o pedido de interrupção

    BL      print_hashtag

    LDR     lr, =nproc
    LDR     r0, [lr]
    CMP     r0, #0
    LDREQ   lr, =linhaA
    LDRNE   lr, =linhaB
    
    LDMFD   sp!, {r0-r12}
    STMIA   lr!, {r0-r12}

    LDMFD   sp!, {r3}                           ;@ pega o lr da pilha
    MRS     r4, spsr                            ;@ cpsr anterior

    MRS     r0, cpsr                            ;@ salvando o modo corrente em R0
    MSR     cpsr_ctl, #0b11010011               ;@ alterando o modo para supervisor
    MOV     r1, sp                              ;@ sp do processo corrente
    MOV     r2, lr                              ;@ lr do processo corrente
    MSR     cpsr, r0                            ;@ volta para o modo anterior

    STMIA   lr!, {r1,r2,r3,r4}                  ;@ salva sp, lr, pc e cpsr

    MOV     r0, #0
    MOV     r1, #1
    LDR     r12, =nproc
    LDR     r11, [r12]
    
    CMP     r11, #0
    STREQ   r1, [r12]
    LDREQ   r12, =linhaB
    STRNE   r0, [r12]
    LDRNE   r12, =linhaA

    LDR     r0, [r12, #64]
    MSR     cpsr, r0
    LDMIA   r12, {r0-r15}

INTPND:     .word 0x10140000                    ;@Interrupt status register
INTSEL:     .word 0x1014000C                    ;@interrupt select register( 0 = irq, 1 = fiq)
INTEN:      .word 0x10140010                    ;@interrupt enable register
TIMER0L:    .word 0x101E2000                    ;@Timer 0 load register
TIMER0V:    .word 0x101E2004                    ;@Timer 0 value registers
TIMER0C:    .word 0x101E2008                    ;@timer 0 control register
TIMER0X:    .word 0x101E200c                    ;@timer 0 interrupt clear register
