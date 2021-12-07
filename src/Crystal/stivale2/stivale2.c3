module stivale2;

//
// Used to communicate with the bootloader
//

// Request 8KiB of stack
char[8192] stack @align(16);

Stivale2_header stivale2_hdr @section(".stivale2hdr") = {
    .entry_point = 0,
    .stack = (uptr)(&stack[0] + $sizeof(stack)),
    .flags = 0b11110,
    .tags = (uptr)(0)
};

//
// Bootloader specific structures
//

// Anchor for non ELF kernels
struct Stivale2_anchor @packed {
    char[15] anchor;
    char bits;
    ulong phys_load_addr;
    ulong phys_bss_start;
    ulong phys_bss_end;
    ulong phys_stivale2hdr;
}

struct Stivale2_tag @packed {
    ulong identifier;
    ulong next;
}

/* --- Header --------------------------------------------------------------- */
/*  Information passed from the kernel to the bootloader                      */

struct Stivale2_header @packed {
    ulong entry_point;
    ulong stack;
    ulong flags;
    ulong tags;
}

const ulong STIVALE2_HEADER_TAG_FRAMEBUFFER_ID = 0x3ecc1bc43d0f7971;

struct Stivale2_header_tag_framebuffer @packed {
    Stivale2_tag tag;
    ushort framebuffer_width;
    ushort framebuffer_height;
    ushort framebuffer_bpp;
}

const ulong STIVALE2_HEADER_TAG_TERMINAL_ID = 0xa85d499b1823be72;

struct Stivale2_header_tag_terminal @packed {
    Stivale2_tag tag;
    ulong flags;
    ulong callback;
}

const char STIVALE2_TERM_CB_DEC = 10;
const char STIVALE2_TERM_CB_BELL = 20;

const ulong STIVALE2_HEADER_TAG_SMP_ID = 0x1ab015085f3273df;

struct Stivale2_header_tag_smp @packed {
    Stivale2_tag tag;
    ulong flags;
}

const ulong STIVALE2_HEADER_TAG_5LV_PAGING_ID = 0x932f477032007e8f;
const ulong STIVALE2_HEADER_TAG_UNMAP_NULL_ID = 0x92919432b16fe7e7;

/* --- Struct --------------------------------------------------------------- */
/*  Information passed from the bootloader to the kernel                      */

const ichar STIVALE2_BOOTLOADER_BRAND_SIZE = 64;
const ichar STIVALE2_BOOTLOADER_VERSION_SIZE = 64;
struct Stivale2_struct @packed {
    char[STIVALE2_BOOTLOADER_BRAND_SIZE] bootloader_brand;
    char[STIVALE2_BOOTLOADER_VERSION_SIZE] bootloader_version;
    ulong tags;
}

const ulong STIVALE2_STRUCT_TAG_PMRS_ID = 0x5df266a64047b6bd;

const ulong STIVALE2_PMR_EXECUTABLE = ((ulong)(1 << 0));
const ulong STIVALE2_PMR_WRITABLE   = ((ulong)(1 << 1));
const ulong STIVALE2_PMR_READABLE   = ((ulong)(1 << 2));

struct Stivale2_pmr @packed {
    ulong base;
    ulong length;
    ulong permissions;
}

struct Stivale2_struct_tag_pmrs @packed {
    Stivale2_tag tag;
    ulong entries;
    Stivale2_pmr[] pmrs;
}

const ulong STIVALE2_STRUCT_TAG_CMDLINE_ID = 0xe5e76a1b4597a781;

struct Stivale2_struct_tag_cmdline @packed {
    Stivale2_tag tag;
    ulong cmdline;
}

const ulong STIVALE2_STRUCT_TAG_MEMMAP_ID = 0x2187f79e8612de07;

const ushort STIVALE2_MMAP_USABLE                 = 1;
const ushort STIVALE2_MMAP_RESERVED               = 2;
const ushort STIVALE2_MMAP_ACPI_RECLAIMABLE       = 3;
const ushort STIVALE2_MMAP_ACPI_NVS               = 4;
const ushort STIVALE2_MMAP_BAD_MEMORY             = 5;
const ushort STIVALE2_MMAP_BOOTLOADER_RECLAIMABLE = 0x1000;
const ushort STIVALE2_MMAP_KERNEL_AND_MODULES     = 0x1001;
const ushort STIVALE2_MMAP_FRAMEBUFFER            = 0x1002;

struct Stivale2_mmap_entry @packed {
    ulong base;
    ulong length;
    uint type;
    uint unused;
}

struct Stivale2_struct_tag_memmap @packed {
    Stivale2_tag tag;
    ulong entries;
    Stivale2_mmap_entry[] memmap;
}

const ulong STIVALE2_STRUCT_TAG_FRAMEBUFFER_ID = 0x506461d2950408fa;

const ichar STIVALE2_FBUF_MMODEL_RGB = 1;

