module gdt;

import string;
import console;
import assembly;
import util;

const char GDT_ENTRY_SIZE = 8;

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

enum SegmentSel : ushort {
    NULL,
    KCS16, /* 16 bit kernel cs */
    KDS16, /* 16 bit kernel ds */
    KCS32, /* 32 bit kernel cs */
    KDS32, /* 32 bit kernel ds */
    KCS,   /* 64 bit kernel cs */
    KDS,   /* 64 bit kernel ds */
    UCS,   /* 64 bit user   cs */
    UDS    /* 64 bit user   ds */
}

Gdtr gdtr;
GdtDescriptor[9] descriptors; // 8 gdt entries + 1 tss

fn void init()
{
    // Null descriptor
    set64({0,0}, SegmentSel.NULL);

    // 16 bit descriptors
    set32({0x9A, 0x80}, SegmentSel.KCS16);
    set32({0x9A, 0x80}, SegmentSel.KDS16);

    // 32 bit descriptors
    set32({0x9A, 0xCF}, SegmentSel.KCS32);
    set32({0x92, 0xCF}, SegmentSel.KDS32);

    // 64 bit descriptors
    set64({0x9A, 0x20}, SegmentSel.KCS);
    set64({0x92, 0x20}, SegmentSel.KDS);

    // 64 bit user descriptors
    set64({0xFA, 0x20}, SegmentSel.UCS);
    set64({0xF2, 0x00}, SegmentSel.UDS);

    gdtr.size = ($sizeof(GdtDescriptor) * 9) - 1;
    gdtr.offset = (ulong)((uptr)(&descriptors));
    assembly::load_gdt((uptr*)(&gdtr));

    console::reached_target("GDT");
}

// Convert an offset in the gdt array into a segment selector
fn isize offset2selector(SegmentSel sel)
{
    return sel * GDT_ENTRY_SIZE;
}

fn void set64(TypesAndAttr types_attr, ushort index) @inline
{
    descriptors[index].limit = 0;
    descriptors[index].base0 = 0;
    descriptors[index].base1 = 0;
    descriptors[index].types = types_attr;
    descriptors[index].base2 = 0;
}

fn void set32(TypesAndAttr types_attr, ushort index) @inline
{
    descriptors[index].limit = 0xffff;
    descriptors[index].base0 = 0;
    descriptors[index].base1 = 0;
    descriptors[index].types = types_attr;
    descriptors[index].base2 = 0;
}