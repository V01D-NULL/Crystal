module idt;
import bitwise;

struct Idtr @packed {
    ushort size;
    ulong  offset;
}

struct IdtDescriptor @packed {
    ushort offset0;
    ushort selector;
    char   ist;
    char   types_attr;
    ushort offset1;
    uint   offset2;
    uint   reserved;
}

extern fn void setup_idt();
extern IdtDescriptor[256] idt_handlers;
extern fn void isr0();

fn void init()
{
    // idt_handlers[0] = set64((ulong)(&isr0), 8, 0, 0x8E);
    setup_idt();
    asm("sti");
    asm("int 0");
}

fn void set64(ulong offset, ushort selector, char ist, char types_attr, int vector) @extname("set64")
{
    idt_handlers[vector] = {
        .offset0 = @low16(offset),
        .selector = selector,
        .ist = ist,
        .types_attr = types_attr,
        .offset1 = @high16(offset),
        .offset2 = @high32(offset),
        .reserved = 0
    };
}