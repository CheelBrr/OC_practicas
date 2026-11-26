
%macro WHILE 2
    %push while
%$inicio:
    cmp %1, %2
    jge %$fin
%endmacro

%macro ENDWHILE 0
    jmp %$inicio
%$fin:
    %pop
%endmacro

global maximo
global minimo
global sumatoria

section .text

maximo:
    push ebp
    mov ebp, esp

    xor eax, eax
    cmp dword [ebp+12], 0
    jle .fin                   

    mov edx, [ebp+8]           
    mov eax, [edx]              
    mov ecx, 1                 

    WHILE ecx, [ebp+12]         
        cmp eax, [edx+ecx*4]
        jge .sig                
        mov eax, [edx+ecx*4]    
.sig:
        inc ecx
    ENDWHILE

.fin:
    pop ebp
    ret

minimo:
    push ebp
    mov ebp, esp

    xor eax, eax
    cmp dword [ebp+12], 0
    jle .fin

    mov edx, [ebp+8]
    mov eax, [edx]              
    mov ecx, 1

    WHILE ecx, [ebp+12]
        cmp eax, [edx+ecx*4]
        jle .sig                
        mov eax, [edx+ecx*4]   
.sig:
        inc ecx
    ENDWHILE

.fin:
    pop ebp
    ret


sumatoria:
    push ebp
    mov ebp, esp

    xor eax, eax               
    mov edx, [ebp+8]
    xor ecx, ecx                

    WHILE ecx, [ebp+12]
        add eax, [edx+ecx*4]    
        inc ecx
    ENDWHILE

    pop ebp
    ret

