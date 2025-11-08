extrn GetStdHandle : PROC
extrn WriteConsoleA : PROC
extrn ReadConsoleA  : PROC

STD_INPUT_HANDLE  equ -10
STD_OUTPUT_HANDLE equ -11
MAX_INPUT         equ 32

.data

menuMsg db 13,10,"==== Simple Banking System ====",13,10,\
         "1. Check Balance",13,10,\
         "2. Deposit",13,10,\
         "3. Withdraw",13,10,\
         "4. Exit",13,10,\
         "Select option: ",0

enterAmountMsg db 13,10,"Enter amount: ",0
invalidMsg db 13,10,"Invalid option!",13,10,0
insufficientMsg db 13,10,"Insufficient funds!",13,10,0
balanceMsg db 13,10,"Your balance is: P",0
depositMsg db 13,10,"Current balance after deposit: P",0
withdrawMsg db 13,10,"Current balance after withdrawal: P",0
depositSuccess db 13,10,"Deposit successful!",13,10,0
withdrawSuccess db 13,10,"Withdrawal successful!",13,10,0
pauseMsg db 13,10,"Press Enter to continue...",13,10,0
lineSep db "----------------------------------------",13,10,0
newline db 13,10,0

balance dq 1000
bytesRead dq ?
bytesWritten dq ?
inputBuffer db MAX_INPUT dup(0)
numBuffer db 32 dup(0)

.code
main PROC
    sub rsp, 40

    mov rcx, STD_OUTPUT_HANDLE
    call GetStdHandle
    mov rbx, rax

    mov rcx, STD_INPUT_HANDLE
    call GetStdHandle
    mov rsi, rax

menu_loop:
    mov rcx, rbx
    lea rdx, newline
    mov r8, LENGTHOF newline - 1
    lea r9, bytesWritten
    call WriteConsoleA

    mov rcx, rbx
    lea rdx, menuMsg
    mov r8, LENGTHOF menuMsg - 1
    lea r9, bytesWritten
    call WriteConsoleA

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
    call WaitForEnter
    jmp menu_loop
;;;;;;;;;;;;;;;;;;;;;;;;
check_balance:
    mov rcx, rbx
    lea rdx, lineSep
    mov r8, LENGTHOF lineSep - 1
    lea r9, bytesWritten
    call WriteConsoleA

    mov rcx, rbx
    lea rdx, balanceMsg
    mov r8, LENGTHOF balanceMsg - 1
    lea r9, bytesWritten
    call WriteConsoleA

    mov rax, qword ptr [balance]
    call PrintInt

    mov rcx, rbx
    lea rdx, newline
    mov r8, LENGTHOF newline - 1
    lea r9, bytesWritten
    call WriteConsoleA

    lea rdx, lineSep
    mov rcx, rbx
    mov r8, LENGTHOF lineSep - 1
    lea r9, bytesWritten
    call WriteConsoleA

    call WaitForEnter
    jmp menu_loop

deposit:
    mov rcx, rbx
    lea rdx, enterAmountMsg
    mov r8, LENGTHOF enterAmountMsg - 1
    lea r9, bytesWritten
    call WriteConsoleA

    mov rcx, rsi
    lea rdx, inputBuffer
    mov r8, 10
    lea r9, bytesRead
    call ReadConsoleA

    lea rcx, inputBuffer
    call Atoi

    cmp rax, 0
    jle invalid_deposit

    add qword ptr [balance], rax

    mov rcx, rbx
    lea rdx, depositSuccess
    mov r8, LENGTHOF depositSuccess - 1
    lea r9, bytesWritten
    call WriteConsoleA

    mov rcx, rbx
    lea rdx, depositMsg
    mov r8, LENGTHOF depositMsg - 1
    lea r9, bytesWritten
    call WriteConsoleA

    mov rax, qword ptr [balance]
    call PrintInt

    mov rcx, rbx
    lea rdx, newline
    mov r8, LENGTHOF newline - 1
    lea r9, bytesWritten
    call WriteConsoleA

    call WaitForEnter
    jmp menu_loop

invalid_deposit:
    mov rcx, rbx
    lea rdx, invalidMsg
    mov r8, LENGTHOF invalidMsg - 1
    lea r9, bytesWritten
    call WriteConsoleA
    call WaitForEnter
    jmp menu_loop

withdraw:
    mov rcx, rbx
    lea rdx, enterAmountMsg
    mov r8, LENGTHOF enterAmountMsg - 1
    lea r9, bytesWritten
    call WriteConsoleA

    mov rcx, rsi
    lea rdx, inputBuffer
    mov r8, 10
    lea r9, bytesRead
    call ReadConsoleA

    lea rcx, inputBuffer
    call Atoi
    mov rdx, rax 

    cmp rdx, 0
    jle invalid_withdraw

    mov rax, qword ptr [balance]
    cmp rax, rdx
    jb insufficient

    sub qword ptr [balance], rdx

    mov rcx, rbx
    lea rdx, withdrawSuccess
    mov r8, LENGTHOF withdrawSuccess - 1
    lea r9, bytesWritten
    call WriteConsoleA

    mov rcx, rbx
    lea rdx, withdrawMsg
    mov r8, LENGTHOF withdrawMsg - 1
    lea r9, bytesWritten
    call WriteConsoleA

    mov rax, qword ptr [balance]
    call PrintInt

    mov rcx, rbx
    lea rdx, newline
    mov r8, LENGTHOF newline - 1
    lea r9, bytesWritten
    call WriteConsoleA

    call WaitForEnter
    jmp menu_loop

invalid_withdraw:
    mov rcx, rbx
    lea rdx, invalidMsg
    mov r8, LENGTHOF invalidMsg - 1
    lea r9, bytesWritten
    call WriteConsoleA
    call WaitForEnter
    jmp menu_loop

insufficient:
    mov rcx, rbx
    lea rdx, insufficientMsg
    mov r8, LENGTHOF insufficientMsg - 1
    lea r9, bytesWritten
    call WriteConsoleA
    call WaitForEnter
    jmp menu_loop

exit_program:
    add rsp, 40
    ret

PrintInt PROC
    push rbx
    push rdi
    push rcx
    push rdx
    push r8
    push r9

    mov rbx, 10
    lea rdi, numBuffer + 31
    mov byte ptr [rdi], 0

convert_loop:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    test rax, rax
    jnz convert_loop

    mov rcx, STD_OUTPUT_HANDLE
    call GetStdHandle
    mov rcx, rax
    lea rdx, [rdi]
    mov r8, 32
    lea r9, bytesWritten
    call WriteConsoleA

    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rdi
    pop rbx
    ret
PrintInt ENDP

Atoi PROC
    xor rax, rax
    xor rbx, rbx
next_digit:
    mov bl, [rcx]
    cmp bl, 13
    je done
    cmp bl, 10
    je done
    cmp bl, 0
    je done
    cmp bl, '0'
    jb done
    cmp bl, '9'
    ja done
    imul rax, 10
    sub bl, '0'
    add rax, rbx
    inc rcx
    jmp next_digit
done:
    ret
Atoi ENDP

WaitForEnter PROC
    mov rcx, rbx
    lea rdx, pauseMsg
    mov r8, LENGTHOF pauseMsg - 1
    lea r9, bytesWritten
    call WriteConsoleA

    mov rcx, rsi
    lea rdx, inputBuffer
    mov r8, 10
    lea r9, bytesRead
    call ReadConsoleA
    ret
WaitForEnter ENDP

main ENDP
END
