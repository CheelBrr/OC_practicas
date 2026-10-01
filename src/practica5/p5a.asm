%include "../../lib/pc_io.inc"

section .text
    global _start

_start:

    mov edx, msg
    call puts

    ; Modificacion del directo
    mov byte [msg], 'Z'

    mov edx, msg
    call puts

    mov eax, 1
    xor ebx, ebx
    int 0x80

section .data
    msg db 'abcdefghijklmnopqrstuvwxyz0123456789', 0xa, 0

