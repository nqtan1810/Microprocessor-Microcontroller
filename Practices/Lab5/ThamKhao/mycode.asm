.model small ; Specify the memory model as small (<64KB)
.stack 100h ; Allocate 256 bytes of stack space
.data                                                 

;define string
tb1 db "Num1: $"  ; $ = the end of the string
tb2 db 10,13,"Num2: $"
tb3 db 10,13,"Sum: $"
tb4 db 10,13,"Difference: $"
tb5 db 10,13,"Sum in 32-bit binary: $"
tb6 db 10,13,"Difference in 32-bit binary: $" 

;define a 32-bit variable
val1 dd  ?, '$'               
val2 dd  ?, '$'               
result  dd  ?, '$'               


x dd ?,'$'
y dd ?,'$'

;define a 16-bit variable to contain low, high bit
highb dw ?,'$'
lowb dw ?,'$'

.code               
main proc
    mov ax,@data
    mov ds,ax
   
    ;; read Num1
    mov ah,9  ; print string
    lea dx, tb1 ; load the offset of tb1 string into DX
    int 21h     ; call DOS interupt to print string        ;////////////////// in thong bao nhap so Num1
    call readNumber 
    mov dx, highb
    mov ax, lowb
    mov [val1+2],dx ; store high word of the number          
    mov [val1],ax   ; store low word of the number         
   
    
    ;read Num2
    mov ah,9 
    lea dx, tb2 
    int 21h 
    call readNumber 
    mov dx, highb  
    mov ax, lowb
    mov [val2+2],dx          
    mov [val2],ax            
    
    
    ;plus Num1 and Num2
    mov ah,9
    lea dx, tb3
    int 21h 
    call plus_Func
    
    
    mov si,word ptr result+2   ; store high word into SI, use for printNumber
    mov di,word ptr result     ; store low word into DI, use for printNumber
    call printNumber
    
    mov ah,9
    lea dx, tb5
    int 21h  
    call printNumber32
    
    ;sub Num1 and Num2
    mov ah,9
    lea dx, tb4
    int 21h
    call sub_Func
    mov si,word ptr result+2  ; store high word into SI, use for printNumber
    mov di,word ptr result    ; store low word into DI, use for printNumber
    call printNumber
    
    mov ah,9
    lea dx, tb6
    int 21h
    call printNumber32   
    
    mov ah,4ch      ; moves the immediate value 4Ch into the ah register. 
    ;In the context of DOS interrupts, the value in the ah register specifies the function or service to be executed when invoking the interrupt.
    int 21h         ; with ah set to 4Ch, the int 21h instruction typically invokes the DOS service for program termination. 
    ;When this interrupt is triggered, the program terminates and control returns to the operating system.
    ;Stop the program
main endp


readNumber proc
    xor dx,dx
    xor ax,ax ; clear ax, dx 
    ; set to 0
    mov x,0
    mov y,0
    mov bx,16 ; read 16-bit 
    read:  
        mov ah,1 ;readNumberc    
        int 21h
        cmp al,13 ; check if enter is PRESSED
        je readDone                
        cmp al,65  ; 65 = 'A', check if the input is character or not                
        jl readNum   ; jle = jump if less than, if input < 65 => it is number
        jmp readChar  ; if not, it is character
        readNum:                                    
        sub al, 48    ; 48 = 0, to print Number
        ;example, al = 1 (49 in ASCII) and have to sub 48 to equal to 1
        
        jmp save_Number
        readChar:
        sub al, 55 ; 55 = 7, to print Character
        ;example, al = A(65 in ASCII) and have to sub 55 to equal to 10                  
        save_Number:
        xor ah,ah  ; clear ah                
        cmp dx,0   ; check overflow-bit                 
        jne ovf       
        mov y,ax                    
        mov ax,x                     
        mul bx                          ;//////////////  ax  =  ax * bx      ; 
                       
        add ax,y                     
        mov x,ax    ;store input number in x                                
        mov highb,dx ; store high word into highb            
        mov lowb,ax  ; store low word into lowb           
        jmp read                                          
        ovf:         ;overflow occurs (exceed 16bit number)   
        mov x,ax
        mov cx,4     ; input is HEX, must shift left 4 bit 
        ;example 000A -> 00A0 <=> 0000 0000 0000 1010 -> 0000 0000 1010 0000              
        mov dx,highb            
        mov ax,lowb
        shift_Bit: 
        shl ax,1   ; shift left AX                 
        rcl dx,1   ; rotate left DX with bit carry  
        loop shift_Bit                
        add ax,x  
        mov highb,dx
        mov lowb,ax
        jmp read     
    readDone:  
    ret
