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

get_mem_info_start:
    mov eax,0xe820
    mov edx,0x534d4150
    mov ecx,20
    mov edi,0x9000
    xor ebx,ebx
    int 0x15
    jc not_support

get_mem_info:
    add edi,20
    mov eax,0xe820
    mov edx,0x534d4150
    mov ecx,20
    int 0x15
    jc get_mem_done

    test ebx,ebx
    jnz get_mem_info

get_mem_done:

test_a20_line:
    mov ax,0xffff
    mov es,ax
    mov word[ds:0x7c00],0xa200
    cmp word[es:0x7c10],0xa200
    jne set_a20_line_done
    cmp word[0x7c00],0xb2000
    je end

set_a20_line_done:
    xor ax,ax
    mov es,ax

set_video_mode:
    mov ax,3
    int 0x10

    mov si,message
    mov ax,0xb800
    mov es,ax
    xor di,di
    mov cx,message_length
    ; mov di,0xb8000

print:
    mov al,[si]
    mov [es:di],al
    mov byte[es:di+1],0xa

    add di,2
    add si,1
    loop print

    ; mov ah,0x13
    ; mov al,0x1
    ; mov bx,0xa 
    ; xor dx,dx 
    ; mov bp,message 
    ; mov cx,message_length 
    ; int 0x10

read_error:
not_support:
end:
    hlt
    jmp end

drive_id:       db 0
message:        db "Text mode loaded"
message_length: equ $-message
read_packet: times 16 db 0
