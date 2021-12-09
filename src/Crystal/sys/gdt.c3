module gdt;

import string;
import console;

struct Gdtr @packed {
    ushort size;
    ulong  offset;
}

struct TypesAndAttr @packed {
    char   access;
    char   flags;
}

struct GdtDescriptor @packed {
    ushort limit;
    ushort base0;
    char   base1;
    TypesAndAttr types;
    char   base2;
}

extern fn void load_gdt(ulong *gdtr);

Gdtr gdtr;
// GdtDescriptor[6] descriptors; // Bug :(

fn void init()
{
    // 5 gdt entries + 1 tss
    GdtDescriptor[6] descriptors;

    // Null descriptor
    descriptors[0].limit = 0;
    descriptors[0].base0 = 0;
    descriptors[0].base1 = 0;
    descriptors[0].types = {0,0};
    descriptors[0].base2 = 0;

    // Kernel cs
    descriptors[1].limit = 0;
    descriptors[1].base0 = 0;
    descriptors[1].base1 = 0;
    descriptors[1].types = {0x9A, 0x20};
    descriptors[1].base2 = 0;

    // kernel ds
    descriptors[2].limit = 0;
    descriptors[2].base0 = 0;
    descriptors[2].base1 = 0;
    descriptors[2].types = {0x92, 0x20};
    descriptors[2].base2 = 0;

    // user cs
    descriptors[3].limit = 0;
    descriptors[3].base0 = 0;
    descriptors[3].base1 = 0;
    descriptors[3].types = {0xFA, 0x20};
    descriptors[3].base2 = 0;

    // user ds
    descriptors[4].limit = 0;
    descriptors[4].base0 = 0;
    descriptors[4].base1 = 0;
    descriptors[4].types = {0xF2, 0x00};
    descriptors[4].base2 = 0;

    gdtr.size = ($sizeof(GdtDescriptor) * 5) - 1;
    gdtr.offset = (ulong)((uptr)(&descriptors));
    load_gdt((uptr*)(&gdtr));
    console::print("Reached target GDT\n");
}

// Compiler bug :^(
// fn void set64(TypesAndAttr types_attr, ichar index) @inline
// {
//     descriptors[index].limit = 0;
//     descriptors[index].base0 = 0;
//     descriptors[index].base1 = 0;
//     descriptors[index].types = types_attr;
//     descriptors[index].base2 = 0;
// }