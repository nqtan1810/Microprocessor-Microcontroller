.MODEL SMALL
.STACK 100h
.DATA

;=======================PHAN KHAI BAO CAC CHUOI===============================

    MSG1 DB 10,13, "NHAP SO A: $"           
    MSG2 DB 10,13, "NHAP SO B: $"
    MSG3 DB 10,13, "A + B = $" 
    MSG4 DB 10,13,10,13, "******FIBONACCI NUMBERS******$"

;========================PHAN KHAI BAO CAC BIEN=============================== 
   
    NUM1 DB ?               ; LUU SO THU NHAT
    NUM2 DB ?               ; LUU SO THU HAI
    RESULT DB ?             ; LUU KET QUA SUM
    
    X DB ?                  ; CAC BIEN TAM THOI TRONG QUA TRINH TINH TOAN
    Y DB ?
    
    ; SO FIBONACCI TA LUU GO
    ; LUU SO FIBONACCI N-2
    FIBO2 DB '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'
    
    ; LUU SO FIBONACCI N-1
    FIBO1 DB '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1'
    
    ; LUU SO FIBONACCI N
    FIBO  DB '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'
    
.CODE   

;============================CHUONG TRINH CHINH===============================
MAIN PROC
    
;=========================PHAN KHOI TAO BAN DAU===============================
                            
    MOV AX, @DATA           ;LAY DIA CHI CUA VUNG NHO DATA VAO THANH GHI DOAN DS
    MOV DS, AX
    
;=======================PHAN NHAP 2 SO INPUT O DAND HEX=======================

    MOV AH, 9h              ; THONG BAO NHAP SO THU NHAT
    LEA DX, MSG1
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
    
    CALL SUM                ; GOI HAM THUC HIEN TINH TONG: RESULT = A + B
    
;==========================PHAN IN KET QUA PHEP CONG==========================

    MOV AH, 9h              ;IN RA THONG BAO KET QUA ADD
    LEA DX, MSG3 
    INT 21h
    
;======================PHAN XU LY IN RA FIRST N FIBONACCI=====================
    
    CALL PRINT_RESULT       ; GOI HAM THUC HIEN IN KET QUA SUM VA IN SO FIBONACCI

;==============================THOAT CHUONG TRINH=============================
    MOV AH, 4Ch             ; NGAT THOAT KHOI CHUONG TRINH
    INT 21h

MAIN ENDP
;=============================================================================
    
;=============================CAC CHUONG TRINH CON============================  

;====================HAM DOC INPUT DUOC NHAP TU BAN PHIM======================
READ_NUM PROC
    XOR AX, AX              ; AX = 0
    MOV BL, 10              
    MOV BH, 0               ; BH CHUA SO KY TU DA NHAP
    MOV X, 0
    MOV Y, 0
    
    READ:
    INC BH                  ; TANG BH = BH + 1
    MOV AH, 1h              ; NHAP SO TU BAN PHIM
    INT 21h
    
    CMP AL, 0Dh             ; NHAP XONG KHI NHAN PHIM ENTER
    JE READ_DONE
    
    SUB AL, 30h             ; CHUYEN KY TU THANH SO (VD: '9': 39h - 30h = 9)
    
    MOV Y, AL               ; THUC HIEN NHAN SO VUA NHAP UNG VOI TRONG SO TUONG UNG
    MOV AL, X               ; VD TA NHAP 1, 2, 3 => NUM = 1*10^2 + 2*10^1 + 3*10^0
    MUL BL          
    ADD AL, Y      
    MOV X, AL
                            ; KIEM TRA NHAP DU SO CO 2 CHU SO CHUA, NEU ROI THI HOAN THANH VIEC NHAP
    CMP BH, 2
    JE READ_DONE
    
    JMP READ
    
    READ_DONE:              ; NHAP XONG
    
    RET
READ_NUM ENDP
;============================================================================  

;==========================HAM THUC HIEN TINH TONG===========================
SUM PROC
    MOV AL, NUM1            ; TINH TONG 2 SO A, B VUA NHAP
    MOV AH, NUM2
    ADD AH, AL
    
    MOV RESULT, AH          ; LUU KET QUA SUM = A+B VAO BIEN RESULT
        
    RET    
SUM ENDP
;==========================================================================

