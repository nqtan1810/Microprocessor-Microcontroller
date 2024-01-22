.MODEL SMALL
.STACK 100h
.DATA

;=======================PHAN KHAI BAO CAC CHUOI===============================

    MSG1 DB 10,13, "NHAP SO THU NHAT: $"
    MSG2 DB 10,13, "NHAP SO THU HAI: $"
    MSG3 DB 10,13, "TONG HAI SO LA: $"
    MSG4 DB 10,13, "HIEU HAI SO LA: $"
    MSG5 DB 10,13, "OVERLOAD FLAG: $"
    MSG6 DB "h$"            ; IN RA KI HIEU 'h' SAU CUNG KET QUA DANG HEX
    

;========================PHAN KHAI BAO CAC BIEN=============================== 
   
    NUM1 DD ?, '$'          ; LUU SO THU NHAT
    NUM2 DD ?, '$'          ; LUU SO THU HAI
    RESULT DD ?, '$'        ; LUU KET QUA SUM/SUBTRACT 
    OVFL_FLAG DB ?, '$'          ; LUU BIT OVERFLOW
    
    NUM_HIGH DW ?, '$'      ; LUU 16 BIT CAO
    NUM_LOW DW ?, '$'       ; LUU 16 BIT THAP
    
    A DD ?, '$'             ; CAC BIEN TAM 32 BIT
    B DD ?, '$'
    

.CODE   

;============================CHUONG TRINH CHINH===============================
MAIN PROC
    
;=========================PHAN KHOI TAO BAN DAU===============================
    
    ;LAY DIA CHI CUA VUNG NHO DATA VAO THANH GHI DOAN DS
    MOV AX, @DATA
    MOV DS, AX
    
    
;=======================PHAN NHAP 2 SO INPUT O DAND HEX=======================

    MOV AH, 9h              ; THONG BAO NHAP SO THU NHAT
    LEA DX, MSG1
    INT 21h
    
    CALL READ_NUM           ; NHAP SO THU NHAT
    
    MOV DX, NUM_HIGH        
    MOV AX, NUM_LOW         
    
    MOV [NUM1], AX          ; LUU SO THU NHAT VAO BIEN NUM1
    MOV [NUM1+2], DX        ; 16 BIT THAP VAO [NUM1], 16 BIT CAO VAO [NUM1+2]
    
    
    MOV AH, 9h              ; THONG BAO NHAP SO THU HAI
    LEA DX, MSG2
    INT 21h
    
    CALL READ_NUM           ; NHAP SO THU HAI
    
    MOV DX, NUM_HIGH
    MOV AX, NUM_LOW
    
    MOV [NUM2], AX          ; LUU SO THU NHAT VAO BIEN NUM2
    MOV [NUM2+2], DX        ; 16 BIT THAP VAO [NUM2], 16 BIT CAO VAO [NUM2+2]
    
    
;=====================PHAN THUC HIEN TINH TONG HAI SO=========================
    
    CALL SUM                ; GOI HAM THUC HIEN TINH TONG


;==========================PHAN IN KET QUA PHEP CONG==========================

    MOV AH, 9h              ;IN RA THONG BAO KET QUA ADD
    LEA DX, MSG3 
    INT 21h
    
    CALL PRINT_RESULT       ; GOI HAM IN RA KET QUA SUM
    
    
    MOV AH, 9h              ; IN RA THONG BAO OVERFLOW
    LEA DX, MSG5 
    INT 21h
    
    MOV DL, [OVFL_FLAG]     ; IN RA GIA TRI CO BAO TRAN PHEP CONG
    ADD DL, 30h
    MOV AH, 2h
    INT 21h


;=====================PHAN THUC HIEN TINH HIEU HAI SO=========================
    
    CALL SUBTRACT           ; GOI HAM THUC HIEN TINH HIEU
    
    
;==========================PHAN IN KET QUA PHEP TRU===========================

    MOV AH, 9h              ; IN RA THONG BAO KET QUA SUB
    LEA DX, MSG4 
    INT 21h
    
    CALL PRINT_RESULT       ; GOI HAM IN RA KET QUA SUB
    
    MOV AH, 9h              ; IN RA THONG BAO OVERFLOW
    LEA DX, MSG5 
    INT 21h
    
    MOV DL, [OVFL_FLAG]     ; IN RA GIA TRI CO BAO TRAN PHEP TRU
    ADD DL, 30h
    MOV AH, 2h
    INT 21h 
       
    
;==============================THOAT CHUONG TRINH=============================
    MOV AH, 4Ch             ; NGAT THOAT KHOI CHUONG TRINH
    INT 21h

MAIN ENDP
;=============================================================================
    
;=============================CAC CHUONG TRINH CON============================  

