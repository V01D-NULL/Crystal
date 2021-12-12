import stivale2;
import assembly;
import debug;
import fatal;
import string;
import console;
import util;
import gdt;
import idt;

define log = debug::log;

fn void _start(Stivale2_struct *handover) @extname("_start")
{
    stivale2::Stivale2_struct_tag_terminal *tag_term = stivale2::get_tag(handover, stivale2::STIVALE2_STRUCT_TAG_TERMINAL_ID);
    stivale2::Stivale2_struct_tag_memmap *tag_mem =stivale2::get_tag(handover, stivale2::STIVALE2_STRUCT_TAG_MEMMAP_ID);
    console::init(tag_term);

    gdt::init();
    idt::init();

    fatal::panic("Test\n");

    for (;;) {
        asm("hlt");
    }
}