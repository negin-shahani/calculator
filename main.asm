;====================================================================
; Main.asm file generated by New Project wizard
;
; Processor: ATmega32
; Compiler:  AVRASM (Proteus)
;====================================================================

;====================================================================
; DEFINITIONS
     
;====================================================================

;====================================================================
; VARIABLES
;====================================================================

;====================================================================
; RESET and INTERRUPT VECTORS
;====================================================================

      ; Reset Vector
      
      .ORG $200
      .DB $ee, $ed, $eb, $e7, $de, $dd, $db, $d7, $be, $bd, $bb, $b7, $7e, $7d, $7b, $77
     
       .ORG 0
      rjmp  Start
      

;====================================================================
; CODE SEGMENT
;====================================================================
        
Start:
      ; Write your code here
      ldi R23, 0
      out tccr0, r23
      ldi  r24, 4
      
      LDI R16, $f0
      OUT DDRA, R16
      
      LDI R16, $FF
      OUT DDRB, R16
      OUT DDRC, R16
      OUT DDRD, R16
      out portb, r23
      out portc, r23
      
      ; getting first number
First:
	
	
        CLR R17
	LDI r18, $EF 
AGAIN:
        OUT PORTA, R18
	IN   R20, PINA 
	ANDI R20, $0F; We only need lower part of input value
	CPI  R20, $0F
	BRNE COLUMN ; a key is pressed in this row
				    
	INC  R17
	CPI  R17, 4
	BREQ First
	
	SEC
	ROL  R18 ;next row.
	
	
	RJMP AGAIN
	
COLUMN:


c:	IN   R24, PINA 
	ANDI R24, $0F; We only need lower part of input value
	CPI  R24, $0F
	brne c
	
	out tifr, r24
	ANDI R18, $F0
	ANDI R20, $0F
	OR   R18, R20 ; R18 = Row | Column

	LDI  R31, $04
	LDI  R30, $00
	
ARRAY:
	LPM  R0, Z ; Search array, from $0100 tO $0100+15
	CP   R0, R18
	BREQ FIND_KEY
	INC  R30
	RJMP ARRAY
	
	
FIND_KEY:

	
	CPI R30, 12
	BREQ Start
	
	LDI R21, 7
	CPI R30, 0
	BREQ NUM
	
	LDI R21, 8
	CPI R30, 1
	BREQ NUM
	
	LDI R21, 9
	CPI R30, 2
	BREQ NUM
	
	CPI R30, 3
	BREQ OPERATOR1
	
	LDI R21, 4
	CPI R30, 4
	BREQ NUM
	
	LDI R21, 5
	CPI R30, 5
	BREQ NUM
	
	LDI R21, 6
	CPI R30, 6
	BREQ NUM
	
	LDI R21, 2
	CPI R30, 7
	BREQ OPERATOR2
	
	LDI R21, 1
	CPI R30, 8
	BREQ NUM
	
	LDI R21, 2
	CPI R30, 9
	BREQ NUM
	
	LDI R21, 3
	CPI R30, 10
	BREQ NUM
	
	
	CPI R30, 11
	BREQ OPERATOR3
	
	
	
	LDI R21, 0
	CPI R30, 13
	BREQ NUM
	
	
	CPI R30, 14
	BREQ EQUAL
	
	
	CPI R30, 15
	BREQ OPERATOR4
	
OPERATOR1:
       LDI R23, 2
       LDI R25, 1
       RJMP FIRST
       
OPERATOR2:
       LDI R23, 2
       LDI R25, 2
       RJMP FIRST

OPERATOR3:
       LDI R23, 2
       LDI R25, 3
       RJMP FIRST

OPERATOR4:
       LDI R23, 2
       LDI R25, 4
       RJMP FIRST
	
NUM :   
	INC R23
	clc
	CPI R23, 1; RAGHAM AVAL AZ ADADE AVAL
	BREQ N1D1
	
	clc
	CPI R23, 2
	BREQ N1D2
	
	
	CPI R23, 3
	BREQ N2D1
	
	CPI R23, 4
	BREQ N2D2
	
N1D1:
       
       OUT PORTB, R21
       MOV R1, R21
       RJMP FIRST
       
N1D2:
       clr r27
       MOV R27, R1
       SWAP R27
       OR R27, R21
       OUT PORTB, R27
       
       LDI R24, 10
       MUL R1, R24
       ADD R0, R21
       mov r1, r0
       RJMP FIRST
       
 N2D1:
       
       OUT PORTB, R21
       MOV R2, R21
       RJMP FIRST
       
N2D2:
       clr r23
       clr r27
       MOV R27, R2
       SWAP R27
       OR R27, R21
       OUT PORTB, R27
        
	 
       
       LDI R24, 10
       mov r3, r1
       MUL R2, R24
       ADd R0, R21
       mov r2, r0
       mov r1, r3
       RJMP FIRST
       
	

       
EQUAL:
	clr r30
	clr r31
       CLR R26; RESULT
       CLR R27; RESULT2
       CPI R25, 1
       BREQ DIV
       
       CPI R25, 2
       BREQ MULT
       
       CPI R25, 3
       BREQ DIF
       
       CPI R25, 4
       BREQ SUM
       
DIV:   
      
       CP R1, R2
       BRLO END
       INC R26
       SUB R1, R2
       RJMP DIV
       
MULT:  
       MOV R3, R1
       MUL R2, R3
       MOVW R26, R0
       RJMP END
       
DIF:

      SUB R1, R2
      MOV R26, R1
      RJMP END
      
SUM:
      ADD R1, R2
      MOV R26, R1
      RJMP END
      
END:
      
      CLR R29
      CLR R28
CHECK1:
      CPI R27, 0
      BRNE CONTINUE
      CPI R26, 10
      BRLO CHECK2
CONTINUE:
      ADIW R28, 1
      SBIW R26, 10
      RJMP CHECK1
      
CHECK2:
      CPI R29, 0
      BRNE CONTINUE2
      CPI R28, 10
      BRLO CHECK3
CONTINUE2:
      INC R30
      SBIW R28, 10
      RJMP CHECK2
      
CHECK3:
      CPI R30, 10
      BRLO SHOW
      INC R31
      SUBI R30, 10
      RJMP CHECK3
; R26=YEKAN  R28=DAHGAN  R30=SADGAN  R31=HEZARGAN  
SHOW:
      SWAP R28
      OR R26, R28
      OUT PORTC, R26
      
      SWAP R31
      OR R30, R31
      OUT PORTD, R30
      RJMP First
error:
;     out portd, $0E
     rjmp first
 loop: rjmp loop


;====================================================================
