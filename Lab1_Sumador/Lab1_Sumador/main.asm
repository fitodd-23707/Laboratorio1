;
; Lab1_Sumador.asm
;
; Created: 6/02/2025 08:39:10
; Author : Arnulfo Díaz
;

.include "m328def.inc"

.cseg
.org 0x0000


//Congigurar pila
LDI R16, LOW(RAMEND)
OUT SPL, R16
LDI R16, HIGH(RAMEND)
OUT SPL, R16

SETUP:
	//Configurar pines de entrada y salida (DDRx, PORTx, PINx)
	LDI		R16, 0xFF
	OUT		DDRD, R16
	LDI		R16, 0x00
	OUT		PORTD, R16

	LDI		R16, 0xFF                           //port d salidas contadores
	OUT		DDRC, R16                           //port b botones 
	LDI		R16, 0x00
	OUT		PORTC, R16 //puerto d para contadores y los otros para botones y suma

	LDI		R16, 0x00
	OUT		DDRB, R16
	OUT		PORTB, R16

	LDI		R17, 0x00

	LDI		R16, (1 << CLKPCE)
	STS		CLKPR, R16
	LDI		R16, 0x04
	STS		CLKPR, R16

	LDI		R16, 0x00

LOOP:
	IN		R18, PINB // Guardando el estado de PORTB en R18
	OUT		PORTD, R16
	OUT		PORTC, R20
	CP		R17, R18 // Comparamos estado "viejo" con estado "nuevo"
	BREQ	LOOP
	CALL	DELAY
	IN		R18, PINB
	CP		R17, R18
	BREQ	LOOP
	// Volver a leer PIND
	MOV		R17, R18
	SBRC	R18, 0
	CALL		SUMAR1
	SBRC	R18, 1
	CALL		RESTAR1
	SBRC	R18, 2
	CALL		SUMAR2
	SBRC	R18, 3
	CALL		RESTAR2
	SBRC	R18, 4
	CALL		DOSUM
	RJMP	LOOP
	

SUMAR1:
	INC		R16
	JMP		LOOP

SUMAR2:
	SWAP	R19
	INC		R19
	SWAP	R19
	ANDI	R16, 0x0F
	ANDI	R19, 0xF0
	OR		R16, R19
	JMP		LOOP

RESTAR1:
	DEC		R16
	JMP		LOOP

RESTAR2:
	SWAP	R19
	DEC		R19
	SWAP	R19
	ANDI	R16, 0x0F
	ANDI	R19, 0xF0
	OR		R16, R19
	JMP		LOOP

DOSUM:
	MOV		R20, R16
	ANDI	R20, 0x0F
	MOV		R21, R19
	SWAP	R21
	ADD		R20, R21
	BRBS	5, CARRY_SET
	JMP		LOOP

CARRY_SET:
	ANDI	R20, 0x0F
	LDI		R22, 0x10
	OR		R20, R22
	JMP		LOOP

DELAY:
	LDI R18, 0xFF
SUB_DELAY1:
	DEC R18
	CPI R18, 0
	BRNE SUB_DELAY1
	LDI R18, 0xFF
SUB_DELAY2:
	DEC R18
	CPI R18, 0
	BRNE SUB_DELAY2
	LDI R18, 0xFF
SUB_DELAY3:
	DEC R18
	CPI R18, 0
	BRNE SUB_DELAY3
	RET
