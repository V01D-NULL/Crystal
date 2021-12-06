; section .text
; extern kmain

; global _start
; _start:
; 	call kmain
;     jmp $

; section .bss
; _stack:
; 	resb 8192
; stack:

; section .data
; fb_hdr_tag:
; 	dq 0x3ecc1bc43d0f7971	; Tag.Identifier
; 	dq 0					; Tag.next
; 	dw 0					; Width
; 	dw 0					; Height
; 	dw 32					; Bpp

; section .stivale2hdr
; 	dq 0            	; Entry ppoint
;     dq stack			; Stack
;     dq 0b11110      	; Flags
;     dq fb_hdr_tag		; Tags
