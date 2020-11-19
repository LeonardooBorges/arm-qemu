.text
.code 32
.global reset_handler, vectors_start, vectors_end, lock, unlock, system_call, get_pid, sleep, wakeup

reset_handler:
    LDR     sp, =svc_stack_top
    
    MOV     r5, #1                             ;@ qtd de processos
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

    LDR     r11, =svc_stack_top                 ;@ inicializa stack pointer do modo kernel
    MUL     r1, r7, r10
    ADD     r1, r1, r11
    STR     r1, [r0, #68]                       ;@ sp_kernel = 17*4 = 68

    LDR     r1, =task                           ;@ inicializa pc
    STR     r1, [r0, #60]                       ;@ pc = r15 = 15*4 = 60

    MRS     r1, cpsr                            ;@ inicializa cpsr
    BIC     r1, r1, #0x8F                       ;@ enable interrupts in the cpsr + coloca processo em modo usuario
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

    MRS     r0, cpsr                            ;@ salvando o modo corrente em R0
    MSR     cpsr_ctl, #0b11011111               ;@ alterando o modo para system processo inicial
    LDR     sp, =stack_top                      ;@ a pilha de system eh setada
    MSR     cpsr, r0    

    BL      copy_vectors
    BL      init_uart
    BL      Timer_Init
    MSR     cpsr_ctl, #0b01010000               ;@ alterando o modo do primeiro processo para usuario

task:
    BL      process
    B .

Timer_Init:
    LDR     r0, INTEN
    LDR     r1, =0x10                           ;@bit 4 for timer 0 interrupt enable
    STR     r1, [r0]
    LDR     r0, TIMER0L
    LDR     r1, =0xfffff                          ;@setting timer value
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
    LDMFD   sp!, {r0-r12,pc}^

system_call:
    MOV     r7, r0
    MOV	    r8, r1
    SWI     0x0
    MOV     pc, lr

SWI_Handler:
    STMFD   sp!, {lr}                    ;@Empilha os registradores
    MRS     r0, cpsr
    BIC     r0, r0, #0x80
    MSR     cpsr_c, r0                          ;@enabling interrupts in the cpsr
    MOV     r0, r7
    MOV     r1, r8
    BL      SWI_Handler_C
    LDMFD   sp!, {pc}^

get_pid:
    LDR     r1, =nproc                          ;@ load addr nproc
    LDR     r0, [r1, #4]                        ;@ r0 = processo corrente
    MOV     pc, lr

sleep:
    STMFD   sp!, {r0-r12,lr}
    LDR     r1, =nproc                          ;@ load addr nproc
    LDR     r0, [r1, #4]                        ;@ r0 = processo corrente
    LDR     r12, =linha                         ;@ encontra linhaX
    LDR     r10, =0x1000
    MUL     r3, r0, r10
    ADD     r12, r3, r12                        ;@ r12 = linhaX
    MOV     r5, #1
    STR     r5, [r12, #80]			;@ coloca estado = bloqueado
    B	    Timer_Handler

wakeup:
    LDR     r12, =linha                         ;@ encontra linhaX
    LDR     r10, =0x1000
    MUL     r3, r0, r10
    ADD     r12, r3, r12                        ;@ r12 = linhaX
    MOV     r5, #0
    STR     r5, [r12, #80]			;@ coloca estado = pronto
    MOV     pc, lr 
    
IRQ_Handler:                                    ;@Rotina de interrupções IRQ
    SUB     lr, lr, #4
    STMFD   sp!, {r0-r12,lr}                    ;@Empilha os registradores
    
    LDR     r0, INTPND                          ;@Carrega o registrador de status de interrupção
    LDR     r0, [r0]
    TST     r0, #0x0010                         ;@verifica se é uma interupção de timer
    BNE     Timer_Handler                       ;@vai para o rotina de tratamento da interupção de timer
    BLEQ    VIC_Init            		;@Chama VIC_Init() in C
    LDMFD   sp!, {r0-r12,pc}^

Timer_Handler:
    LDR     r0, TIMER0X
    MOV     r1, #0x0
    STR     r1, [r0]                            ;@Escreve no registrador TIMER0X para limpar o pedido de interrupção

    LDR     r0, =nproc                          ;@ load addr nproc
    LDR     r2, [r0]                            ;@ qtd de processos total
    LDR     r1, [r0, #4]                        ;@ r1 = processo corrente

    LDR     r12, =linha                         ;@ encontra linhaX
    LDR     r10, =0x1000
    MUL     r3, r1, r10
    ADD     lr, r3, r12                         ;@ lr = linhaX    

Loop_Estado:
    ADD     r1, r1, #1                          ;@ r1++
    SUB     r2, r1, r2                          ;@ compara r1 com qtd de processos
    CMP     r2, #0                              
    MOVEQ   r1, #0                              ;@ caso r1 > processos, r1 = 0
    LDR     r12, =linha                         ;@ encontra linhaX
    LDR     r10, =0x1000
    MUL     r3, r1, r10
    ADD     r4, r3, r12                         ;@ r4 = linhaX
    LDR     r5, [r4, #80]			;@ estado = 20*4 = 80   
    CMP	    r5, #1				;@ verifica se estado == bloqueado
    BEQ	    Loop_Estado				;@ se estiver bloqueado, vai para o proximo processo    

    STR     r1, [r0, #4]                        ;@ atualiza nproc = r1
    
    LDMFD   sp!, {r0-r12}
    STMIA   lr!, {r0-r12}

    LDMFD   sp!, {r3}                           ;@ pega o lr da pilha
    MRS     r4, spsr                            ;@ cpsr anterior

    MRS     r0, cpsr                            ;@ salvando o modo corrente em R0

    MSR     cpsr_ctl, #0b11011111               ;@ alterando o modo para system
    MOV     r1, sp                              ;@ sp do modo usuário
    MOV     r2, lr                              ;@ lr do modo usuário
    MSR     cpsr_ctl, #0b11010011               ;@ alterando o modo para o supervisor
    MOV     r5, sp                              ;@ sp do modo supervisor
    MOV     r6, lr                              ;@ lr do modo supervisor
    MRS	    r7, spsr				;@ spsr do modo supervisor

    MSR     cpsr, r0                            ;@ volta para o modo anterior

    STMIA   lr!, {r1,r2,r3,r4,r5,r6,r7}         ;@ salva sp, lr, pc, cpsr, sp_supervisor, lr_supervisor, spsr_supervisor

    LDR     r0, =nproc                          ;@ load addr nproc
    LDR     r1, [r0, #4]                        ;@ r1 = processo corrente

    LDR     r12, =linha                         ;@ encontra linhaX
    LDR     r10, =0x1000
    MUL     r3, r1, r10
    ADD     r12, r3, r12                        ;@ r12 = linhaX

    MRS     r0, cpsr                            ;@ salvando o modo corrente em R0

    MSR     cpsr_ctl, #0b11011111               ;@ alterando o modo para system
    LDR     sp, [r12, #52]                      ;@ sp = r13 = 13*4 = 52
    LDR     lr, [r12, #56]                      ;@ lr = r14 = 14*4 = 56
    MSR     cpsr_ctl, #0b11010011               ;@ alterando o modo para o supervisor
    LDR     sp, [r12, #68]                      ;@ sp = r17 = 17*4 = 68
    LDR     lr, [r12, #72]                      ;@ lr = r18 = 18*4 = 72
    LDR     r1, [r12, #76]                      ;@ cpsr = 19*4 = 76
    MSR     spsr, r1				;@ atualiza spsr do modo supervisor

    MSR     cpsr, r0                            ;@ volta para o modo anterior
    
    MOV     lr, r12
    LDR     r0, [lr, #60]                       ;@ pc = r15 = 15*4 = 60
    STMFD   sp!, {r0}
    LDMIA   lr, {r0-r12}
    STMFD   sp!, {r0-r12}                       ;@ Empilha os registradores

    LDR     r0, [lr, #64]                       ;@ cpsr = 16*4 = 64
    MSR     spsr, r0
    LDMFD   sp!, {r0-r12,pc}^

undef_handler:

prefetch_abort_handler:
data_abort_handler:
fiq_handler:
    b .

lock:
    mrs r0, cpsr
    orr r0, r0, #0x80 // set the I bit to disable IRQ
    msr cpsr, r0
    mov pc, lr // return, by ARM C calling convention, the lr=pc-4, i.e. the next instruction

unlock:
    mrs r0, cpsr
    bic r0, r0, #0x80 // clear the I bit to enable IRQ
    msr cpsr, r0
    mov pc, lr

INTPND:     .word 0x10140000                    ;@Interrupt status register
INTSEL:     .word 0x1014000C                    ;@interrupt select register( 0 = irq, 1 = fiq)
INTEN:      .word 0x10140010                    ;@interrupt enable register
TIMER0L:    .word 0x101E2000                    ;@Timer 0 load register
TIMER0V:    .word 0x101E2004                    ;@Timer 0 value registers
TIMER0C:    .word 0x101E2008                    ;@timer 0 control register
TIMER0X:    .word 0x101E200c                    ;@timer 0 interrupt clear register

vectors_start:
    ldr pc, reset_handler_addr
    ldr pc, undef_handler_addr
    ldr pc, swi_handler_addr
    ldr pc, prefetch_abort_handler_addr
    ldr pc, data_abort_handler_addr
    b .
    ldr pc, irq_handler_addr
    ldr pc, fiq_handler_addr

reset_handler_addr:              .word reset_handler
undef_handler_addr:              .word Undefined_Handler
swi_handler_addr:                .word SWI_Handler
prefetch_abort_handler_addr:     .word prefetch_abort_handler
data_abort_handler_addr:         .word data_abort_handler
irq_handler_addr:                .word IRQ_Handler
fiq_handler_addr:                .word fiq_handler
vectors_end:
