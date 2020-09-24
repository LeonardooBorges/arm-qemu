@ arm-elf-gcc -Wall -g -o item-5-5-2 item-5-5-2.s
@ arm-elf-gdb item-5-5-2
	.text
	.globl main
main:
	MOV		r6, #0xA	@ load 10 into r6 (result)
	MOV		r4, r6		@ copy n into a temp register (current val)
loop:
	SUBS	r4, r4, #1	@ decrement next multiplier
	MULNE	r7, r6, r4	@ perform multiply (intermediate result)
	MOVNE	r6, r7		@ save off product for another loop
	BNE		loop		@ go again if not complete
exit:
      SWI 0x123456            


