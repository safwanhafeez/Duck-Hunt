.model small
.stack 100
.data
    fileA db "logo.bin", 0
    fileB db "game.bin", 0         
    fileC db "cross.bin", 0
    fileD db "duck.bin", 0  
    Msg db "Enter Your Name Below$"
    line1 db "1. Easy Mode        (1 Ducks)$"
    line2 db "2. Hard Mode        (2 Ducks)$"
    line3 db "3. Instructions$"
    line4 db "4. Back$"
    line5 db "5. Exit$"
    line6 db  " INSTRUCTIONS$"
    line7 db "Press ESC to go back$"
    line11 db "GAME OVER ( out of bullets)$"
    line8 db "Score :$"
    line12 db "User Arrow Keys to Move Crosshair$"
    line13 db "Use Space to Shoot$"
    line14 db "Game Over on No Bullets$"
    score dw 0
    aimx dw 150
    aimy dw 100
    dposx dw 40
    dposy dw 130
    dposx2 dw 180
    dposy2 dw 130
    flag dw 0
    hitx dw 0
    hity dw 0
    bullets dw 8
    move dw 0
    dumy db 0
    line9 db "Bullets : $"
    line10 db "lives : $"
    string1 db 50 dup (?)
    filebfr db 200*320 DUP(0)
    ; filebfr2 db 50*180 DUP(0)
    file dw 2 DUP(0)
    tempPosY dw 0
    tempPosX dw 0
    pos_x dw 0
    pos_y dw 0
    temp_c dw 0
    temp_r dw 0
    color db 0
    rows dw 0
    cols dw 0
    counter db 0 
    temp dw 0
    x dw 0
    y dw 0
    
.code
OPEN_FILE proc
    mov ah, 3Dh       
    mov al, 0            
    int 21h 
    mov bx, ax 
    ret
OPEN_FILE endp
READ_FILE proc
    mov ah, 3Fh           
    int 21h   
    ret
READ_FILE endp
CLOSE_FILE proc
    mov ah, 3Eh         
    int 21h  
    ret
CLOSE_FILE endp

LOAD_IMAGE PROC
    mov  dx, file
    call OPEN_FILE    
    mov dx, file+2
    call READ_FILE
    call CLOSE_FILE
    ret
LOAD_IMAGE endp

LOAD_IMAGES proc
    mov file,offset fileA
    mov file+2,offset filebfr
    mov cx, 50 * 180
    call LOAD_IMAGE
    ret
LOAD_IMAGES endp

LOAD_IMAGE2 proc
    mov file,offset fileB
    mov file+2,offset filebfr
    mov cx, 153*320
    call LOAD_IMAGE
    ret
LOAD_IMAGE2 endp

LOAD_IMAGE3 proc
    mov file,offset fileC
    mov file+2,offset filebfr
    mov cx, 11*17
    call LOAD_IMAGE
    ret
LOAD_IMAGE3 endp


LOAD_IMAGE4 proc
    mov file,offset fileD
    mov file+2,offset filebfr
    mov cx, 16*37
    call LOAD_IMAGE
    ret
LOAD_IMAGE4 endp


RESTORE_POSITION proc
    mov ax,pos_x
    mov tempPosX,ax
    mov ax,pos_y
    mov tempPosY,ax
    mov ax,cols
    mov temp_c,ax
    mov ax,rows
    mov temp_r,ax
    ret
RESTORE_POSITION endp

MOVE_RIGHT_PIXEL PROC 
    mov al,color
    mov ah,0ch
    int 10h
    inc cx
    ret
MOVE_RIGHT_PIXEL ENDP

PRINT_IMAGE proc
    mov dx,tempPosY
    OUTER_LOOP:
    mov cx,tempPosX
    mov ax,temp_c
    mov temp,ax
    INNER_LOOP:
    mov al,[si]
    sub al,30h
    mov color,al
    call MOVE_RIGHT_PIXEL         
    inc si         
    dec temp
    cmp temp,0        
    jne INNER_LOOP 
    dec temp_r         
    mov cx,pos_x     
    inc dx  
    cmp temp_r,0        
    jne OUTER_LOOP   
    ret
PRINT_IMAGE endp
GRAPHIC_MODE proc      
    mov ah, 0
    mov al, 13h  
    int 10h  
    ret
GRAPHIC_MODE endp

