.section INTERRUPT_VECTOR, "x"
.global _Reset
_Reset:
  B Reset_Handler           /* Reset */
  B Undefined_Handler       /* Undefined */
  B . /* SWI */
  B . /* Prefetch Abort */
  B . /* Data Abort */
  B . /* reserved */
  B . /* IRQ */
  B . /* FIQ */
 
Reset_Handler:
  LDR sp, =stack_top
  MRS r0, cpsr                  @ salvando o modo corrente em R0
  MSR cpsr_ctl, #0b11011011     @ alterando o modo para undefined 
  LDR sp, =undefined_stack_top  @ a pilha de undefined eh setada
  MSR cpsr, r0                  @ volta para o modo anterior
  MRS r0, cpsr                  @ salvando o modo corrente em R0
  MSR cpsr_ctl, #0b11010000     @ alterando o modo para usuario 
  MSR cpsr, r0                  @ volta para o modo anterior
  MRS r0, cpsr                  @ salvando o modo corrente em R0
  MSR cpsr_ctl, #0b11010111     @ alterando o modo para abort
  MSR cpsr, r0                  @ volta para o modo anterior
  MRS r0, cpsr                  @ salvando o modo corrente em R0
  MSR cpsr_ctl, #0b11010011     @ alterando o modo para supervisor
  MSR cpsr, r0                  @ volta para o modo anterior
  .word 0xffffffff
  BL c_entry
  B .

Undefined_Handler:
  STMFD sp!, {R0-R12,lr}
  BL undefined
  LDMFD sp!,{R0-R12,pc}^
