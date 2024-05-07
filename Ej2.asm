section .data
    ; Define los dos números enteros que deseas multiplicar
    num1 db 6
    num2 db 7

section .text
    global _start

_start:
    ; Multiplica los números y guarda el resultado en el registro ax
    mov al, [num1]   ; Carga el primer número en al
    mul byte [num2] ; Multiplica al por el segundo número, el resultado se almacena en ax

    ; Convierte el resultado a su equivalente en carácter ASCII
    call convertir_a_ascii

    ; Imprime el resultado en la consola
    mov eax, 4       ; Código de la llamada al sistema para sys_write
    mov ebx, 1       ; Descriptor de archivo (1 = STDOUT)
    mov ecx, resultado  ; Dirección del buffer que contiene el resultado
    mov edx, 2       ; Longitud del buffer
    int 0x80         ; Realiza la llamada al sistema

    ; Termina el programa
    mov eax, 1       ; Código de la llamada al sistema para sys_exit
    xor ebx, ebx     ; Código de retorno 0
    int 0x80         ; Realiza la llamada al sistema

convertir_a_ascii:
    ; Divide ax por 10 (resultado en al, residuo en ah)
    mov bl, 10       ; Carga el valor 10 en bl (divisor)
    xor bh, bh       ; Borra bh
    div bl           ; Divide ax por 10

    ; Convierte el residuo a su equivalente en carácter ASCII
    add ah, '0'      ; Convierte el residuo a su equivalente en carácter ASCII
    mov [resultado], ah  ; Guarda el dígito de las unidades

    ; Convierte el cociente a su equivalente en carácter ASCII
    add al, '0'      ; Convierte el cociente a su equivalente en carácter ASCII
    mov [resultado+1], al  ; Guarda el dígito de las decenas

    ret

section .bss
    resultado resb 3   ; Buffer para almacenar el resultado como cadena de caracteres (incluyendo signo negativo)