print proc 
    MOV SI, offset Msg
    ; mov DI, 1032h      ; Initial column position 
    mov dh, 13
    mov dl, 10
    lop:
        ; Set cursor position
        MOV AH, 02h
        MOV BH, 00h    ; Set page number
        ; MOV DX, DI    ; COLUMN number in low BYTE

        INT 10h
        LODSB          ; load current character from DS:SI to AL and increment SI
        CMP AL, '$'    ; Is string-end reached?
        JE  next        ; If yes, continue
        mov AH,09H 
        mov BH, 0      ; Set page number
        mov BL, 2      ; Color (RED)
        mov CX, 1      ; Character count
        INT 10h
        INC DX         ; Increase column position
        jmp lop

    next:
        mov dh, 18  
        mov dl, 13
        int 10h

    input:
        mov si, offset string1
        mov dx,0
        naam:
            mov ah, 1
            int 21h 
            cmp al, 13
            je fin
            mov [si], al
            inc si
            inc dx
            jmp naam
                 
fin:
    ret
print endp

newline proc
    mov dl, 10
    mov ah, 2
    int 21h

    ret
newline endp

boxprint proc
    mov cx, 135
    
    mov x, 95          ; x axis
    mov y, 160          ; y axis

    loop1:
        push cx
        MOV CX, x
        MOV DX, y
        MOV AL, 1111b
        MOV AH, 0CH
        INT 10H
        Inc x
        pop cx
        loop loop1 

    mov cx, 25
    
    loop2:
        push cx
        MOV CX, x
        MOV DX, y
        MOV AL, 1111b
        MOV AH, 0CH
        INT 10H
        dec y
        pop cx
        loop loop2

    mov cx, 135
    
    loop3:
        push cx
        MOV CX, x
        MOV DX, y
        MOV AL, 1111b
        MOV AH, 0CH
        INT 10H
        dec x
        pop cx
        loop loop3

    mov cx, 25
    
    loop4:
        push cx
        MOV CX, x
        MOV DX, y
        MOV AL, 1111b
        MOV AH, 0CH
        INT 10H
        inc y
        pop cx
        loop loop4

    ret
boxprint endp


printstr proc 
    ; mov DI, 1032h      ; Initial column position 
    lop:
        ; Set cursor position
        MOV AH, 02h
        MOV BH, 00h    ; Set page number
        ; MOV DX, DI    ; COLUMN number in low BYTE

        INT 10h
        LODSB          ; load current character from DS:SI to AL and increment SI
        CMP AL, '$'    ; Is string-end reached?
        JE  fin        ; If yes, continue
        mov AH, 09H 
        mov BH, 0      ; Set page number

        mov CX, 1      ; Character count
        INT 10h
        INC DX         ; Increase column position
        jmp lop           
fin:
    ret
printstr endp


instruction proc 
    call GRAPHIC_MODE

    MOV SI, offset line6
    mov dh, 2
    mov dl, 13
    mov BL, 7   ; Color 
    call printstr

    MOV SI, offset line7
    mov dh, 20
    mov dl, 1
    mov BL, 7   ; Color 
    call printstr

    MOV SI, offset line12
    mov dh, 4
    mov dl, 1
    mov BL, 3   ; Color 
    call printstr

    MOV SI, offset line13
    mov dh, 6
    mov dl, 1
    mov BL, 4   ; Color 
    call printstr

    MOV SI, offset line14
    mov dh, 8
    mov dl, 1
    mov BL, 5   ; Color 
    call printstr


    mov ah,0
    int 16h 
    cmp al,1Bh
    je  second
    
    
    ret
instruction endp
gamescreen proc
    call GRAPHIC_MODE
    lop::
    call LOAD_IMAGE2
    mov rows,153
    mov cols,320
    
    ; Moving Code
    mov ax, 320
    sub ax, 180
    shr ax, 1
    shr ax, 1
    mov pos_y,0
    mov ax, 200
    sub ax, 50
    shr ax, 1
    mov pos_x, 0
    mov si,offset filebfr
    call RESTORE_POSITION
    call PRINT_IMAGE
    call printduck
    call hud
    call crosshair

    ; .if ()

    jmp lop
    ret
gamescreen endp

hardmode proc
    call GRAPHIC_MODE
    lop3::
    call LOAD_IMAGE2
    mov rows,153
    mov cols,320
    
    ; Moving Code
    mov ax, 320
    sub ax, 180
    shr ax, 1
    shr ax, 1
    mov pos_y,0
    mov ax, 200
    sub ax, 50
    shr ax, 1
    mov pos_x, 0
    mov si,offset filebfr
    call RESTORE_POSITION
    call PRINT_IMAGE
    ; call printduck
    ; call printduck2
    call printduck3
    call hud
    call crosshair2

    ; .if ()

    jmp lop3
    ret
hardmode endp

