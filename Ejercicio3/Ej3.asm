section .data
    ; Define los dos números enteros que deseas dividir
    dividend dd 20
    divisor dd 5

section .text
    global _start

_start:
    ; Divide los números y guarda el resultado en el registro eax
    mov eax, [dividend]   ; Carga el dividendo en eax
    cdq                    ; Extiende el signo de eax a edx (prepara edx:eax para la división)
    idiv dword [divisor]   ; Divide edx:eax por el divisor (resultado en eax, residuo en edx)

    ; Convertir el resultado a su equivalente en carácter ASCII
    mov esi, resultado    ; Puntero al buffer resultado
    mov ecx, 0            ; Inicializa el contador de dígitos

    ; Manejo del signo
    cmp eax, 0            ; Comprueba si el resultado es negativo
    jge print_result      ; Si es positivo o cero, omitir el signo negativo
    mov byte [esi], '-'   ; Agrega un signo negativo al principio del resultado
    inc ecx               ; Incrementa el contador de dígitos
    neg eax               ; Convierte el resultado a positivo

print_result:
    ; Convierte los dígitos del resultado a su equivalente en carácter ASCII
    mov ebx, 10           ; Carga el valor 10 en ebx (divisor)
.loop:
    xor edx, edx          ; Limpia edx para la próxima división
    div ebx               ; Divide eax por 10 (resultado en eax, residuo en edx)
    add dl, '0'           ; Convierte el residuo a su equivalente en carácter ASCII
    mov [esi + ecx], dl   ; Guarda el dígito en el buffer resultado
    inc ecx               ; Incrementa el contador de dígitos
    test eax, eax         ; Comprueba si eax es cero (todos los dígitos procesados)
    jnz .loop             ; Si no es cero, continúa el bucle

    ; Invierte el buffer resultado para obtener el resultado correcto
    mov esi, resultado    ; Reinicia el puntero al buffer resultado
    mov edi, esi          ; Puntero de destino para la inversión
    mov ebx, ecx          ; Longitud del resultado
    mov ecx, ebx          ; Usamos ecx como contador
    shr ecx, 1            ; Dividimos la longitud por dos
    jz .skip_reverse      ; Si la longitud es 0 o 1, no necesitamos invertir

.reverse_loop:
    mov al, [esi]         ; Carga el primer byte
    mov ah, [edi + ebx - 1] ; Carga el byte opuesto
    mov [esi], ah         ; Intercambia los bytes
    mov [edi + ebx - 1], al
    inc esi
    dec ebx
    loop .reverse_loop    ; Repite hasta que todos los bytes estén intercambiados

.skip_reverse:
    ; Imprime el resultado en la consola
    mov eax, 4            ; Código de la llamada al sistema para sys_write
    mov ebx, 1            ; Descriptor de archivo (1 = STDOUT)
    mov ecx, resultado    ; Dirección del buffer que contiene el resultado
    mov edx, ecx          ; Longitud del buffer
    dec edx               ; Restamos 1 para omitir el byte nulo final
    int 0x80              ; Realiza la llamada al sistema

    ; Termina el programa
    mov eax, 1            ; Código de la llamada al sistema para sys_exit
    xor ebx, ebx          ; Código de retorno 0
    int 0x80              ; Realiza la llamada al sistema

section .bss
    resultado resb 11      ; Buffer para almacenar el resultado como cadena de caracteres (incluyendo signo negativo)
