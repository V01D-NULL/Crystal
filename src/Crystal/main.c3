import stivale2;
import assembly;
import debug;
import print;
import fatal;
import string;
import console;
import util;

define log = debug::log;

fn void _start(Stivale2_struct *handover) @extname("_start")
{
    stivale2::Stivale2_struct_tag_framebuffer *tag_fb = stivale2::get_tag(handover, stivale2::STIVALE2_STRUCT_TAG_FRAMEBUFFER_ID);
    console::init(tag_fb);

    console::print("String: Hello, {}\n", &&(char*)("world!"));
    console::print("Dec number: {}\n", @vararg(12345));
    console::print("Hex number: 0x{x}\n", @vararg(0x12345));

    for (;;) {
        asm("hlt");
    }
}