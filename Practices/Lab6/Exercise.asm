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
    
    ; LUU SO FIBONACCI THU i
    fibo1  DB 10, 13, "0$"
    fibo2  DB 10, 13, "1$"
    fibo3  DB 10, 13, "1$"
    fibo4  DB 10, 13, "2$"
    fibo5  DB 10, 13, "3$"
    fibo6  DB 10, 13, "5$"
    fibo7  DB 10, 13, "8$"
    fibo8  DB 10, 13, "13$"
    fibo9  DB 10, 13, "21$"
    fibo10 DB 10, 13, "34$"
    fibo11 DB 10, 13, "55$"
    fibo12 DB 10, 13, "89$"
    fibo13 DB 10, 13, "144$"
    fibo14 DB 10, 13, "233$"
    fibo15 DB 10, 13, "377$"
    fibo16 DB 10, 13, "610$"
    fibo17 DB 10, 13, "987$"
    fibo18 DB 10, 13, "1597$"
    fibo19 DB 10, 13, "2584$"
    fibo20 DB 10, 13, "4181$"
    fibo21 DB 10, 13, "6765$"
    fibo22 DB 10, 13, "10946$"
    fibo23 DB 10, 13, "17711$"
    fibo24 DB 10, 13, "28657$"
    fibo25 DB 10, 13, "46368$"
    fibo26 DB 10, 13, "75025$"
    fibo27 DB 10, 13, "121393$"
    fibo28 DB 10, 13, "196418$"
    fibo29 DB 10, 13, "317811$"
    fibo30 DB 10, 13, "514229$"
    fibo31 DB 10, 13, "832040$"
    fibo32 DB 10, 13, "1346269$"
    fibo33 DB 10, 13, "2178309$"
    fibo34 DB 10, 13, "3524578$"
    fibo35 DB 10, 13, "5702887$"
    fibo36 DB 10, 13, "9227465$"
    fibo37 DB 10, 13, "14930352$"
    fibo38 DB 10, 13, "24157817$"
    fibo39 DB 10, 13, "39088169$"
    fibo40 DB 10, 13, "63245986$"
    fibo41 DB 10, 13, "102334155$"
    fibo42 DB 10, 13, "165580141$"
    fibo43 DB 10, 13, "267914296$"
    fibo44 DB 10, 13, "433494437$"
    fibo45 DB 10, 13, "701408733$"
    fibo46 DB 10, 13, "1134903170$"
    fibo47 DB 10, 13, "1836311903$"
    fibo48 DB 10, 13, "2971215073$"
    fibo49 DB 10, 13, "4807526976$"
    fibo50 DB 10, 13, "7778742049$"
    fibo51 DB 10, 13, "12586269025$"
    fibo52 DB 10, 13, "20365011074$"
    fibo53 DB 10, 13, "32951280099$"
    fibo54 DB 10, 13, "53316291173$"
    fibo55 DB 10, 13, "86267571272$"
    fibo56 DB 10, 13, "139583862445$"
    fibo57 DB 10, 13, "225851433717$"
    fibo58 DB 10, 13, "365435296162$"
    fibo59 DB 10, 13, "591286729879$"
    fibo60 DB 10, 13, "956722026041$"
    fibo61 DB 10, 13, "1548008755920$"
    fibo62 DB 10, 13, "2504730781961$"
    fibo63 DB 10, 13, "4052739537881$"
    fibo64 DB 10, 13, "6557470319842$"
    fibo65 DB 10, 13, "10610209857723$"
    fibo66 DB 10, 13, "17167680177565$"
    fibo67 DB 10, 13, "27777890035288$"
    fibo68 DB 10, 13, "44945570212853$"
    fibo69 DB 10, 13, "72723460248141$"
    fibo70 DB 10, 13, "117669030460994$"
    fibo71 DB 10, 13, "190392490709135$"
    fibo72 DB 10, 13, "308061521170129$"
    fibo73 DB 10, 13, "498454011879264$"
    fibo74 DB 10, 13, "806515533049393$"
    fibo75 DB 10, 13, "1304969544928657$"
    fibo76 DB 10, 13, "2111485077978050$"
    fibo77 DB 10, 13, "3416454622906707$"
    fibo78 DB 10, 13, "5527939700884757$"
    fibo79 DB 10, 13, "8944394323791464$"
    fibo80 DB 10, 13, "14472334024676221$"
    fibo81 DB 10, 13, "23416728348467685$"
    fibo82 DB 10, 13, "37889062373143906$"
    fibo83 DB 10, 13, "61305790721611591$"
    fibo84 DB 10, 13, "99194853094755497$"
    fibo85 DB 10, 13, "160500643816367088$"
    fibo86 DB 10, 13, "259695496911122585$"
    fibo87 DB 10, 13, "420196140727489673$"
    fibo88 DB 10, 13, "679891637638612258$"
    fibo89 DB 10, 13, "1100087778366101931$"
    fibo90 DB 10, 13, "1779979416004714189$"
    fibo91 DB 10, 13, "2880067194370816120$"
    fibo92 DB 10, 13, "4660046610375530309$"
    fibo93 DB 10, 13, "7540113804746346429$"
    fibo94 DB 10, 13, "12200160415121876738$"
    fibo95 DB 10, 13, "19740274219868223167$"
    fibo96 DB 10, 13, "31940434634990099905$"
    fibo97 DB 10, 13, "51680708854858323072$"
    fibo98 DB 10, 13, "83621143489848422977$"
    fibo99 DB 10, 13, "135301852344706746049$"
    
    ; LUU 99 SO FIBONACCI
    FIBO DW fibo1, fibo2, fibo3, fibo4, fibo5, fibo6, fibo7, fibo8, fibo9, fibo10, fibo11, fibo12, fibo13, fibo14, fibo15, fibo16, fibo17, fibo18, fibo19, fibo20, fibo21, fibo22, fibo23, fibo24, fibo25, fibo26, fibo27, fibo28, fibo29, fibo30, fibo31, fibo32, fibo33, fibo34, fibo35, fibo36, fibo37, fibo38, fibo39, fibo40, fibo41, fibo42, fibo43, fibo44, fibo45, fibo46, fibo47, fibo48, fibo49, fibo50, fibo51, fibo52, fibo53, fibo54, fibo55, fibo56, fibo57, fibo58, fibo59, fibo60, fibo61, fibo62, fibo63, fibo64, fibo65, fibo66, fibo67, fibo68, fibo69, fibo70, fibo71, fibo72, fibo73, fibo74, fibo75, fibo76, fibo77, fibo78, fibo79, fibo80, fibo81, fibo82, fibo83, fibo84, fibo85, fibo86, fibo87, fibo88, fibo89, fibo90, fibo91, fibo92, fibo93, fibo94, fibo95, fibo96, fibo97, fibo98, fibo99

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
    
    LEA BX, FIBO
    PRINT_LOOP:             ; VONG LAP IN RA FIBONACCI 
    MOV DX, [BX]
    MOV AH, 9h
    INT 21h
    
    ADD BX, 2
    
    LOOP PRINT_LOOP
    
    DONE_PRINT:             ; IN XONG

    RET
PRINT_RESULT ENDP
;==========================================================================

END