;========================HAM THUC HIEN IN KET QUA========================== 
PRINT_RESULT PROC
    XOR AX, AX              ; SO TINH TOAN DUOC CO THE CO 3 CHU SO NEN TA THUC HIEN CHIA 10 (DIV 10) 2 LAN
    MOV AL, RESULT           
    MOV CL, 10               
    DIV CL                  ; CHIA 10 LAN 1 
    MOV CH, AH              ; CH CHUA SO HANG DON VI 
    
    CMP AL, 0               ; KIEM TRA SO HANG CHUC VA HANG TRAM CO = 0?, NEU CO THI CHI IN HANG DON VI
    JE ZERO1
    XOR AH, AH              
    MOV CL, 10              
    DIV CL                  ; CHIA 10 LAN 2
    MOV BL, AH              ; BL CHUA SO HANG CHUC
    
    CMP AL, 0               ; AL CHUA SO HANG TRAM, NEU SO HANG TRAM = 0 THI KHONG IN
    JE ZERO2
    ADD AL, 30h             ; IN HANG TRAM
    MOV DL, AL
    MOV AH, 02h
    INT 21h 
    
    ZERO2:                  ; KIEM TRA SO HANG CHUC, NEU HANG CHUC = 0 THI KHONG IN
    ADD BL, 30h             ; (HANG CHUC = 0 VA HANG TRAM = 0 THI MOI KHONG IN)
    MOV DL, BL              ; IN HANG CHUC
    MOV AH, 02h
    INT 21h
    
    ZERO1:
    ADD CH, 30h             ; IN HANG DON VI
    MOV DL, CH
    MOV AH, 02h
    INT 21h
    
    MOV AL, 0               ; KET QUA DUOC LUU DANG 8-BIT (CO DAU NEN CO THE XAY RA TRAN SO => TRO THANH SO AM)
    CMP AL, RESULT          ; NEU TRAN SO THANH SO AM => LON HON 99
    JG LARGER_99
     
    CMP RESULT, 99          ; NEU KHONG TRAN SO THI SO SANH VOI 99
    JNG NOT_LARGER_99
    
    LARGER_99:              ; TRAN SO THANH SO AM HOAC LON HON 99 THI CHO RESULT = 99
    MOV RESULT, 99
    
    NOT_LARGER_99:          ; NEU RESULT KHONG TRAN SO THANH AM HOAC LON HON 99 THI GIU Y NGUYEN
    XOR CX, CX
    MOV CL, RESULT          ; CX CHUA SO VONG LAP (CUNG LA SO SO FIBONACCI CAN IN)
    
    CMP CX, 0               ; NEU CX = 0 TUC KHONG IN BAT CU SO NAO
    JE DONE_PRINT
    
    MOV AH, 9h              ; HIEN THI THONG BAO IN SO FIBONACCI
    LEA DX, MSG4
    INT 21h
    
    MOV DL, 10              ; THUC HIEN XUONG DONG VA DUA CON TRO VE DAU DONG
    MOV AH, 02h
    INT 21h
    MOV DL, 13
    MOV AH, 02h
    INT 21h
     
    MOV DL, '0'             ; IN RA SO FIBONACCI THU 1
    MOV AH, 02h
    INT 21h
    
    CMP CX, 1               ; NEU CX = 1 TUC CHI IN 1 SO FIBONACCI DUY NHAT VA THOAT
    JE DONE_PRINT
    
    MOV DL, 10              ; THUC HIEN XUONG DONG VA DUA CON TRO VE DAU DONG
    MOV AH, 02h
    INT 21h
    MOV DL, 13
    MOV AH, 02h
    INT 21h
    
    MOV DL, '1'             ; IN SO FIBONACCI THU 2
    MOV AH, 02h
    INT 21h
    
    CMP CX, 2               ; NEU CX = 2 TUC CHI IN SO FIBONACCI THU 1 VA THU 2, XONG THOAT (0, 1)
    JE DONE_PRINT
    
    SUB CX, 2               ; NEU CX != 0, != 1, != 2 THI TIEN HANH TINH TOAN CAC SO FIBONACCI VA IN RA
    
    PRINT_LOOP:             ; VONG LAP GOI HAM TINH SO FIBONACCI VA IN RA
    PUSH CX                 ; LUU GIA TRI CX (DAY VAO STACK)
    
    MOV DL, 10              ; THUC HIEN XUONG DONG VA DUA CON TRO VE DAU DONG
    MOV AH, 02h
    INT 21h
    MOV DL, 13
    MOV AH, 02h
    INT 21h  
    
    CALL FIBONACCI          ; GOI HAM TINH TOAN SO FIBONACCI THU i
    
    CALL PRINT_FIBO         ; GOI HAM IN SO FIBONACCI THU i
    
    
    POP CX                  ; TRA LAI GIA TRI CX (LAY RA KHOI STACK)
    LOOP PRINT_LOOP
    
    DONE_PRINT:             ; IN XONG

    RET
