module pmm;

import stivale2;

uint *arena;

fn void* early_alloc(Stivale2_mmap_entry entry, isize size)
{
    isize ret = entry.base;
    entry.base += size;
    entry.length -= size;
    return (void *)(ret);
}

fn void init(Stivale2_struct_tag_memmap *mmap)
{

}

fn void alloc_page()
{

}

fn void free_page()
{

}