
global set_bit
global get_bit

section .text
set_bit:
    push ebp                  
    mov ebp, esp

    mov edx, [ebp + 8]        
    mov cl,  [ebp + 12]       
    cmp cl, 7
    ja  .fin                  
    mov al, 1
    shl al, cl                
    or  [edx], al            
.fin:
    mov esp, ebp              
    pop ebp
    ret

get_bit:
    push ebp
    mov ebp, esp

    movzx eax, byte [ebp + 8] 
    mov cl, [ebp + 12]       
    cmp cl, 7
    ja  .fuera               

    shr eax, cl               
    and eax, 1                
    jmp .fin
.fuera:
    xor eax, eax
.fin:
    mov esp, ebp
    pop ebp
    ret