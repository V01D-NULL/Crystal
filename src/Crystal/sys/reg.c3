module registers;

struct InterruptStackFrame @packed {
    ulong r15;
    ulong r14;
    ulong r13;
    ulong r12;
    ulong r11;
    ulong r10;
    ulong r9;
    ulong r8;
    ulong rsi;
    ulong rdi;
    ulong rbp;
    ulong rdx;
    ulong rcx;
    ulong rbx;
    ulong rax;
    ulong isr_no;
    ulong error_code;
    ulong rflags;
    ulong cs;
    ulong rip;
    
    /* On privilege level change */
    ulong rsp;
    ulong ss;
}