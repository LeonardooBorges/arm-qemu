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
    
    MRS     r0, cpsr                            ;@ salvando o modo corrente em R0
    MSR     cpsr_ctl, #0b11011011               ;@ alterando o modo para undefined
    LDR     sp, =undefined_stack_top            ;@ a pilha de undefined eh setada
    MSR     cpsr, r0                            ;@ volta para o modo anterior
    
    MRS     r0, cpsr                            ;@ salvando o modo corrente em R0
    MSR     cpsr_ctl, #0b11010100               ;@ alterando o modo para undefined
    LDR     sp, =IRQ_stack_top                  ;@ a pilha de undefined eh setada
    MSR     cpsr, r0                            ;@ volta para o modo anterior

    BL      Timer_Init

    BL      c_entry
    .word 0xffffffff
    B .

Timer_Init:
    MRS     r0, cpsr
    BIC     r0,r0,#0x80
    MSR     cpsr_c,r0                           ;@enabling interrupts in the cpsr
    LDR     r0, INTEN
    LDR     r1,=0x10                            ;@bit 4 for timer 0 interrupt enable
    STR     r1,[r0]
    LDR     r0, TIMER0C
    LDR     r1, [r0]
    MOV     r1, #0xA0                           ;@enable timer module
    LDR     r0, TIMER0L
    MOV     r1, #0xff @setting timer value
    STR     r1, [r0]
    STR     r1, [r0]

Undefined_Handler:
    BL      undefined

IRQ_Handler:                                    ;@Rotina de interrupções IRQ
    STMFD   sp!, {r0 - r3, LR}                  ;@Empilha os registradores
    LDR     r0, INTPND                          ;@Carrega o registrador de status de interrupção
    LDR     r0, [r0]
    TST     r0, #0x0010                         ;@verifica se é uma interupção de timer
    BLNE    Timer_Handler                       ;@vai para o rotina de tratamento da interupção de timer
    LDMFD   sp!, {r0 - r3,lr}                   ;@retorna
    MOV     pc, r14

Timer_Handler:
    LDR     r0, TIMER0X
    MOV     r1, #0x0
    STR     r1, [r0]                            ;@Escreve no registrador TIMER0X para limpar o pedido de interrupção

            ;@Inserir código que sera executado na interrupção de timer aqui (chaveamento de processos, ou alternar LED por exemplo)
    
    LDMFD   sp!, {r0 - r3,lr}
    MOV     pc, r14                             ;@retorna

INTPND: .word 0x10140000 @Interrupt status register
INTSEL: .word 0x1014000C @interrupt select register( 0 = irq, 1 = fiq)
INTEN: .word 0x10140010 @interrupt enable register
TIMER0L: .word 0x101E2000 @Timer 0 load register
TIMER0V: .word 0x101E2004 @Timer 0 value registers
TIMER0C: .word 0x101E2008 @timer 0 control register
TIMER0X: .word 0x101E200c @timer 0 interrupt clear register
