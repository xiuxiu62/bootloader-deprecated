bits 16
org 0x7e00

start:
    mov ah,0x13
    mov al,0x1
    mov bx,0xa 
    xor dx,dx 
    mov bp,message 
    mov cx,message_length 
    int 0x10

end:
    hlt
    jmp end

message:        db "Starting loader", 0
message_length: equ $-message
