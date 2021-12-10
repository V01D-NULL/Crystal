module bitwise;

// Return the lower 16 bits of a 32 bit value
macro low16(offset)
{
    return (ushort)(offset & 0xFFFF);
}

// Return the higher 16 bits of a 32 bit value
macro high16(offset)
{
    return (ushort)((offset >> 16) & 0xFFFF);
}

// Return the lower 32 bits of a 64 bit value
macro low32(offset)
{
    return (uint)(offset & 0xFFFFFFFF);
}

// Return the higher 32 bits of a 64 bit value
macro high32(offset)
{
    return (uint)((offset >> 32) & 0xFFFFFFFF);
}