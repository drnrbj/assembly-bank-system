; banking.asm - Functional Banking System with better messages
extrn GetStdHandle : PROC
extrn WriteConsoleA : PROC
extrn ReadConsoleA  : PROC

STD_INPUT_HANDLE  equ -10
STD_OUTPUT_HANDLE equ -11

.data
menuMsg db "==== Simple Banking System ====",13,10,\
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
newline db 13,10,0

balance dq 1000
bytesRead dq ?
bytesWritten dq ?
inputBuffer db 32 dup(0)
numBuffer db 32 dup(0)

.code
main PROC
    sub rsp, 40

    ; get console handles
    mov rcx, STD_OUTPUT_HANDLE
    call GetStdHandle
    mov rbx, rax

    mov rcx, STD_INPUT_HANDLE
    call GetStdHandle
    mov rsi, rax

menu_loop:
    ; show menu
    mov rcx, rbx
    lea rdx, menuMsg
    mov r8, LENGTHOF menuMsg - 1
    lea r9, bytesWritten
    call WriteConsoleA

    ; read input
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

; ===========================
check_balance:
    mov rcx, rbx
    lea rdx, balanceMsg
    mov r8, LENGTHOF balanceMsg - 1
    lea r9, bytesWritten
    call WriteConsoleA

    mov rax, balance
    call PrintInt

    mov rcx, rbx
    lea rdx, newline
    mov r8, LENGTHOF newline - 1
    lea r9, bytesWritten
    call WriteConsoleA

    jmp menu_loop

deposit:
    ; Ask for amount
    mov rcx, rbx
    lea rdx, enterAmountMsg
    mov r8, LENGTHOF enterAmountMsg - 1
    lea r9, bytesWritten
    call WriteConsoleA

    ; Read input
    mov rcx, rsi
    lea rdx, inputBuffer
    mov r8, 10
    lea r9, bytesRead
    call ReadConsoleA

    ; Convert ASCII -> integer
    lea rcx, inputBuffer
    call Atoi

    ; Add to balance
    add balance, rax

    ; Print message
    mov rcx, rbx
    lea rdx, depositMsg
    mov r8, LENGTHOF depositMsg - 1
    lea r9, bytesWritten
    call WriteConsoleA

    ; Print balance
    mov rax, balance
    call PrintInt

    ; Newline for clarity
    mov rcx, rbx
    lea rdx, newline
    mov r8, LENGTHOF newline - 1
    lea r9, bytesWritten
    call WriteConsoleA

    ; Add another newline for readability
    mov rcx, rbx
    lea rdx, newline
    mov r8, LENGTHOF newline - 1
    lea r9, bytesWritten
    call WriteConsoleA

    jmp menu_loop


withdraw:
    ; Ask for amount
    mov rcx, rbx
    lea rdx, enterAmountMsg
    mov r8, LENGTHOF enterAmountMsg - 1
    lea r9, bytesWritten
    call WriteConsoleA

    ; Read input
    mov rcx, rsi
    lea rdx, inputBuffer
    mov r8, 10
    lea r9, bytesRead
    call ReadConsoleA

    ; Convert ASCII -> integer
    lea rcx, inputBuffer
    call Atoi

    ; Check if enough balance
    mov rdx, rax
    mov rax, balance
    cmp rax, rdx
    jb insufficient

    sub balance, rdx

    ; Print message
    mov rcx, rbx
    lea rdx, withdrawMsg
    mov r8, LENGTHOF withdrawMsg - 1
    lea r9, bytesWritten
    call WriteConsoleA

    ; Print balance
    mov rax, balance
    call PrintInt

    ; Newlines for spacing
    mov rcx, rbx
    lea rdx, newline
    mov r8, LENGTHOF newline - 1
    lea r9, bytesWritten
    call WriteConsoleA

    mov rcx, rbx
    lea rdx, newline
    mov r8, LENGTHOF newline - 1
    lea r9, bytesWritten
    call WriteConsoleA

    jmp menu_loop



insufficient:
    mov rcx, rbx
    lea rdx, insufficientMsg
    mov r8, LENGTHOF insufficientMsg - 1
    lea r9, bytesWritten
    call WriteConsoleA
    jmp menu_loop

; ===========================
exit_program:
    add rsp, 40
    ret

; ===========================
; PrintInt (preserves registers)
; ===========================

; ===========================
; PrintInt (preserves registers)
; ===========================

; ===========================
; PrintInt (preserves registers)
; ===========================

; ===========================
; PrintInt (preserves registers)
; ===========================

; ===========================
; PrintInt (preserves registers)
; ===========================

; ===========================
; PrintInt (preserves registers)
; ===========================
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

; ===========================
; Atoi — convert ASCII to int
; ===========================
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

main ENDP
END

; ===========================
; PrintInt (preserves registers)
; ===========================; ===========================
; PrintInt (preserves registers)
; ===========================; ===========================
; PrintInt (preserves registers)
; ===========================; ===========================
; PrintInt (preserves registers)
; ===========================