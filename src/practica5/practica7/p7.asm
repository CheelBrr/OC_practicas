%include "../../../lib/pc_io.inc"

section .data 
    bskey equ 0x7F     
    benter equ 10      
    lencadena equ 64   
    nline db 10, 0
    
section .bss 
    cadena resb lencadena
    buffer_salida resb lencadena

section .text
    global _start       
    
_start:   
  
    mov edx, cadena
    mov esi, cadena     
    mov ax, lencadena
    call captura   

    mov edx, nline
    call puts
  
    mov edx, cadena
    call atoi           

    mov edi, buffer_salida
    call itoa           

    mov edx, buffer_salida 
    call puts           

  
    mov edx, nline
    call puts

.fin_programa: 
    mov eax, 1          
    xor ebx, ebx        
    int 0x80


atoi:
    push ebx
    push ecx
    push esi

    mov esi, edx      
    xor eax, eax       
    xor ecx, ecx       
    xor ebx, ebx        

.ignorar_espacios:
    mov bl, byte [esi]
    cmp bl, ' '
    je .siguiente_espacio
    cmp bl, 9           
    je .siguiente_espacio
    jmp .revisar_signo

.siguiente_espacio:
    inc esi
    jmp .ignorar_espacios

.revisar_signo:
    cmp bl, '-'
    jne .revisar_mas
    mov ecx, 1        
    inc esi
    jmp .leer_digitos

.revisar_mas:
    cmp bl, '+'
    jne .leer_digitos
    inc esi

.leer_digitos:
    mov bl, byte [esi]
    cmp bl, '0'
    jl .terminar_atoi   
    cmp bl, '9'
    jg .terminar_atoi

    ; EAX = EAX * 10 + (BL - '0')
    imul eax, 10
    sub bl, '0'
    add eax, ebx

    inc esi
    jmp .leer_digitos

.terminar_atoi:
    cmp ecx, 1
    jne .fin_atoi
    neg eax            

.fin_atoi:
    pop esi
    pop ecx
    pop ebx
    ret

itoa:
    push eax
    push ebx
    push ecx
    push edx
    push esi

    mov esi, edi        
    xor ecx, ecx       
    mov ebx, 10         

    cmp eax, 0
    jge .ciclo_division
    ; Si es negativo
    mov byte [edi], '-' 
    inc edi
    mov esi, edi       
    neg eax             

.ciclo_division:
    xor edx, edx
    div ebx             
    add dl, '0'         
    push edx           
    inc ecx             
    cmp eax, 0
    jg .ciclo_division

.sacar_pila:
    pop edx             
    mov [edi], dl       
    inc edi
    loop .sacar_pila

    mov byte [edi], 0   

    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

captura:
    push ax             
.ciclo: 
    call getch          
    cmp al, bskey       
    jne .scomp          
    call borrar
    jmp .ciclo
.scomp: 
    cmp al, benter  
    je .enter           
    mov byte[edx], al
    inc edx
    call putchar        
    jmp .ciclo
.enter: 
    mov byte[edx], 0
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