struct Stivale2_struct_tag_framebuffer @packed {
    Stivale2_tag tag;
    ulong framebuffer_addr;
    ushort framebuffer_width;
    ushort framebuffer_height;
    ushort framebuffer_pitch;
    ushort framebuffer_bpp;
    char  memory_model;
    char  red_mask_size;
    char  red_mask_shift;
    char  green_mask_size;
    char  green_mask_shift;
    char  blue_mask_size;
    char  blue_mask_shift;
}

const ulong STIVALE2_STRUCT_TAG_EDID_ID = 0x968609d7af96b845;

struct Stivale2_struct_tag_edid @packed {
    Stivale2_tag tag;
    ulong edid_size;
    char[] edid_information;
}

const ulong STIVALE2_STRUCT_TAG_TEXTMODE_ID = 0x38d74c23e0dca893;

struct Stivale2_struct_tag_textmode @packed {
    Stivale2_tag tag;
    ulong address;
    ushort unused;
    ushort rows;
    ushort cols;
    ushort bytes_per_char;
}

const ulong STIVALE2_STRUCT_TAG_FB_MTRR_ID = 0x6bc1a78ebe871172;
const ulong STIVALE2_STRUCT_TAG_TERMINAL_ID = 0xc2b3f4c3233b0974;

struct Stivale2_struct_tag_terminal @packed {
    Stivale2_tag tag;
    uint flags;
    ushort cols;
    ushort rows;
    ulong term_write;
    ulong max_length;
}

const ulong STIVALE2_STRUCT_TAG_MODULES_ID = 0x4b6fe466aade04ce;
const char STIVALE2_MODULE_STRING_SIZE = 128;

struct Stivale2_module @packed {
    ulong begin;
    ulong end;

    char[STIVALE2_MODULE_STRING_SIZE] string;
}

struct Stivale2_struct_tag_modules @packed {
    Stivale2_tag tag;
    ulong module_count;
    Stivale2_module[] modules;
}

const ulong STIVALE2_STRUCT_TAG_RSDP_ID = 0x9e1786930a375e78;

struct Stivale2_struct_tag_rsdp @packed {
    Stivale2_tag tag;
    ulong rsdp;
}

const ulong STIVALE2_STRUCT_TAG_EPOCH_ID = 0x566a7bed888e1407;

struct Stivale2_struct_tag_epoch @packed {
    Stivale2_tag tag;
    ulong epoch;
}

const ulong STIVALE2_STRUCT_TAG_FIRMWARE_ID = 0x359d837855e3858c;

const ulong STIVALE2_FIRMWARE_BIOS = 1 << 0;

struct Stivale2_struct_tag_firmware @packed {
    Stivale2_tag tag;
    ulong flags;
}

const ulong STIVALE2_STRUCT_TAG_EFI_SYSTEM_TABLE_ID = 0x4bc5ec15845b558e;

struct Stivale2_struct_tag_efi_system_table @packed {
    Stivale2_tag tag;
    ulong system_table;
}

const ulong STIVALE2_STRUCT_TAG_KERNEL_FILE_ID = 0xe599d90c2975584a;

struct Stivale2_struct_tag_kernel_file @packed {
    Stivale2_tag tag;
    ulong kernel_file;
}

const ulong STIVALE2_STRUCT_TAG_KERNEL_SLIDE_ID = 0xee80847d01506c57;

struct Stivale2_struct_tag_kernel_slide @packed {
    Stivale2_tag tag;
    ulong kernel_slide;
}

const ulong STIVALE2_STRUCT_TAG_SMBIOS_ID = 0x274bd246c62bf7d1;

struct Stivale2_struct_tag_smbios @packed {
    Stivale2_tag tag;
    ulong flags;
    ulong smbios_entry_32;
    ulong smbios_entry_64;
}

const ulong STIVALE2_STRUCT_TAG_SMP_ID = 0x34d1d96339647025;

struct Stivale2_smp_info @packed {
    uint processor_id;
    uint lapic_id;
    ulong target_stack;
    ulong goto_address;
    ulong extra_argument;
}

struct Stivale2_struct_tag_smp @packed {
    Stivale2_tag tag;
    ulong flags;
    uint bsp_lapic_id;
    uint unused;
    ulong cpu_count;
    Stivale2_smp_info[] smp_info;
}

const ulong STIVALE2_STRUCT_TAG_PXE_SERVER_INFO = 0x29d1e96239247032;

struct Stivale2_struct_tag_pxe_server_info @packed {
    Stivale2_tag tag;
    uint server_ip;
}

const ulong STIVALE2_STRUCT_TAG_MMIO32_UART = 0xb813f9b8dbc78797;

struct Stivale2_struct_tag_mmio32_uart @packed {
    Stivale2_tag tag;
    ulong addr;
}

const ulong STIVALE2_STRUCT_TAG_DTB = 0xabb29bd49a2833fa;

struct Stivale2_struct_tag_dtb @packed {
    Stivale2_tag tag;
    ulong addr;
    ulong size;
}

const ulong STIVALE2_STRUCT_TAG_VMAP = 0xb0ed257db18cb58f;

struct Stivale2_struct_vmap @packed {
    Stivale2_tag tag;
    ulong addr;
}