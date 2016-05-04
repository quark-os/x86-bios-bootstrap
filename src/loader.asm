;	SI	Offset of ELF
;	DS	Segment of ELF
parseELF:
	PUSHA
	
	MOV DI, elf_magic_num
	MOV CX, 4
	REPE CMPSB
	JNE error
	
	MOV BX, SI
	
	MOV CX, [DS:SI + 0x2C]
	XOR DX, DX
	ADD SI, [DS:SI + 0x1C]
	
	_sectionloop:
		MOV AX, [DS:SI]
		OR AX, AX
		LOOPZ _sectionloop
		
		PUSH CX
		
		; Zero memory block
		MOV CX, [DS:SI + 20]
		MOV DI, [DS:SI + 8]
		MOV AX, [DS:SI + 10]
		AND AX, 0x000F
		SHR AX, 4	; Extract segment from upper part of pointer
		MOV ES, AX
		CALL blkzero
		
		PUSH SI ; Save location in program header array
		
		; Copy data from file, use dest parameters from before
		MOV CX, [DS:SI + 16]
		MOV AX, [DS:SI + 4]
		MOV SI, BX ; Restore SI to start of ELF
		ADD SI, AX
		REP MOVSB
		
		POP SI ; Restore location in program header array
		
		ADD SI, 32 ; Move to next element in array
		POP CX ; Restore array counter
		LOOP _sectionloop
		
	POP SI
	
	; ELF is parsed i guess
	
	POPA
	RET
