ENTRY(reset_handler)
SECTIONS
{
	. = 0x10000; /* loading address */
	.text : {*(.text)}
	.data : {*(.data)}
	.bss : {*(.bss)}
	.data : {*(image.o)}

	. = ALIGN(8);
	. = . + 0x10000; /* 64KB of SVC stack */
    	svc_stack_top = .;
 	. = . + 0x1000; /* 4kB of stack memory */
 	undefined_stack_top = .;
 	. = ALIGN(8);
 	. = . + 0x1000; /* 4kB of stack memory */
 	IRQ_stack_top = .;
 	. = ALIGN(8);
 	. = . + 0x1000; /* 4kB of stack memory */
 	stack_top = .;
 	. = ALIGN(8);
 	. = . + 0x10000; /* 64kB of stack memory */
 	linha = .;
 	. = ALIGN(8);
 	. = . + 0x10000; /* 64kB of stack memory */
 	nproc = .;
}
