bits 16
org 0x7c00

start: 
    xor ax,ax
    mov ds,ax
    mov es,ax
    mov ss,ax
    mov sp,0x7c00

clear_screen:
    push bp
    mov bp, sp
    pusha

    mov ah, 0x07    ; tells BIOS to scroll down window
    mov al, 0x00    ; clear entire window
    mov bh, 0x07    ; white on black
    mov cx, 0x00    ; specifies top left of screen as (0,0)
    mov dh, 0x18    ; 18h = 24 rows of chars
    mov dl, 0x4f    ; 4fh = 79 cols of chars
    int 0x10        ; calls video interrupt

    popa
    mov sp, bp
    pop bp

test_disk_extension:
    mov [drive_id],dl
    mov ah,0x41
    mov bx,0x55
    int 0x13
    jc not_support
    cmp bx, 0xaa55
    jne not_support

load_loader:
    mov si,read_packet
    mov word[si],0x10
    mov word[si+2],5
    mov word[si+4],0x7e00
    mov word[si+6],0
    mov dword[si+8],1
    mov dword[si+0xc],0
    mov dl,[drive_id]
    mov ah,0x42
    int 0x13
    jc read_error

    mov dl,[drive_id]
    jmp 0x7e00

read_error:
not_support:
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

drive_id: db 0
message:        db "Failed boot process", 0
message_length: equ $-message
read_packet: times 16 db 0

times (0x1be-($ - $$)) db 0
    db 80h
    db 0,2,0
    db 0f0h
    db 0ffh,0ffh,0ffh
    dd 1
    dd (20*16*63-1)

    times (16*3) db 0

    db 0x55
    db 0xaa
