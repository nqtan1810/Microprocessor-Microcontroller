.MODEL SMALL
.STACK 100h
.DATA

;=======================PHAN KHAI BAO CAC CHUOI===============================

    MSG1 DB 10,13, "NHAP SO A: $"
    MSG2 DB 10,13, "NHAP SO B: $"
    MSG3 DB 10,13, "A + B = $" 
    MSG4 DB 10,13, "******FIBONACCI NUMBERS******$"

;========================PHAN KHAI BAO CAC BIEN=============================== 
   
    NUM1 DB ?          ; LUU SO THU NHAT
    NUM2 DB ?          ; LUU SO THU HAI
    RESULT DB ?        ; LUU KET QUA SUM
    
    X DB ?
    Y DB ?
    
    FIBO2 DB '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'
    FIBO1 DB '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1'
    FIBO  DB '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'
    
.CODE   

;============================CHUONG TRINH CHINH===============================
MAIN PROC
    
;=========================PHAN KHOI TAO BAN DAU===============================
    
                            ;LAY DIA CHI CUA VUNG NHO DATA VAO THANH GHI DOAN DS
    MOV AX, @DATA
    MOV DS, AX
    
;=======================PHAN NHAP 2 SO INPUT O DAND HEX=======================

    MOV AH, 9h              ; THONG BAO NHAP SO THU NHAT
    LEA DX, FIBO2
    INT 21h
    
    CALL READ_NUM           ; NHAP SO THU NHAT 
    MOV AL, X
    MOV NUM1, AL
    
    MOV AH, 9h              ; THONG BAO NHAP SO THU HAI
    LEA DX, MSG2
    INT 21h
    
    CALL READ_NUM           ; NHAP SO THU HAI
    MOV AL, X
    MOV NUM2, AL
    
;=====================PHAN THUC HIEN TINH TONG HAI SO=========================
    
    CALL SUM                ; GOI HAM THUC HIEN TINH TONG
    
;==========================PHAN IN KET QUA PHEP CONG==========================

    MOV AH, 9h              ;IN RA THONG BAO KET QUA ADD
    LEA DX, MSG3 
    INT 21h
    
;======================PHAN XU LY IN RA FIRST N FIBONACCI=====================
    
    CALL PRINT_RESULT

;==============================THOAT CHUONG TRINH=============================
    MOV AH, 4Ch             ; NGAT THOAT KHOI CHUONG TRINH
    INT 21h

MAIN ENDP
;=============================================================================
    
;=============================CAC CHUONG TRINH CON============================  

;====================HAM DOC INPUT DUOC NHAP TU BAN PHIM======================
READ_NUM PROC
    XOR AX, AX 
    MOV BL, 10
    MOV BH, 0
    MOV X, 0
    MOV Y, 0
    
    READ:
    INC BH 
    MOV AH, 1h
    INT 21h
    
    CMP AL, 0Dh
    JE READ_DONE
    
    SUB AL, 30h
    
    MOV Y, AL      
    MOV AL, X      
    MUL BL          
    ADD AL, Y      
    MOV X, AL
    
    CMP BH, 2
    JE READ_DONE
    
    JMP READ
    
    READ_DONE:    
    
    RET
    
READ_NUM ENDP
;============================================================================  

;==========================HAM THUC HIEN TINH TONG===========================
SUM PROC
    MOV AL, NUM1
    MOV AH, NUM2
    ADD AH, AL
    
    MOV RESULT, AH     
        
    RET    
    
SUM ENDP
;==========================================================================

