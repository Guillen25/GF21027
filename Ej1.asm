section .data
    ; Define los tres números enteros que deseas restar
    num1 dw 6
    num2 dw 1
    num3 dw 1

section .text
    global _start

_start:
    ; Resta los números y guarda el resultado en el registro ax
    mov ax, [num1]   ; Carga el primer número en ax
    sub ax, [num2]   ; Resta el segundo número de ax
    sub ax, [num3]   ; Resta el tercer número de ax

    ; Verifica si el resultado es negativo antes de la conversión a caracteres ASCII
    test ax, ax      ; Comprueba si el resultado es negativo (AX = 0 si no es negativo)
    jns resultado_positivo  ; Salta si el resultado es positivo

    ; Si el resultado es negativo, convierte el valor absoluto a caracteres ASCII y agrega un signo negativo
    neg ax           ; Obtiene el valor absoluto del resultado negativo
    mov byte [resultado], '-'  ; Guarda el signo negativo en memoria
    jmp convertir_a_ascii

resultado_positivo:
    ; Si el resultado es positivo, convierte el valor a caracteres ASCII
    mov byte [resultado], ' '  ; No es necesario un signo '+' para resultados positivos

convertir_a_ascii:
    ; Convertir el resultado a su equivalente en carácter ASCII
    mov bx, 10       ; Carga el valor 10 en bx (divisor)
    cmp ax, 0        ; Comprueba si el resultado es cero (para evitar división por cero)
    je imprimir_resultado  ; Si es cero, salta directamente a la impresión

    ; Divide ax por 10 (resultado en ax, residuo en dx)
    div bx

    ; Convierte el residuo a su equivalente en carácter ASCII
    add dl, '0'      ; Convierte el residuo a su equivalente en carácter ASCII
    mov [resultado+1], dl  ; Guarda el dígito de las unidades

    ; Continúa dividiendo hasta que el cociente sea cero
    cmp ax, 0
    jne convertir_a_ascii  ; Si el cociente no es cero, continúa la conversión

imprimir_resultado:
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

section .bss
    resultado resb 3   ; Buffer para almacenar el resultado como cadena de caracteres (incluyendo signo negativo)