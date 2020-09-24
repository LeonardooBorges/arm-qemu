@ arm-elf-gcc -Wall -g -o item-5-5-1 item-5-5-1.s
@ arm-elf-gdb item-5-5-1
	.text
	.globl main
main:
      ADR 	r0, array_b     	  ;@ carrega endereço do array_b[0]
      ADR 	r8, array_a 		  ;@ carrega endereço do array_a[0]
      MOV 	r1, #0                ;@ contador = 0
check: 
      CMP 	r1, #8                ;@ checa se contador < 8
      BNE 	loop                  ;@ se contador nao for igual a 8 pula para a label loop
      B 	exit                  ;@ caso contrario pula para exit
loop:
      RSB 	r2, r1, #7		      ;@ R2 = 7 - R1
      ;@MOV r4, r2, LSL #2		  ;@ multiplicamos por 4 para obter o endereço de array_b[7-i]
      LDR 	r3, [r0, r2, LSL #2]  ;@ carrega o valor na posição correta e guarda no registrador R7
      STR 	r3, [r8], #4          ;@ guarda o valor no array_a, atualizando a posição R8 = R8 + 4
      ADD 	r1, r1, #1            ;@ contador -= 1
      B 	check
exit:
      SWI 	0x123456            

array_b:  
	.word 1,2,3,4,5,6,7,8  
array_a:  
	.word 0,0,0,0,0,0,0,0
