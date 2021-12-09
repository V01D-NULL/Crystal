import stivale2;
import assembly;
import debug;
import print;
import fatal;
import string;
import console;
import util;
import gdt;

define log = debug::log;

fn void _start(Stivale2_struct *handover) @extname("_start")
{
    stivale2::Stivale2_struct_tag_framebuffer *tag_fb = stivale2::get_tag(handover, stivale2::STIVALE2_STRUCT_TAG_FRAMEBUFFER_ID);
    console::init(tag_fb);

    gdt::init();

    for (;;) {
        asm("hlt");
    }
}