%include "../../lib/pc_io.inc"

section .data
    bskey equ 0x7F
    benter equ 10
    lencadena equ 255
    ln equ 0x0A
    nline db ln, 0
    msg1 db ln, 'Captura: ', 0
    msg2 db ln, 'Cadena: ', 0
    msg3 db ln, ln, 'Escoge una opcion', ln, '(1) - Capturar cadena', ln, '(2) - Minus a Mayus', ln, '(3) - Mayus a minus', ln, '(4) - Terminar programa', ln, 'Escoge una opcion: ', 0
    msg4 db ln, ln, 'Cambio: ', 0

section .bss
    cadena resb lencadena

section .text
    global _start

_start:

.switch:
    mov edx, msg3
    call puts
    call getche

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
    mov esi, cadena
    mov ax, lencadena
    call captura

    mov edx, msg2
    call puts

    mov edx, cadena
    call puts
    jmp .switch

.case2:
    mov edx, cadena
    call mayus
    mov edx, msg4
    call puts

    mov edx, cadena
    call puts
    jmp .switch

.case3:
    mov edx, cadena
    call minus
    mov edx, msg4
    call puts

    mov edx, cadena
    call puts
    jmp .switch

.fin_programa:
    mov edx, nline
    call puts
    call puts
    mov eax, 1
    xor ebx, ebx
    int 0x80

captura:
    push ax

.ciclo:
    call getch
    cmp al, bskey
    je .borrar_char
    cmp al, benter
    je .enter
    mov byte [edx], al
    inc edx
    call putchar
    jmp .ciclo

.borrar_char:
    call borrar
    jmp .ciclo

.enter:
    mov byte [edx], 0
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

.ciclo:
    mov al, [edx]
    cmp al, 0
    je .terminar
    cmp al, 97
    jl .siguiente
    cmp al, 122
    jg .siguiente
    sub byte [edx], 32

.siguiente:
    inc edx
    jmp .ciclo

.terminar:
    pop ax
    ret

minus:
    push ax

.ciclo:
    mov al, [edx]
    cmp al, 0
    je .terminar
    cmp al, 65
    jl .siguiente
    cmp al, 90
    jg .siguiente
    add byte [edx], 32

.siguiente:
    inc edx
    jmp .ciclo

.terminar:
    pop ax
    ret