readNumber  endp

printNumber  proc                        
    mov cx,4    ; input is HEX, must to shift left 4 bit                     
    mov bx,si   ; SI contains the high word of the number   ;0000 0000 0000 1000
    print_High_Bit:
        xor dx,dx
        mov ax,4           ;; 0000 1010 0000 0101
        shift_Bit1:
        shl bx,1    ; shift left bx 1 bit                    ; 0000 0000 1100 0000
        rcl dx,1    ; rotate left dx with carry bit          ; 0000 0000 0000 1101
        dec ax
        cmp ax,0    ; CHECK LOOP
        jne shift_Bit1
        cmp dx,0ah  ; check dx is num
        jge printChar1
        add dx,30h
        jmp print1             
        printChar1:
            add dx,37h
            
        print1: 
        mov ah,2
        int 21h
    loop print_High_Bit

    mov cx,4                        
    mov bx,di    ; DI contains the low word of the number
    print_Low_Bit:
        xor dx,dx
        mov ax,4
        shift_Bit2:
        shl bx,1                    
        rcl dx,1
        dec ax
        cmp ax,0
        jne shift_Bit2
        cmp dx,0ah
        jge printChar2
            add dx,30h
            jmp print2
             
        printChar2:
            add dx,37h
            
        print2:
        mov ah,2
            int 21h
    loop print_Low_Bit   
    ret
printNumber endp 


printNumber32 proc
    mov bx, word ptr result+2   ; Load the high word of the sum into BX
    mov cx, 16                 ; Loop counter

printNumber32Loop:
    mov dl, '0'                ; Default character is '0'
    test bx, 8000h             ; Check the leftmost bit
    jz printNumber32SkipBit    ; If it's 0, skip the next line
    mov dl, '1'                ; Set the character to '1'

printNumber32SkipBit:
    mov ah, 2                  ; Print character function
    int 21h                    ; Print the character

    shl bx, 1                  ; Shift left to process the next bit
    loop printNumber32Loop     ; Loop until all bits are processed

    mov bx, word ptr result     ; Load the low word of the sum into BX
    mov cx, 16                 ; Loop counter

printNumber32LoopLow:
    mov dl, '0'                ; Default character is '0'
    test bx, 8000h             ; Check the leftmost bit
    jz printNumber32SkipBitLow ; If it's 0, skip the next line
    mov dl, '1'                ; Set the character to '1'

printNumber32SkipBitLow:
    mov ah, 2                  ; Print character function
    int 21h                    ; Print the character

    shl bx, 1                  ; Shift left to process the next bit
    loop printNumber32LoopLow  ; Loop until all bits are processed

    ret
printNumber32 endp



plus_Func proc 
    mov cx,word ptr val1  ; load low word of val1 into CX                   
    mov dx,word ptr val2   ; load low word of val2 into DX  
    add cx,dx
    mov [result],cx                          
    mov cx,word ptr val1+2               
    mov dx,word ptr val2+2
    jc carry1   ; if carry flag is set, jump to carry1
    add cx,dx              
    jmp save_Result1
    carry1: 
    add cx, 1       ; plus cx with 1 (1 is the bit-value of carry flag)
    add cx, dx
    save_Result1:
    
    mov [result+2],cx ;
    ret
plus_Func endp
 
 
sub_Func proc
    mov cx,word ptr val1                  
    mov dx,word ptr val2
    sub cx,dx
    mov [result],cx
    mov cx,word ptr val1+2              
    mov dx,word ptr val2+2
    jc carry2  ; if carry flag is set, jump to carry2
    sub cx,dx
    jmp save_Result2
    carry2:
    sub cx,1    ; sub cx with 1 <1 is the bit-vaule of carry flag)
    sub cx,dx
    save_Result2: 
    mov [result+2],cx  
    ret

sub_Func endp

END    
    

    