twobyte proc
    cmp ax,0

    OUTPUT:
	MOV Bx, 10
	L1:
        mov dx, 0
		CMP Ax, 0
        je zero
		DIV Bx
		MOV cx, dx
		PUSH CX
		inc counter
		JMP L1

    zero:
        cmp counter,0
        jne DISP
        mov dl,48
        mov ah,2
        int 21h
        jmp done


    DISP:
        CMP counter, 0
        JE done
        POP DX
        ADD DX, 48
        MOV AH, 02H
        INT 21H

        dec counter
        JMP DISP
done :
    ret


twobyte endp

hud proc
    ;show bullets
    mov si, offset line9
    mov dh, 21
    mov dl, 3
    mov BL, 15   ; Color (7) 
    call printstr

    MOV AX, bullets
    call twobyte
    .if (bullets == 0 )
        mov si,offset line11
        mov dh, 21
        mov dl, 3
        mov BL, 4   ; Color (7) 
        call printstr
        jmp exit
    .endif
        
    mov si, offset line8
    mov dh, 21
    mov dl, 17
    mov BL, 15   ; Color (7)
    call printstr
    mov ax,score
    call twobyte
    call hitbox
    ret
hud endp

crosshair proc
    call LOAD_IMAGE3
    mov rows,11
    mov cols,17
    mov bx,aimx
    mov pos_x, bx
    mov ax, aimy
    mov pos_y,ax

    mov si,offset filebfr
    call RESTORE_POSITION
    call PRINT_IMAGE
    call movecross
    .if ( aimy == 0 )
        mov cx, 0        
        mov aimy,cx
    .elseif(aimy==270)
        mov cx,270
        mov aimx,cx
    .elseif(aimx==0)
        mov cx,0
        mov aimx,cx
    .elseif(aimx==140)
        mov cx,140
        mov aimx,cx
    .endif
 
    ret
crosshair endp

crosshair2 proc
    call LOAD_IMAGE3
    mov rows,11
    mov cols,17
    mov bx,aimx
    mov pos_x, bx
    mov ax, aimy
    mov pos_y,ax

    mov si,offset filebfr
    call RESTORE_POSITION
    call PRINT_IMAGE
    call movecross2
    .if ( aimy == 0 )
        mov cx, 0        
        mov aimy,cx
    .elseif(aimy==270)
        mov cx,270
        mov aimx,cx
    .elseif(aimx==0)
        mov cx,0
        mov aimx,cx
    .elseif(aimx==140)
        mov cx,140
        mov aimx,cx
    .endif
 
    ret
crosshair2 endp

movecross proc
      
    mov ah,1
    int 16h
    jz lop
    mov ah,0
    int 16h
    
    cmp ah,48h
    je up
    
    cmp ah,75
    je left
    
    cmp ah,77
    je right               
    cmp ah,50h
    je down
    
    cmp al,32
    je shoot
    mov ah,4ch
    int 21h

    
left:
    mov dx,aimx                                   
    sub dx,10
    mov aimx,dx
    jmp done2
up:
    mov cx,aimy                                    
    sub cx,10
    mov aimy,cx
    jmp done2
down:
    mov cx,aimy                                   
    add cx,10
    mov aimy,cx
    jmp done2
right:
    mov dx,aimx                                   
    add dx,10
    mov aimx,dx
    jmp done2

shoot:
    dec bullets
    mov flag,1
    jmp done2    
done2:
    ret
movecross endp

movecross2 proc
      
    mov ah,1
    int 16h
    jz lop3
    mov ah,0
    int 16h
    
    cmp ah,48h
    je up
    
    cmp ah,75
    je left
    
    cmp ah,77
    je right               
    cmp ah,50h
    je down
    
    cmp al,32
    je shoot
    mov ah,4ch
    int 21h

    
left:
    mov dx,aimx                                   
    sub dx,10
    mov aimx,dx
    jmp done2
up:
    mov cx,aimy                                    
    sub cx,10
    mov aimy,cx
    jmp done2
down:
    mov cx,aimy                                   
    add cx,10
    mov aimy,cx
    jmp done2
right:
    mov dx,aimx                                   
    add dx,10
    mov aimx,dx
    jmp done2

shoot:
    dec bullets
    mov flag,1
    jmp done2    
done2:
    ret
movecross2 endp

moveduck proc
    mov dx,dposx
    mov cx, dposy
    mov bp,move
    inc bp
    .if(move == 0 || move == 61 || move == 17 || move ==29 || move ==64 || move ==38 || move ==41|| move ==50|| move ==70)
        mov dx,dposx
        sub dx, 5
        sub cx,5
        mov dposx,dx
        mov dposy,cx
        mov dx,dposx2
        sub dx, 5
        sub cx,5
        mov dposx2,dx
        mov dposy2,cx
      
    .elseif(move == 6 || move ==9 || move ==12 || move ==16 || move ==23 || move ==27 || move ==34|| move ==40|| move ==47|| move ==52)
        mov dx,dposx
        add dx,10
        sub cx,5
        mov dposx,dx
        mov dposy,cx
        mov dx,dposx2
        add dx,10
        sub cx,5
        mov dposx2,dx
        mov dposy2,cx
    .else 
        dec cx
        mov dposy,cx
        dec cx
        mov dposy2,cx
    .endif
    mov move,bp
    ret   