;====================HAM DOC INPUT DUOC NHAP TU BAN PHIM======================
READ_NUM PROC 
    MOV A, 0
    MOV B, 0
    XOR DX, DX              ; RESET DX = 0
    XOR AX, AX              ; RESET AX = 0
    MOV BX, 16              ; BX = 16 (HE HEX NEN CO SO NHAN TICH LUY KHI CHUYEN DOI SANG DEC LA 16)
    
    READ_KEY_PRESSED:       ; DOC KY TU NHAP TU BAN PHIM
        MOV AH, 1h          ; READ KY TU TU BAN PHIM, KY TU DUOC LUU TRONG AL
        INT 21h 
        
        CMP AL, 0Dh         ; NEU AL = 0Dh (MA ASCII CUA PHIM ENTER) => BAM PHIM ENTER
        JE READ_DONE        ; NEU BAM PHIM ENTER THI HOAN THANH VIEC NHAP SO
        
        CMP AL, 41h         ; SO SANH VOI KY TU A (MA ASCII CUA 'A' = 41h) DE PHAN LOAI CHU HAY SO
        JL NUMBER           ; CHUYEN VE GIA TRI TUONG UNG VOI SO
        JMP CHARACTER       ; CHUYEN VE GIA TRI TUONG UNG VOI CHU
        
    NUMBER:                 ; SO DUOC BAM - MA ASCII CUA '0' THI SE RA GIA TRI TUONG UNG
        SUB AL, 30h         ; VD: '9' - '0' = 9
        JMP CONVERT_NUM     ; NHAY DEN HAM CHUYEN HEX SANG DECIMAL
        
    CHARACTER:              ; CHU DUOC BAM - 37h THI SE RA GIA TRI TUONG UNG
        SUB AL, 37h         ; VD: 'A' - 37h = 65 - 55 = 10
    
    CONVERT_NUM:            ; THUC HIEN NHAN CAC GIA TRI VUA NHAP VOI BAC TUONG UNG
        XOR AH, AH          ; VD: TA NHAP 3 GIA TRI: A, 9, 3 => SO HEX = A*16^2 + 9*16^1 + 3*16^0
        CMP DX, 0
        JNE OVERFLOW        ; KIEM TRA TRAN THANH GHI NEU TA NHAP QUA 16 BIT, NEU CO NHAY TOI XU LI TRAN
        
        MOV B, AX           ; CHUYEN DOI NHU VD NAY: A, 9, 3 => SO HEX = A*16^2 + 9*16^1 + 3*16^0 
        MOV AX, A
        MUL BX
        
        ADD AX, B
        MOV A, AX
        
        MOV NUM_HIGH, DX    ; LUU 16 BIT CAO
        MOV NUM_LOW, AX     ; LUU 16 BIT THAP
        
        JMP READ_KEY_PRESSED 
    
    OVERFLOW:               ; XU LY TRAN
        MOV A, AX    
        MOV CX, 4           ; SO LAN VONG LAP LOOP
        
        MOV DX, NUM_HIGH
        MOV AX, NUM_LOW 
        
    SHIFT:
        SHL AX, 1           ; DICH TRAI 1 BIT, HE HEX NEN DICH 4 LAN
        RCL DX, 1           ; OFF-BIT CUA PHEP DICH TRAI DUOC DUA VAO DX
        LOOP SHIFT
        
        ADD AX, A
        MOV NUM_HIGH, DX    ; LUU 16 BIT CAO
        MOV NUM_LOW, AX     ; LUU 16 BIT THAP
        
        JMP READ_KEY_PRESSED
        
    READ_DONE:              ; HOAN THANH VIEC DOC 1 SO TU BAN PHIM O DANG HEX
        RET
    
READ_NUM ENDP
;============================================================================

;==========================HAM THUC HIEN TINH TONG===========================
SUM PROC
        CLC                 ; XOA BIT CF TU CAC LENH TRUOC
        MOV AX, [NUM1]      ; AX CHUA 16 BIT THAP CUA NUM1
        MOV BX, [NUM1+2]    ; BX CHUA 16 BIT CAO CUA NUM1
        
        MOV CX, [NUM2]      ; CX CHUA 16 BIT THAP CUA NUM2
        MOV DX, [NUM2+2]    ; DX CHUA 16 BIT THAP CUA NUM2
        
        ADD AX, CX          ; CONG 16 BIT THAP CUA 2 SO VOI NHAU, AX = AX + CX
        MOV [RESULT], AX    ; LUU 16 BIT THAP CUA KET QUA
        
        ADC BX, DX          ; CONG 16 BIT CAO CUNG VOI BIT CARRY FLAG, BX = BX + DX + CF
        MOV [RESULT+2], BX  ; LUU 16 BIT CAO CUA KET QUA
        
        JO SET_FLAG_SUM     ; XU LY TRAN SO PHEP CONG
        MOV [OVFL_FLAG], 0  ; OVFL_FLAG = 0 NEU KHONG TRAN
        JMP SUM_DONE 
    
     SET_FLAG_SUM:
        MOV [OVFL_FLAG], 1  ; OVFL_FLAG = 1 NEU TRAN
     
     SUM_DONE:              ; HOAN THANH VIEC CONG
        
     RET    
    
