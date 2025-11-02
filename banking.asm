; banking.asm
; A simple Banking System with basic input handling

extrn GetStdHandle : PROC
extrn WriteConsoleA : PROC
extrn ReadConsoleA  : PROC

STD_INPUT_HANDLE  equ -10
STD_OUTPUT_HANDLE equ -11

.data
menuMsg db "==== Simple Banking System ====", 13,10, \
         "1. Check Balance", 13,10, \
         "2. Deposit", 13,10, \
         "3. Withdraw", 13,10, \
         "4. Exit", 13,10, \
         "Select option: ", 0

invalidMsg db 13,10, "Invalid option!", 13,10,0
balanceMsg db 13,10, "Your balance is: P", 0
newline db 13,10,0

balance dq 1000              ; starting balance
bytesRead dq ?
bytesWritten dq ?
inputBuffer db 10 dup(0)     ; space for input characters

.code
main PROC
    sub rsp, 40

    ; Get console handles
    mov rcx, STD_OUTPUT_HANDLE
    call GetStdHandle
    mov rbx, rax              ; output handle

    mov rcx, STD_INPUT_HANDLE
    call GetStdHandle
    mov rsi, rax              ; input handle

menu_loop:
    ; Print menu
    mov rcx, rbx
    lea rdx, menuMsg
    mov r8, LENGTHOF menuMsg - 1
    lea r9, bytesWritten
    call WriteConsoleA

    ; Read user input
    mov rcx, rsi
    lea rdx, inputBuffer
    mov r8, 10
    lea r9, bytesRead
    call ReadConsoleA

    mov al, [inputBuffer]
    cmp al, '1'
    je check_balance
    cmp al, '2'
    je deposit
    cmp al, '3'
    je withdraw
    cmp al, '4'
    je exit_program

invalid_option:
    mov rcx, rbx
    lea rdx, invalidMsg
    mov r8, LENGTHOF invalidMsg - 1
    lea r9, bytesWritten
    call WriteConsoleA
    jmp menu_loop

check_balance:
    mov rcx, rbx
    lea rdx, balanceMsg
    mov r8, LENGTHOF balanceMsg - 1
    lea r9, bytesWritten
    call WriteConsoleA

    mov rcx, rbx
    lea rdx, newline
    mov r8, LENGTHOF newline - 1
    lea r9, bytesWritten
    call WriteConsoleA
    jmp menu_loop

deposit:
    mov rcx, rbx
    lea rdx, newline
    mov r8, LENGTHOF newline - 1
    lea r9, bytesWritten
    call WriteConsoleA
    jmp menu_loop

withdraw:
    mov rcx, rbx
    lea rdx, newline
    mov r8, LENGTHOF newline - 1
    lea r9, bytesWritten
    call WriteConsoleA
    jmp menu_loop

exit_program:
    add rsp, 40
    ret
main ENDP
END
