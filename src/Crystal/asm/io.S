bits 64
section .text

global outb
outb:
	mov dx, di  ; port
	mov al, sil ; data
	out dx, al
	ret
