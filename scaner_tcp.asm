section .data
    server_ip db '127.0.0.1', 0 ; Локальный IP-адрес для сканирования
    port dw 8000 ; Начальный порт для сканирования
section .bss
    sock resb 1
section .text
global _start
_start:
    ; Создаем сокет
    mov eax, 41             ; Системный вызов socket
    mov edi, 2              ; AF_INET (IPv4)
    mov esi, 1              ; SOCK_STREAM (TCP)
    mov edx, 0              ; Протокол по умолчанию
    syscall
    mov [sock], eax         ; Сохраняем дескриптор сокета
    ; Подготавливаем адресную структуру
    mov rdi, rsp            ; Используем стек для структуры sockaddr
    mov word [rdi], 0x0200  ; AF_INET
    mov word [rdi+2], port  ; Порт
    ; Конвертируем IP в сетевой порядок байтов - это будет сложнее и требует дополнительного кода
    ; Пробуем подключиться
    mov eax, 42             ; Системный вызов connect
    mov rsi, rdi            ; Указываем адрес структуры sockaddr
    mov edx, 16             ; Размер структуры sockaddr_in
    syscall
    ; Проверяем результат подключения
    test eax, eax
    jz .port_open
    jmp .port_closed
.port_open:
    ; Обрабатываем открытый порт
    ; Выводим сообщение или делаем другие действия
    jmp .cleanup
.port_closed:
    ; Обрабатываем закрытый порт
    ; Выводим сообщение или делаем другие действия
.cleanup:
    ; Закрываем сокет
    mov eax, 3              ; Системный вызов close
    mov edi, [sock]         ; Дескриптор сокета
    syscall
    ; Завершаем программу
    mov eax, 60             ; Системный вызов exit
    xor edi, edi            ; Код возврата 0
    syscall
