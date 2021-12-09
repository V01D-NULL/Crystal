bits 64
section .text

%macro flush_data_segments 0
    mov ax, di
    mov ds, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov es, ax
%endmacro

global refresh_kernel_segments
refresh_kernel_segments:
    push 8 ; CS
    lea rax, [rel .new_cs]
    push rax
    retfq
    .new_cs:
        flush_data_segments
    ret

global refresh_user_segments
refresh_user_segments:
    push 0x18 ; CS
    lea rax, [rel .new_cs]
    push rax
    retfq
    .new_cs:
        flush_data_segments
    ret
