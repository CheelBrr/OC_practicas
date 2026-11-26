section .data
    bskey     equ 0x7F
    benter    equ 10
    lencadena equ 255
    ln        equ 0x0A
    nline db ln, 0
    msg1 db ln, 'Captura: ', 0
    msg2 db ln, 'Cadena: ', 0
    msg3 db ln, ln, 'Escoge una opcion', ln, '1. Capturar cadena', ln, '2. Minus a Mayus', ln, '3. Mayus a minus', ln, '4. Terminar programa', ln, 'Seleccione una opcion: ', 0
    msg4 db ln, ln, 'Cambio: ', 0

section .bss
    cadena  resb lencadena
    termios resb 36

section .text
    global _start

_start:
.switch:
    mov edx, msg3
    call puts
    call getche
    mov edx, nline
    call puts
    cmp al, '1'
    je .case1
    cmp al, '2'
    je .case2
    cmp al, '3'
    je .case3
    cmp al, '4'
    je .fin_programa
    jmp .switch

.case1:
    mov edx, msg1
    call puts
    mov edx, cadena
    mov esi, cadena         ; ESI = inicio para  no borrar de mas 
    mov ax, lencadena
    call captura

    mov edx, msg2
    call puts

    mov edx, cadena
    call puts

    mov edx, nline
    call puts
    jmp .switch

.case2:
    mov edx, cadena
    call mayus
    mov edx, msg4
    call puts

    mov edx, cadena
    call puts

    mov edx, nline
    call puts
    jmp .switch

.case3:
    mov edx, cadena
    call minus
    mov edx, msg4
    call puts
    mov edx, cadena
    call puts
    mov edx, nline
    call puts
    jmp .switch
.fin_programa:
    mov edx, nline
    call puts
    mov eax, 1             
    xor ebx, ebx
    int 0x80

putchar:
    push eax
    push ebx
    push ecx
    push edx

    push eax  ; este quedaraa en la pila a  cordar
    mov eax, 4             
    mov ebx, 1            
    mov ecx, esp
    mov edx, 1
    int 0x80
    pop eax

    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
puts:
    push eax
    push ebx
    push ecx
    push edx
    push esi

    mov esi, edx
    xor ecx, ecx
.contar:
    cmp byte [esi + ecx], 0
    je .imprimir
    inc ecx
    jmp .contar

.imprimir:
    cmp ecx, 0
    je .fin_puts
    mov edx, ecx     ; l00000000000ongitud
    mov ecx, esi        
    mov eax, 4
    mov ebx, 1
    int 0x80

.fin_puts:
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
getch:
    push ebx
    push ecx
    push edx
    push esi
    push edi
    sub esp, 4           
    mov dword [esp], 0

    call canonical_off

    mov eax, 3             
    mov ebx, 0            
    mov ecx, esp
    mov edx, 1
    int 0x80

    call canonical_on       

    movzx eax, byte [esp]  
    add esp, 4

    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret
getche:
    call getch
    call putchar
    ret

captura:
    push ax
    push edi

    movzx edi, ax
    add edi, esi
    dec edi                

.ciclo:
    call getch
    cmp al, bskey
    je .borrar_char
    cmp al, 0x08
    je .borrar_char
    cmp al, benter
    je .enter
    cmp al, 13
    je .enter

    cmp edx, edi        
    jae .ciclo

    mov byte [edx], al
    inc edx
    call putchar
    jmp .ciclo

.borrar_char:
    call borrar
    jmp .ciclo

.enter:
    mov byte [edx], 0
    pop edi
    pop ax
    ret

borrar:
    push ax
    cmp edx, esi
    je .terminar
    mov al, 0x8
    call putchar
    mov al, ' '
    call putchar
    mov al, 0x8
    call putchar
    dec edx
.terminar:
    pop ax
    ret

mayus:
    push ax
    push edx
.ciclo:
    mov al, [edx]
    cmp al, 0
    je .terminar
    cmp al, 'a'
    jb .siguiente
    cmp al, 'z'
    ja .siguiente
    sub byte [edx], 32
.siguiente:
    inc edx
    jmp .ciclo
.terminar:
    pop edx
    pop ax
    ret

minus:
    push ax
    push edx
.ciclo:
    mov al, [edx]
    cmp al, 0
    je .terminar
    cmp al, 'A'
    jb .siguiente
    cmp al, 'Z'
    ja .siguiente
    add byte [edx], 32
.siguiente:
    inc edx
    jmp .ciclo
.terminar:
    pop edx
    pop ax
    ret

canonical_off:
    push eax
    push ebx
    push ecx
    push edx

    mov eax, 54          
    mov ebx, 0              
    mov ecx, 0x5401         
    mov edx, termios
    int 0x80

    and dword [termios + 12], 0xFFFFFFF5   
    mov byte [termios + 17 + 6], 1        
    mov byte [termios + 17 + 5], 0         

    mov eax, 54
    mov ebx, 0
    mov ecx, 0x5402         
    mov edx, termios
    int 0x80

    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

canonical_on:
    push eax
    push ebx
    push ecx
    push edx

    mov eax, 54
    mov ebx, 0
    mov ecx, 0x5401        
    mov edx, termios
    int 0x80

    or dword [termios + 12], 0x0000000A   
    mov eax, 54
    mov ebx, 0
    mov ecx, 0x5402        
    mov edx, termios
    int 0x80
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret