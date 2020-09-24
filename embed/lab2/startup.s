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
    LDR     sp, =stack_top
    
    MOV     r5, #10                             ;@ qtd de processos
    MOV     r2, #0
    LDR     r0, =nproc
    STR     r5, [r0]
    STR     r2, [r0, #4]                        ;@ processo inicial 0

    MOV     r7, #0                              ;@ count
loop_init_process:    
    CMP     r7, r5                              ;@ count < qtd processos?
    BEQ     finish_init_process
    
    LDR     r12, =linha                         ;@ encontra linhaX
    LDR     r10, =0x1000
    MUL     r1, r7, r10
    ADD     r0, r1, r12

    LDR     r11, =stack_top                     ;@ inicializa stack pointer
    MUL     r1, r7, r10
    ADD     r1, r1, r11
    STR     r1, [r0, #52]                       ;@ sp = r13 = 13*4 = 52

    LDR     r1, =task                           ;@ inicializa pc
    STR     r1, [r0, #60]                       ;@ pc = r15 = 15*4 = 60

    MRS     r1, cpsr                            ;@ inicializa cpsr
    BIC     r1, r1, #0x80                       ;@ enable interrupts in the cpsr
    STR     r1, [r0, #64]                       ;@ cpsr = 16*4 = 64

    STR     r7, [r0]                            ;@ inicializa r0 com numero de seu proprio processo

    ADD     r7, r7, #1
    B       loop_init_process

finish_init_process:
    MRS     r0, cpsr                            ;@ salvando o modo corrente em R0
    MSR     cpsr_ctl, #0b11011011               ;@ alterando o modo para undefined
    LDR     sp, =undefined_stack_top            ;@ a pilha de undefined eh setada
    MSR     cpsr, r0                            ;@ volta para o modo anterior
    
    MRS     r0, cpsr                            ;@ salvando o modo corrente em R0
    MSR     cpsr_ctl, #0b11010010               ;@ alterando o modo para IRQ
    LDR     sp, =IRQ_stack_top                  ;@ a pilha de undefined eh setada
    MSR     cpsr, r0                            ;@ volta para o modo anterior

    BL      Timer_Init
    MOV     r0, #0
    
task:
    ADD     r0, r0, #48
    BL      print_uart0_char
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
    LDR     r2, [r0]                            ;@ qtd de processos total
    LDR     r1, [r0, #4]                        ;@ r1 = processo corrente

    LDR     r12, =linha                         ;@ encontra linhaX
    LDR     r10, =0x1000
    MUL     r3, r1, r10
    ADD     lr, r3, r12                         ;@ lr = linhaX

    ADD     r1, r1, #1                          ;@ r1++
    SUB     r2, r1, r2                          ;@ compara r1 com qtd de processos
    CMP     r2, #0                              
    MOVEQ   r1, #0                              ;@ caso r1 > processos, r1 = 0
    STR     r1, [r0, #4]                        ;@ atualiza nproc = r1
    
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
    LDR     r1, [r0, #4]                        ;@ r1 = processo corrente

    LDR     r12, =linha                         ;@ encontra linhaX
    LDR     r10, =0x1000
    MUL     r3, r1, r10
    ADD     r12, r3, r12                        ;@ r12 = linhaX

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
