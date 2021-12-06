import stivale2;
// import assembly;
// import debug;

char[8192] stack @align(16);

Stivale2_header stivale2_hdr @section(".stivale2hdr") = {
    .entry_point = 0,
    .stack = (uptr)(&stack + $sizeof(stack)),
    .flags = 0b11110,
    .tags = (uptr)(0)
};

fn void _start(Stivale2_struct *handover) @extname("_start")
{
    // debug::log(&handover.bootloader_brand);
    for (;;) {
        asm("hlt");
    }
}