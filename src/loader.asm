bits 16
org 0x7e00

start:
    mov [drive_id],dl

    mov eax,0x80000000
    cpuid
    cmp eax, 0x80000001
    jb not_support

    mov eax,0x80000001 ; check processor features
    cpuid
    test edx,(1<<29)   ; long mode support
    jz not_support
    test edx,(1<<26)   ; 1G page support
    jz not_support

    mov ah,0x13
    mov al,0x1
    mov bx,0xa 
    xor dx,dx 
    mov bp,message 
    mov cx,message_length 
    int 0x10

not_support:
end:
    hlt
    jmp end

drive_id:       db 0
message:        db "Long mode supported", 0
message_length: equ $-message
