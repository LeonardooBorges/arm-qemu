.global _start

_start:
	MOV R1, #10
	MOV R2, #20
	ADD R3, R1, R2
	SWI 0

end:
	MOV R7, #1
	SWI 0

