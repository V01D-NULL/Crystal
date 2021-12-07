import stivale2;
import assembly;
import debug;
import print;

define log = debug::log;

fn void _start(Stivale2_struct *handover) @extname("_start")
{
    log("\nBootloader brand: ");
    log(&handover.bootloader_brand);
    log("\nBootloader version: ");
    log(&handover.bootloader_version);
    log("\n");

    stivale2::Stivale2_struct_tag_terminal *tag_term = stivale2::get_tag(handover, stivale2::STIVALE2_STRUCT_TAG_TERMINAL_ID);
    print::print_init(tag_term);
    print::print("Hello terminal!\n");

    for (;;) {
        asm("hlt");
    }
}