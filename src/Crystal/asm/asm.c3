module assembly;

/* Generic */
extern fn void outb(ushort port, char data);

/* sys */
extern fn void load_gdt(ulong *gdtr);
extern fn void setup_idt();
extern fn void refresh_kernel_segments(ushort ds);
extern fn void refresh_user_segments  (ushort ds);