SUM ENDP
;==========================================================================

;========================HAM THUC HIEN TINH HIEU===========================
SUBTRACT PROC
        CLC                 ; XOA BIT CF TU CAC LENH TRUOC
        MOV AX, [NUM1]      ; AX CHUA 16 BIT THAP CUA NUM1
        MOV BX, [NUM1+2]    ; BX CHUA 16 BIT CAO CUA NUM1
        
        MOV CX, [NUM2]      ; CX CHUA 16 BIT THAP CUA NUM2
        MOV DX, [NUM2+2]    ; DX CHUA 16 BIT THAP CUA NUM2
        
        SUB AX, CX          ; TRU 16 BIT THAP CUA 2 SO VOI NHAU, AX = AX - CX
        MOV [RESULT], AX    ; LUU 16 BIT THAP CUA KET QUA
        
        SBB BX, DX          ; TRU 16 BIT CAO CUNG VOI BIT CARRY FLAG, BX = BX - DX - CF
        MOV [RESULT+2], BX  ; LUU 16 BIT CAO CUA KET QUA
        
        JO SET_FLAG_SUB     ; XU LY TRAN SO PHEP TRU
        MOV [OVFL_FLAG], 0  ; OVFL_FLAG = 0 NEU KHONG TRAN
        JMP SUB_DONE 
    
     SET_FLAG_SUB:
        MOV [OVFL_FLAG], 1  ; OVFL_FLAG = 1 NEU TRAN
     
     SUB_DONE:              ; HOAN THANH VIEC TRU
    
    RET

SUBTRACT ENDP
;==========================================================================

;========================HAM THUC HIEN IN KET QUA========================== 
PRINT_RESULT PROC           
                            ; THUC HIEN IN 16 BIT CAO CUA KET QUA
    MOV BX, [RESULT+2]      ; BX CHUA 16 BIT CAO CUA KET QUA
    MOV CX, 4               
                            
    PRINT_HIGH:             ; CHIA 16 BIT THANH 4 PHAN, MOI PHAN UNG VOI 1 SO TRONG HE HEX
        MOV AX, 4           ; 16 BIT NEN TA CAN 4X4 VONG LAP ( = CX * AX )
        XOR DX, DX          ; RESET DX = 0
        
    SHIFT_HIGH:             ; DICH BIT
        SHL BX, 1           ; DICH TRAI 1 BIT
        RCL DX, 1           ; OFF-BIT CUA LENH DICH DUOC DUA VAO DX VOI TRONG SO TUONG UNG
        
        DEC AX              ; GIAM AX 1 DON VI (AX = AX - 1)
        CMP AX, 0           ; KIEM TRA XEM CO LAP DU 4 LAN TRONG VONG LAP BE
        JNE SHIFT_HIGH      ; VONG LAP BE AX = 4
        
        CMP DX, 0Ah         ; SO SANH GIA TRI VOI 0Ah UNG VOI 'A'
        JGE PRINT_CHAR_HIGH 
        
    PRINT_NUM_HIGH:         ; IN SO: '0' -> '9'
        ADD DX, 30h
        MOV AH, 2h
        INT 21h
        JMP PRINT_ONE_HIGH_DONE
    
    PRINT_CHAR_HIGH:        ; IN CHU: 'A', 'B', 'C', 'D', 'E', 'F'
        ADD DX, 37h
        MOV AH, 2h
        INT 21h
        
    PRINT_ONE_HIGH_DONE:
        
        LOOP PRINT_HIGH     ; VONG LAP LON CX = 4 
        
                            
                            ; THUC HIEN IN 16 BIT THAP CUA KET QUA
    MOV BX, [RESULT]        ; THUC HIEN TUONG TU NHU 16 BIT CAO ....
    MOV CX, 4
    
    PRINT_LOW:
        MOV AX, 4
        XOR DX, DX
        
    SHIFT_LOW:    
        SHL BX, 1
        RCL DX, 1
        
        DEC AX
        CMP AX, 0
        JNE SHIFT_LOW
        
        CMP DX, 0Ah
        JGE PRINT_CHAR_LOW
        
    PRINT_NUM_LOW:
        ADD DX, 30h
        MOV AH, 2h
        INT 21h
        JMP PRINT_ONE_LOW_DONE
    
    PRINT_CHAR_LOW:
        ADD DX, 37h
        MOV AH, 2h
        INT 21h
        
    PRINT_ONE_LOW_DONE:
        
        LOOP PRINT_LOW

    
    MOV AH, 9h              ; IN RA KI HIEU h (HEX)
    LEA DX, MSG6
    INT 21h
    
    RET                     ; HOAN THANH VIEC IN SO 32 BIT DANG HEX (VD KET QUA IN: 1234ABCDh)
    
PRINT_RESULT ENDP
;==========================================================================
   
END
