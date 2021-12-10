module registers;

struct InterruptStackFrame @packed {
    ulong  rflags;
    ushort cs;
    ulong  rip;
    ulong  error_code;
}