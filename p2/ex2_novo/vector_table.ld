ENTRY(_Reset)
SECTIONS
{
 . = 0x0;
 .text : {
 startup.o (INTERRUPT_VECTOR)
 *(.text)
 }
 .data : { *(.data) }
 .bss : { *(.bss COMMON) }
 . = ALIGN(8);
 . = . + 0x1000; /* 4kB of stack memory */
 A_stack_top = .;
 . = ALIGN(8);
 . = . + 0x1000; /* 4kB of stack memory */
 B_stack_top = .;
 . = ALIGN(8);
 . = . + 0x1000; /* 4kB of stack memory */
 C_stack_top = .;
 . = ALIGN(8);
 . = . + 0x1000; /* 4kB of stack memory */
 undefined_stack_top = .;
 . = ALIGN(8);
 . = . + 0x1000; /* 4kB of stack memory */
 IRQ_stack_top = .;
 . = ALIGN(8);
 . = . + 0x1000; /* 4kB of stack memory */
 linhaA = .;
 . = ALIGN(8);
 . = . + 0x1000; /* 4kB of stack memory */
 linhaB = .;
 . = ALIGN(8);
 . = . + 0x1000; /* 4kB of stack memory */
 linhaC = .;
 . = ALIGN(8);
 . = . + 0x1000; /* 4kB of stack memory */
 nproc = .;
}
