module fatal;

import debug;
import console;

fn void panic(char *err) @noreturn
{
    // console::clear(0x0059B3);
    console::print("Kernel panic!\nReason: ");
    console::print(err);
    for (;;) {
        asm("hlt");
    }
}

fn void early_panic(char *err) @noreturn
{
    debug::log("Kernel panic!\nReason: ");
    debug::log(err);
    for (;;) {
        asm("hlt");
    }
}