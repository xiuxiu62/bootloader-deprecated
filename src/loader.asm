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

load_kernel:
    mov si,read_packet
    mov word[si],0x10
    mov word[si+2],100
    mov word[si+4],0
    mov word[si+6],0x1000
    mov dword[si+8],6
    mov dword[si+0xc],0
    mov dl,[drive_id]
    mov ah,0x42
    int 0x13
    jc read_error

    mov ah,0x13
    mov al,0x1
    mov bx,0xa 
    xor dx,dx 
    mov bp,message 
    mov cx,message_length 
    int 0x10

read_error:
not_support:
end:
    hlt
    jmp end

drive_id:       db 0
message:        db "Successfully loaded kernel", 0
message_length: equ $-message
read_packet: times 16 db 0
