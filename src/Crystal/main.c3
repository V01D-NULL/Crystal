import stivale2;
import assembly;
import debug;

define log = debug::log;

fn void _start(Stivale2_struct *handover) @extname("_start")
{
    log("\nBootloader brand: ");
    log(&handover.bootloader_brand);
    log("\nBootloader version: ");
    log(&handover.bootloader_version);
    log("\n");

    for (;;) {
        asm("hlt");
    }
}