PRINT_RESULT ENDP
;==========================================================================

;======================HAM THUC HIEN TINH FIBONACCI======================== 
FIBONACCI PROC
    MOV CX, 21              ; CX LUU OFSET TRUY CAP MANG FIBONACCI
    XOR AX, AX              ; AX = 0
    
    CAL_FIBO:               ; BAT DAU TINH TOAN SO FIBONACCI THU i
    LEA BX, FIBO2           ; LAY DIA CHI NEN CUA FIBO2
    ADD BX, CX
    MOV DL, [BX]            ; DL = FIBO2[CX] (TRUY CAP MANG THEO CHI SO CX)
    
    LEA BX, FIBO1           ; LAY DIA CHI NEN CUA FIBO1
    ADD BX, CX
    MOV DH, [BX]            ; DL = FIBO1[CX] (TRUY CAP MANG THEO CHI SO CX)
    
    SUB DL, 30h             ; CHUYEN KY TU THANH SO (VD: '9': 39h - 30h = 9)
    SUB DH, 30h
    
    ADD DL, DH              ; FIBO2[CX] + FIBO1[CX]
    ADD DL, AL
    MOV AL, DL 
    MOV AH, 0 
    MOV DL, 10
    DIV DL                   ; THUC HIEN CHIA DU CHO 10 DE TACH HANG CHUC VA HANG DON VI
    
    ADD AH, 30h              ; AH CHUA HANG DON VI (PHAN DU), AL CHUA HANG CHUC (DUNG DE NHO CONG DON VAO SO SAU)
    LEA BX, FIBO
    ADD BX, CX
    MOV [BX], AH             ; FIBO[CX] = AH
    
    LOOP CAL_FIBO
    
    MOV CX, 22               ; CAP NHAT LAI GIA TRI CUA CAC SO FIBOx TUONG UNG
    LEA BX, FIBO1
    LEA DI, FIBO2 
    
    MOV_FIBO1:               ; FIBO2 = FIBO1
    MOV AL, [BX]
    MOV [DI], AL
    INC DI
    INC BX
    LOOP MOV_FIBO1           ; LAP LAI 22 LAN DE DUYET HET MANG
   
    MOV CX, 22
    LEA BX, FIBO
    LEA DI, FIBO1 
    
    MOV_FIBO_2:              ; FIBO1 = FIBO
    MOV AL, [BX]
    MOV [DI], AL
    INC DI
    INC BX
    LOOP MOV_FIBO_2          ; LAP LAI 22 LAN DE DUYET HET MANG
     
    RET           
FIBONACCI ENDP
;========================================================================== 

;=======================HAM THUC HIEN IN 1 SO FIBO========================= 
PRINT_FIBO PROC              
    LEA BX, FIBO            ; LOAD DIA CHI NEN CUA MANG FIBO
    LEA CX, FIBO
    ADD CX, 21
    
    INCREASE:               ; KIEM TRA BO CAC KY TU '0' KHONG CO NGHIA 
    CMP [BX], '0'           ; (KHONG IN CAC SO 0 KHONG CO NGHIA)
    JNE PRINT               
    INC BX                  ; TANG DIA CHI NEN (BX = BX + 1) CHO TOI KHI GAP CHU SO CO NGHIA
    CMP BX, CX
    JG ZERO
    JMP INCREASE 
    
    PRINT:                  ; LOAD LAI DIA CHI NEN DE IN MANG
    LEA CX, FIBO
    ADD CX, 21
    
    NEXT_CHAR:
    MOV DL, [BX]            ; IN CHU SO TRONG MANG FIBO
    MOV AH, 02h
    INT 21H
    
    INC BX                  ; TANG LEN VA TIEP TUC IN CHO DEN CUOI MANG
    CMP BX, CX
    JG DONE
    JMP NEXT_CHAR 
    
    ZERO:                   ; NEU SO FIBONACCI = 0 THI THUC HIEN IN '0'
    MOV DL, '0'
    MOV AH, 02h
    INT 21h
    
    DONE:
    RET
PRINT_FIBO ENDP
;==========================================================================

END