;	SI	Location of GPT
verify_gpt:
	PUSHA
		
	MOV DI, gpt_magic_num
	MOV CX, 8
	CALL blkcmp
	
	JNC _bad_magic
	
	MOV AX, [SI + 0x50]
	OR AX, AX
	JZ _no_parts
	
	POPA
	RET
	
	_bad_magic:
		MOV AX, 0x2000
		JMP error
	
	_no_parts:
		MOV AX, 0x2100
		JMP error

;	SI	Location of first entry
;	DI	Location to read to
load_boot_part:
	PUSHA
	
	PUSH DI
	
	MOV DI, efs_magic_num
	MOV CX, 16
	MOV DX, [SI - 0x200 + 0x50]
	_checkboot:
		CALL blkcmp
		JC _isboot
		DEC DX
		JZ error
		ADD SI, 128
		JMP _checkboot
	
	_isboot:
	ADD SI, 0x20
	MOV DI, fslba
	MOV CX, 2
	REP MOVSD
	MOV SI, fslba
	POP DI
	MOV CX, 1
	XOR BX, BX
	CALL read_block
	
	POPA
	RET
