#include "stivale2.h"
#include <stdint.h>

// 8kb of stack space, it's stored as an unintialized array in .bss
static uint8_t stack[8192];

struct stivale2_header stivale2hdr __attribute__((section(".stivale2hdr"))) = {
    .entry_point = 0,
    .stack = (uintptr_t)stack + sizeof(stack),
    .flags = (1 << 1) | (1 << 2) | (1 << 3) | (1 << 4),
    .tags = 0 // No flags for the bootloader, it's just a PoC.
};

void _start(struct stivale2_struct *handover)
{
    for (;;) {
        __asm__("hlt");
    }
}