moveduck endp

printduck proc
    call LOAD_IMAGE4
    mov rows,16
    mov cols,37
    mov bx, dposx
    mov pos_x, bx
    mov hitx, bx
    mov ax, dposy
    mov hity, ax
    mov pos_y,ax
    mov si,offset filebfr
    call RESTORE_POSITION
    call PRINT_IMAGE
    call moveduck

    .if ( dposy == 0)
        mov bx, 130        
        mov dposy,bx
    .endif

    ret

printduck endp

printduck3 proc
    call LOAD_IMAGE4
    mov rows,16
    mov cols,37
    mov bx, dposx
    mov pos_x, bx
    mov hitx,bx
    mov ax, dposy
    mov hity, ax
    mov pos_y,ax
    mov si,offset filebfr
    call RESTORE_POSITION
    call PRINT_IMAGE

    .if ( dposy == 0)
        mov bx, 130        
        mov dposy,bx
    .endif

    mov rows,16
    mov cols,37
    mov bx, dposx2
    mov pos_x, bx
    mov hitx,bx
    mov ax, dposy2
    mov hity, ax
    mov pos_y,ax
    mov si, offset filebfr
    call RESTORE_POSITION
    call PRINT_IMAGE
    call moveduck

    .if ( dposy2 == 0)
        mov bx, 130        
        mov dposy2, bx
    .endif

    ret

printduck3 endp

hitbox proc
    mov ax,aimx
    mov bx,aimy
    mov cx,dposx
    mov dx ,dposy
    add cx,16
    add dx,37
    mov hitx,cx
    mov hity,dx
    .if(hitx >=ax && dposx>=ax && hity>=bx && dposy<=bx && flag==1)
        add score, 100
        mov dposx, 5
        mov dposy, 130
    .endif
    ret
hitbox endp


menu2 proc
    MOV SI, offset line1
    mov dh, 13
    mov dl, 6
    mov BL, 10   ; Color (RED)
    call printstr

    MOV SI, offset line2
    mov dh, 15
    mov dl, 6
    mov BL, 10 ; Color (RED)
    call printstr

    MOV SI, offset line3
    mov dh, 17
    mov dl, 6
    mov BL, 10  ; Color (RED)
    call printstr

    MOV SI, offset line4
    mov dh, 19
    mov dl, 6
    mov BL, 10  ; Color (RED)
    call printstr

    MOV SI, offset line5
    mov dh, 21
    mov dl, 6
    mov BL, 10   ; Color (RED)
    call printstr

    mov ah,0
    int 16h

    cmp al, 31h
    je game

    cmp al, 32h
    je hard

    ; cmp al, 32h
    ; je ok
    ; ok1:
    ;     call game

    cmp al, 33h
    je instruct

    cmp al, 34h
    je start

    cmp al, 35h
    je exit

instruct:
    call instruction
ret
menu2 endp

main proc
    mov ax, @data
    mov ds, ax

    ; Main Menu Enter name Page
    start::
    call LOAD_IMAGES
    call GRAPHIC_MODE
    mov rows,50
    mov cols,180
    
    ; Moving Code
    mov ax, 320
    sub ax, 180
    shr ax, 1
    shr ax, 1
    mov pos_y, ax
    mov ax, 200
    sub ax, 50
    shr ax, 1
    ; Moving Code
    mov pos_x, ax
    mov si,offset filebfr
    call RESTORE_POSITION
    call PRINT_IMAGE
    
    call boxprint
    call print

    ; Game Menu 2nd Screen
    second::
    call LOAD_IMAGES
    call GRAPHIC_MODE
    mov rows,50
    mov cols,180
    
    ; Moving Code
    mov ax, 320
    sub ax, 180
    shr ax, 1
    shr ax, 1
    mov pos_y, ax
    mov ax, 200
    sub ax, 50
    shr ax, 1
    ; Moving Code
    mov pos_x, ax
    mov si,offset filebfr
    call RESTORE_POSITION
    call PRINT_IMAGE
    call menu2
    
    ;game screen
    game::
    call gamescreen

    hard::
    call hardmode

    
    ;CLOSE GAME
    exit::
        mov ah,04ch
        int 21h

main endp
end main