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

    LDR     r0, =nproc                          ;@ recupera nproc
    MOV     r1, #1
    STR     r1, [r0]                            ;@ salva processo inicial 1 em nproc[0]
    LDR     r1, =linhaA                         
    STR     r1, [r0, #4]                        ;@ salva linhaA em nproc[1]
    LDR     r1, =linhaB            
    STR     r1, [r0, #8]                        ;@ salva linhaB em nproc[2]
    LDR     r1, =linhaC
    STR     r1, [r0, #12]                       ;@ salva linhaC em nproc[3]

    
    LDR     r0, =linhaB                         ;@ inicializacao linhaB
    LDR     r1, =B_stack_top                    ;@ inicializa stack pointer
    STR     r1, [r0, #52]                       ;@ sp = r13 = 13*4 = 52
    LDR     r1, =taskB                          ;@ inicializa pc
    STR     r1, [r0, #60]                       ;@ pc = r15 = 15*4 = 60
    MRS     r1, cpsr                            ;@ inicializa cpsr
    BIC     r1, r1, #0x80                       ;@ enable interrupts in the cpsr
    STR     r1, [r0, #64]                       ;@ cpsr = 16*4 = 64

    LDR     r0, =linhaC                         ;@ inicializacao linhaC
    LDR     r1, =C_stack_top                    ;@ inicializa stack pointer
    STR     r1, [r0, #52]                       ;@ sp = r13 = 13*4 = 52
    LDR     r1, =taskC                          ;@ inicializa pc
    STR     r1, [r0, #60]                       ;@ pc = r15 = 15*4 = 60
    MRS     r1, cpsr                            ;@ inicializa cpsr
    BIC     r1, r1, #0x80                       ;@ enable interrupts in the cpsr
    STR     r1, [r0, #64]                       ;@ cpsr = 16*4 = 64

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
    
taskC:
    BL      processC

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


    LDR     r0, =nproc                          ;@ load addr nproc
    LDR     r1, [r0]                            ;@ r1 =  1, 2 ou 3 (processo corrente)
    LDR     lr, [r0, r1, LSL #2]                ;@ lr = linha A, B ou C com base no processo corrente
    ADD     r1, r1, #1                          ;@ r1++
    SUB     r2, r1, #4                          ;@ compara r1 com qtd de processos + 1 (caso aumente n processos alterar aqui)
    CMP     r2, #0                              
    MOVEQ   r1, #1                              ;@ caso r1 > processos+1, r1 = 1
    STR     r1, [r0]                            ;@ atualiza nproc = r1
    
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

    LDR     r0, =nproc                          ;@ load addr nproc
    LDR     r1, [r0]                            ;@ r1 =  1, 2 ou 3 (processo seguinte)
    LDR     r12, [r0, r1, LSL #2]               ;@ lr = linha A, B ou C com base no processo seguinte

    MRS     r0, cpsr                            ;@ salvando o modo corrente em R0
    MSR     cpsr_ctl, #0b11010011               ;@ alterando o modo para supervisor
    LDR     sp, [r12, #52]                      ;@ sp = r13 = 13*4 = 52
    LDR     lr, [r12, #56]                      ;@ lr = r14 = 14*4 = 56
    MSR     cpsr, r0                            ;@ volta para o modo anterior
    
    MOV     lr, r12
    LDR     r0, [lr, #60]                       ;@ pc = r15 = 15*4 = 60
    STMFD   sp!, {r0}
    LDMIA   lr, {r0-r12}
    STMFD   sp!, {r0-r12}                       ;@ Empilha os registradores

    LDR     r0, [lr, #64]                       ;@ cpsr = 16*4 = 64
    MSR     spsr, r0
    LDMFD   sp!, {r0-r12,pc}^

INTPND:     .word 0x10140000                    ;@Interrupt status register
INTSEL:     .word 0x1014000C                    ;@interrupt select register( 0 = irq, 1 = fiq)
INTEN:      .word 0x10140010                    ;@interrupt enable register
TIMER0L:    .word 0x101E2000                    ;@Timer 0 load register
TIMER0V:    .word 0x101E2004                    ;@Timer 0 value registers
TIMER0C:    .word 0x101E2008                    ;@timer 0 control register
TIMER0X:    .word 0x101E200c                    ;@timer 0 interrupt clear register
