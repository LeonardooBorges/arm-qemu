@ arm-elf-gcc -Wall -g -o item-5-5-4 item-5-5-4.s
@ arm-elf-gdb item-5-5-4
	.text
	.globl main
main:
	MOV	r8, #5			;@ Y (101)
	MOV	r9, #3			;@ Y length (3)
	LDR	r1, =0x5555AAAA 	;@ X (1010101010101011010101010101010)
	LDR	r2, =0x0		;@ Z (output)
        MOV     r11, #1                 ;@ constant 1
        BL      and_comparator          ;@ setup and comparator in r7
	BL	recognize               ;@ regonize algorithm
	SWI	0x123456

and_comparator:
        MOV     r7, #1                  ;@ initialize and comparator
        MOV     r0, #1                  ;@ count
and_loop:
        CMP     r0, r9
        MOVEQ   pc, lr
        ADD     r7, r11, r7, LSL #1     ;@ shift r7 left and add 1
        ADD     r0, r0, #1
        B       and_loop

recognize:
        MOV     r0, #0                  ;@ count
        MOV     r5, r8                  ;@ copy of r8 (Y)
loop:
        ADD     r6, r9, r0              ;@ length + count
        CMP     r6, #33                 ;@ stop condition
        MOVEQ   pc, lr
        AND     r6, r1, r7              ;@ set ignore bits to zero
        CMP     r6, r5
        ADDEQ   r2, r2, r11, LSL r0     ;@ add previous value to output Z
        MOV     r7, r7, LSL #1          ;@ shift left and comparator
        MOV     r5, r5, LSL #1          ;@ shift left copy of Y
        ADD     r0, r0, #1
        B       loop
        
