.model small
.stack 100h

.data
returnIndex dw 0                ;змінна індексу для для повернення до місця виклику функції
char db  0                      ;містить зчитаний символ
numbers dw 10000 dup(?)         ;масив наших чисел
digitsRead dw 0                 ;кількість цифр у числі
readNum dw 0                    ;кількість зчитаних з файлу чисел



.code
main PROC
    mov ax, @data
    mov ds, ax

    ;ініціалізуємо регістрів значеннями нуль для подальшої роботи
    xor ax, ax 
    xor bx, bx
    xor cx, cx
    xor dx, dx

    call read_loop   ;читання символів
    call to_decimal  ;конвертація символів в десяткові числа    
main ENDP

read_loop PROC
    pop returnIndex  ;зберігаємо адресу повернення для роботи зі стеком
    read_file:
        mov ah, 3Fh
        mov bx, 0h    ; stdin handle
        mov cx, 1     ; 1 byte to read
        lea dx, char  ; read to ds:dx 
        int 21h                        
        or ax, ax     ; if EOF
        jz eof

        mov dl, char 

        cmp dl, 13          ; якщо LF
        je not_digit
        cmp dl, 10          ; якщо CR
        je not_digit
        cmp dl, ' '         ; якщо пробіл
        je not_digit
        cmp dl, 0           ; якщо EOF
        je eof
        cmp dl, '-'         ; якщо мінус
        je negative
        cmp digitsRead, 6
        je read_file
        inc digitsRead
        sub dl, '0'
        push dx
        jmp read_file
        
    ;якщо не цифра, до цього були прочитані числа то заверщуємо рахувати 
    not_digit:
        cmp digitsRead, 0
        jne end_of_num
        jmp read_file
    negative:
        push dx
        inc digitsRead
        jmp read_file
    eof:
        cmp digitsRead, 0
        jne last
        push returnIndex
        ret
    end_of_num:
        push digitsRead
        mov digitsRead, 0
        inc readNum
        jmp read_file
    last:
        push digitsRead
        mov digitsRead, 0
        inc readNum
        push returnIndex
        ret  
read_loop ENDP

end_program PROC
    xor ax, ax 
    xor bx, bx
    xor cx, cx
    xor dx, dx
    mov ah, 4Ch 
    int 21h 
end main