;========================HAM THUC HIEN IN KET QUA========================== 
PRINT_RESULT PROC
    XOR AX, AX
    MOV AL, RESULT           ; RESULT = AX
    MOV CL, 10               ; CL = 10
    DIV CL                   ; CHIA DU LAN THU 1
    MOV CH, AH               ; CH CHUA SO HANG DON VI
    
    CMP AL, 0
    JE ZERO1
    XOR AH, AH
    MOV CL, 10
    DIV CL                   ; CHIA DU LAN THU 2
    MOV BL, AH               ; BL CHUA SO HANG CHUC
    
    CMP AL, 0                ; AL CHUA SO HANG TRAM
    JE ZERO2
    ADD AL, 30h
    MOV DL, AL
    MOV AH, 02h
    INT 21h 
    
    ZERO2:
    ADD BL, 30h
    MOV DL, BL
    MOV AH, 02h
    INT 21h
    
    ZERO1:
    ADD CH, 30h
    MOV DL, CH
    MOV AH, 02h
    INT 21h
    
    MOV AL, 0       
    CMP AL, RESULT
    JG LARGER_99
     
    CMP RESULT, 99
    JNG NOT_LARGER_99
    
    LARGER_99:
    MOV RESULT, 99
    
    NOT_LARGER_99:
    XOR CX, CX
    MOV CL, RESULT
    
    CMP CX, 0
    JE DONE_PRINT
    
    MOV AH, 9h             
    LEA DX, MSG4
    INT 21h
    
    MOV DL, 10
    MOV AH, 02h
    INT 21h
    
    MOV DL, 13
    MOV AH, 02h
    INT 21h
     
    MOV DL, '0'
    MOV AH, 02h
    INT 21h
    
    CMP CX, 1
    JE DONE_PRINT
    
    MOV DL, 10
    MOV AH, 02h
    INT 21h
    
    MOV DL, 13
    MOV AH, 02h
    INT 21h
    
    MOV DL, '1'
    MOV AH, 02h
    INT 21h
    
    CMP CX, 2
    JE DONE_PRINT
    
    SUB CX, 2
    
    PRINT_LOOP:
    PUSH CX
    
    MOV DL, 10
    MOV AH, 02h
    INT 21h
    
    MOV DL, 13
    MOV AH, 02h
    INT 21h  
    
    CALL FIBONACCI
    
    CALL PRINT_FIBO
    
    
    POP CX
    LOOP PRINT_LOOP
    
    DONE_PRINT:           

    RET
PRINT_RESULT ENDP
;==========================================================================

;======================HAM THUC HIEN TINH FIBONACCI======================== 
FIBONACCI PROC
    MOV CX, 23
    XOR AX, AX          
    
    CAL_FIBO:
    LEA BX, FIBO2
    ADD BX, CX
    MOV DL, [BX]
    
    LEA BX, FIBO1
    ADD BX, CX
    MOV DH, [BX]
    
    SUB DL, 30h
    SUB DH, 30h
    
    ADD DL, DH
    ADD DL, AL
    MOV AL, DL 
    MOV AH, 0 
    MOV DL, 10
    DIV DL
    
    ADD AH, 30h 
    LEA BX, FIBO
    ADD BX, CX
    MOV [BX], AH
    
    LOOP CAL_FIBO
    
    MOV CX, 24
    LEA BX, FIBO1
    LEA DI, FIBO2 
    
    MOV_FIBO1:
    MOV AL, [BX]
    MOV [DI], AL
    INC DI
    INC BX
    LOOP MOV_FIBO1
   
    MOV CX, 24
    LEA BX, FIBO
    LEA DI, FIBO1 
    
    MOV_FIBO_2:
    MOV AL, [BX]
    MOV [DI], AL
    INC DI
    INC BX
    LOOP MOV_FIBO_2 
     
    RET           
FIBONACCI ENDP
;========================================================================== 

;=======================HAM THUC HIEN IN 1 SO FIBO========================= 
PRINT_FIBO PROC           
    LEA BX, FIBO
    LEA CX, FIBO
    ADD CX, 23
    
    INCREASE:
    CMP [BX], '0'
    JNE PRINT 
    INC BX
    CMP BX, CX
    JG ZERO
    JMP INCREASE 
    
    PRINT:
    LEA CX, FIBO
    ADD CX, 23
    
    NEXT_CHAR:
    MOV DL, [BX]
    MOV AH, 02h
    INT 21H
    
    INC BX
    CMP BX, CX
    JG DONE
    JMP NEXT_CHAR 
    
    ZERO:
    MOV DL, '0'
    MOV AH, 02h
    INT 21h
    
    DONE:
    RET
PRINT_FIBO ENDP
;==========================================================================
   
END