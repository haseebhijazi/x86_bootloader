;---------------BOOTLOADER-------------------
;--AUTHOR: #45338 #1J421---------------------
;--DATE  : 0x3E4967------(DL:DD/MM--DH:YYYY)-
;--------------------------------------------

bits 16                     ; 16 bit code

; stack
mov ax, 0x7C0               ; 0x7C00 is standard boot sector address (0x7C00 / 16)
mov ds, ax
mov ax, 0x7E0               ; (0x7C00 + 0x200) / 16 = 0x7E00 / 16
mov ss, ax     
mov sp, 0x2000              ; 8KB = 0x2000 byte stack

call clearscreen            ; clear screen

push 0x0000                 ; arg (00,00)
call movecursor             ; move cursor to 0,0
add sp, 2                   ; remove arg from stack (2 bytes)

push msg                    ; arg (msg)
call print                  ; print msg
add sp, 2                   ; remove arg from stack (2 bytes)

cli                         ; disable interrupts
hlt                         ; halt

clearscreen:
    push bp                 ; save the caller's base pointer on stack
    mov bp, sp              ; update base pointer with the current stack base
    pusha                   ; Save all general-purpose regs on stack

    mov ah, 0x07            ; 0x07 = scroll down
    mov al, 0x00            ; 0x00 rows srolled : screen cleared
    mov bh, 0x07            ; Light Grey text on black background (attribute)
    mov cx, 0x00            ; Upper left  corner of screen (00,00)
    mov dh, 0x18            ; Lower right corner of screen (24,--)
    mov dl, 0x4f            ; Lower right corner of screen (--,79)
    int 0x10                ; Call BIOS interrupt 0x10 (video services)

    popa                    ; Restore all general-purpose regs from stack
    mov sp, bp              ; restore stack pointer
    pop bp                  ; restore base pointer from stack
    ret                     ; return to caller

movecursor:
    push bp                 ; save the caller's base pointer on stack
    mov bp, sp              ; update base pointer with the current stack base
    pusha                   ; Save all general-purpose regs on stack

    mov dx, [bp+4]          ; move args to dx 
    mov ah, 0x02            ; 0x02 = set cursor position
    mov bh, 0x00            ; page number 0
    int 0x10                ; Call BIOS interrupt 0x10 (video services)

    popa                    ; Restore all general-purpose regs from stack
    mov sp, bp              ; restore stack pointer
    pop bp                  ; restore base pointer from stack
    ret                     ; return to caller

print:
    push bp                 ; save the caller's base pointer on stack
    mov bp, sp              ; update base pointer with the current stack base
    pusha                   ; Save all general-purpose regs on stack
    mov si, [bp+4]          ; move args to source index reg (si)
    mov bh, 0x00            ; page number 0
    mov bl, 0x07            ; Light Grey text (attribute)
    mov ah, 0x0E            ; 0x0E = teletype output
.char:
    mov al, [si]            ; move char to al
    inc si                  ; next char
    cmp al, 0x00            ; if char is null
    je .done                ; jump to done
    int 0x10                ; Call BIOS interrupt 0x10 (video services) : PRINT
    jmp .char               ; loop
.done:
    popa                    ; Restore all general-purpose regs from stack
    mov sp, bp              ; restore stack pointer
    pop bp                  ; restore base pointer from stack
    ret                     ; return to caller

msg: db "Ready to go Retro!", 0x00 ; null terminated string

times 510-($-$$) db 0       ; pad remainder of 510 bytes of boot sector with 0s
dw 0xAA55                   ; boot signature (0xAA55)