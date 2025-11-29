.MODEL SMALL

.STACK 100H



.DATA

    PROMPT    DB 'Enter a string: $'

    NEWLINE   DB 0DH, 0AH, '$'

    EQUALS    DB ' = $'

    SEPARATOR DB ' | $'

    SUFFIX    DB 'h$'

    MSG_AGAIN DB 0DH, 0AH, 0DH, 0AH, 'Do you need to convert other string (y/n)? $'

    

    BUFFER    DB 100, ?, 100 DUP('$') 



.CODE

MAIN PROC

    MOV AX, @data

    MOV DS, AX



START:

    LEA DX, PROMPT

    MOV AH, 09H

    INT 21H



    LEA DX, BUFFER

    MOV AH, 0AH

    INT 21H



    LEA DX, NEWLINE

    MOV AH, 09H

    INT 21H



    XOR CX, CX

    MOV CL, BUFFER[1]

    CMP CL, 0

    JE ASK_USER



    LEA SI, BUFFER[2]



PROCESS_LOOP:

    PUSH CX



    MOV DL, [SI]

    MOV AH, 02H

    INT 21H



    LEA DX, EQUALS

    MOV AH, 09H

    INT 21H



    MOV AL, [SI]

    XOR AH, AH

    CALL PRINT_DEC



    LEA DX, SEPARATOR

    MOV AH, 09H

    INT 21H



    MOV AL, [SI]

    CALL PRINT_HEX

    

    LEA DX, SUFFIX

    MOV AH, 09H

    INT 21H



    LEA DX, NEWLINE

    MOV AH, 09H

    INT 21H



    INC SI

    POP CX

    LOOP PROCESS_LOOP



ASK_USER:

    LEA DX, MSG_AGAIN

    MOV AH, 09H

    INT 21H



    MOV AH, 01H

    INT 21H



    CMP AL, 'y'

    JE RESTART_PROG

    CMP AL, 'Y'

    JE RESTART_PROG

    

    CMP AL, 'n'

    JE EXIT_PROG

    CMP AL, 'N'

    JE EXIT_PROG

    

    JMP ASK_USER



RESTART_PROG:

    LEA DX, NEWLINE

    MOV AH, 09H

    INT 21H

    JMP START



EXIT_PROG:

    MOV AH, 4CH

    INT 21H

MAIN ENDP



PRINT_DEC PROC

    PUSH AX

    PUSH BX

    PUSH CX

    PUSH DX



    MOV CX, 0

    MOV BX, 10



DEC_LOOP:

    XOR DX, DX

    DIV BX

    PUSH DX

    INC CX

    TEST AX, AX

    JNZ DEC_LOOP



PRINT_DEC_STACK:

    POP DX

    ADD DL, '0'

    MOV AH, 02H

    INT 21H

    LOOP PRINT_DEC_STACK



    POP DX

    POP CX

    POP BX

    POP AX

    RET

PRINT_DEC ENDP



PRINT_HEX PROC

    PUSH AX

    PUSH BX

    PUSH CX

    PUSH DX



    MOV BL, AL      



    MOV DL, BL

    MOV CL, 4

    SHR DL, CL      

    CALL CONVERT_AND_PRINT



    MOV DL, BL

    AND DL, 0FH     

    CALL CONVERT_AND_PRINT



    POP DX

    POP CX

    POP BX

    POP AX

    RET

PRINT_HEX ENDP



CONVERT_AND_PRINT PROC

    CMP DL, 9

    JBE IS_NUM      

    ADD DL, 7        

IS_NUM:

    ADD DL, 30H     

    MOV AH, 02H

    INT 21H

    RET

CONVERT_AND_PRINT ENDP



END MAIN