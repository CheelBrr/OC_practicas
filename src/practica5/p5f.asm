%include "../../lib/pc_io.inc"

section .text
    global _start

_start:
   
    mov edx, msg
    call puts

    ; Base + indice*Escala + Desplazamiento
    mov ebx, msg
    mov esi, 4
    mov byte [ebx + esi*4 + 3], '%'

    mov edx, msg
    call puts

    mov eax, 1
    xor ebx, ebx
    int 0x80

section .data
    msg db 'abcdefghijklmnopqrstuvwxyz0123456789', 0xa, 0