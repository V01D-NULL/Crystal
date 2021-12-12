module idt;
import bitwise;
import console;
import assembly;

struct IdtDescriptor @packed {
    ushort offset0;
    ushort selector;
    char   ist;
    char   types_attr;
    ushort offset1;
    uint   offset2;
    uint   reserved;
}

extern IdtDescriptor[256] idt_handlers;

fn void init()
{
    assembly::setup_idt();
    console::reached_target("IDT");
}

/* Called from assembly for the sake of simplicity, readability and maintainability */
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