.model small
.stack 100h

.data
returnIndex dw 0                ;змінна індексу для для повернення до місця виклику функції
char db  0                      ;містить зчитаний символ
numbers dw 10000 dup(?)         ;масив наших чисел
digitsRead dw 0                 ;кількість цифр у числі
readNum dw 0                    ;кількість зчитаних з файлу чисел
returnIndexAddToArray dw 0      ;змінна індексу для повернення для масиву
numIndex dw 0                   ;індекс для роботи з масивом чисел
sum dw 0                        ;сума для обчислення числа


.code
main PROC
    mov ax, @data
    mov ds, ax

    ;ініціалізуємо регістри значеннями нуль для подальшої роботи
    xor ax, ax 
    xor bx, bx
    xor cx, cx
    xor dx, dx

    call read_loop   ; читання символів  
    call bubbleSort  ; бульбашкове сортування
main ENDP

bubble_sort PROC
    mov cx, readNum
    dec cx                              ; порівняння виконується (N-1) разів
    mov bx, 0                           ; індекс першого елемента
    outer_loop:
        push cx 
        mov si, bx                      ; si починає з першого елемента масиву
        mov cx, readNum 
        dec cx                          ; порівняння виконується (N-1) разів в кожному проході
        inner_loop:
            mov ax, [numbers + si]      ; завантажуємо поточний елемент
            cmp ax, [numbers + si + 2] 
            jle no_swap 
            xchg ax, [numbers + si + 2]
            mov [numbers + si], ax
            no_swap:
            add si, 2 
            loop inner_loop
        pop cx 
        loop outer_loop
    ret
bubble_sort ENDP

read_loop PROC
    pop returnIndex   ;зберігаємо адресу повернення для роботи зі стеком
    mov si, offset numbers 
    read_file:
        mov ah, 3Fh
        mov bx, 0h    ; stdin handle
        mov cx, 1     ; 1 byte to read
        lea dx, char  ; read to ds:dx 
        int 21h                        
        or ax, ax     ; if EOF
        jz eof

        mov dx, 0
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

        push si
        call numbers_to_array
        add si, 2

        inc readNum
        jmp read_file
    last:
        push digitsRead
        mov digitsRead, 0

        push si
        call numbers_to_array
        add si, 2

        inc readNum
        push returnIndex
        ret  
read_loop ENDP

numbers_to_array PROC
    pop word ptr [returnIndexAddToArray]
    pop word ptr [numIndex]
    pop cx                      ; витягуємо кількість зчитаних чисел
    mov word ptr [sum], 0
    mov bx, 1
    num_mult:
        pop ax
        cmp al, '-'
        je to_negative
        
        mul bx
        add word ptr [sum], ax

        mov ax, bx
        mov bx, 0Ah
        mul bx
        mov bx, ax

        dec cx
        jnz num_mul
        jmp end_numbers_to_array

    to_negative:
        not word ptr [sum]
        inc word ptr [sum]
        jmp end_numbers_to_array

    end_numbers_to_array:
        mov bx, word ptr [numIndex]
        mov ax, word ptr [sum]
        
        mov word ptr [bx], ax
        push word ptr [returnIndexAddToArray]
        ret
numbers_to_array ENDP  

end_program PROC
    xor ax, ax 
    mov ah, 4Ch 
    int 21h 
end main