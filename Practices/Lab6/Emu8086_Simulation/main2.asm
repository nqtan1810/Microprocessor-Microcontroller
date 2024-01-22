.MODEL SMALL
.STACK 100h
.DATA

;=======================PHAN KHAI BAO CAC CHUOI===============================

    MSG1 DB 10,13, "NHAP SO A: $"
    MSG2 DB 10,13, "NHAP SO B: $"
    MSG3 DB 10,13, "A + B = $" 
    MSG4 DB 10,13, "******FIBONACCI NUMBERS******$"

;========================PHAN KHAI BAO CAC BIEN===============================
    
    FIBO  DB "0", "1", "1", "2", "3", "5", "8", "13", "21", "34", "55", "89", "144", "233", "377", "610", "987", "1597", "2584", "4181", "6765", "10946", "17711", "28657", "46368", "75025", "121393", "196418", "317811", "514229", "832040", "1346269", "2178309", "3524578", "5702887", "9227465", "14930352", "24157817", "39088169", "63245986", "102334155", "165580141", "267914296", "433494437", "701408733", "1134903170", "1836311903", "2971215073", "4807526976", "7778742049", "12586269025", "20365011074", "32951280099", "53316291173", "86267571272", "139583862445", "225851433717", "365435296162", "591286729879", "956722026041", "1548008755920", "2504730781961", "4052739537881", "6557470319842", "10610209857723", "17167680177565", "27777890035288", "44945570212853", "72723460248141", "117669030460994", "190392490709135", "308061521170129", "498454011879264", "806515533049393", "1304969544928657", "2111485077978050", "3416454622906707", "5527939700884757", "8944394323791464", "14472334024676221", "23416728348467685", "37889062373143906", "61305790721611591", "99194853094755497", "160500643816367088", "259695496911122585", "420196140727489673", "679891637638612258", "1100087778366101931", "1779979416004714189", "2880067194370816120", "4660046610375530309", "7540113804746346429", "12200160415121876738", "19740274219868223167", "31940434634990099905", "51680708854858323072", "83621143489848422977", "135301852344706746049"
    
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
   
END