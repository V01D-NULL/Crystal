module console;

import stivale2;
import bitmap_font;
import string;
import debug;

uint *framebuff = null;
uint *backbuffer = null;
ushort width = 0;
ushort height = 0;
ushort pitch = 0;
ushort bpp = 0;
ushort console_x = 0;
ushort console_y = 0;

fn void init(Stivale2_struct_tag_framebuffer *fb)
{
    //backbuffer = (ulong*)/*allocate from mmap*/;
    framebuff = (uint*)(fb.framebuffer_addr);
    width = fb.framebuffer_width;
    height = fb.framebuffer_height;
    pitch = fb.framebuffer_pitch;
    bpp = fb.framebuffer_bpp;

    clear(0);
    print("Reached target framebuffer\n");
}

fn void plot_pixel(uint hex, int x, int y)
{
    uint offset = (x + y * width);
    framebuff[offset] = hex;
    // backbuffer[offset] = hex;
}

fn void clear(uint color)
{
    for (int y = 0; y < height; y++)
    {
        for (int x = 0; x < width; x++)
        {
            plot_pixel(color, x, y);
        }
    }
    console_x = console_y = 0;
}

fn void putc(char c, uint x, uint y)
{
    if (c == '\n')
    {
        console_y++;
        console_x = 0;
        return;
    }
    for (uint _y = 0; _y < font_height; _y++)
    {
        for (int _x = 0; _x < font_width; _x++)
        {
            bool draw_fg = font[(c * font_height) + _y] & (1 << _x);
            int ypos = (y * font_height) + _y;
            int xpos = (x * font_width) + font_width - _x;

            plot_pixel(draw_fg ? 0xffffff : 0, xpos, ypos);
        }
    }
    console_x++;
}

fn void puts(char *s)
{
    isize len = string::strlen(s);
    for (isize i = 0; i < len; i++)
    {
        putc(s[i], console_x, console_y);
    }
}

fn void print(char* fmt, variant ...vars)
{
    // Is this just a plain string?
    if (vars.len == 0)
    {
        puts(fmt);
        return;
    }

    // Nope, it's a formatted string.
    isize len = string::strlen(fmt);
    isize counter = 0;
    for (isize i = 0;  i < len; i++)
    {
        switch (fmt[i])
        {
            case '{':
                switch (fmt[i+1])
                {
                    // hex (assuming numerical value)
                    case 'x':
                        switch (vars[counter].typeid)
                        {
                            /* itoa() accepts usize's */
                            case ulong: nextcase;
                            case long: nextcase;
                            case uint: nextcase;
                            case int: nextcase;
                            case ushort: nextcase;
                            case short:
                                char *tmp;
                                puts(string::itoa(*(int*)(vars[counter++].ptr), tmp, 16));
                                i+=2;
                        }

                    // auto detect type
                    case '}':
                        switch (vars[counter].typeid)
                        {
                            case ulong: nextcase;
                            case long: nextcase;
                            case uint: nextcase;
                            case int: nextcase;
                            case ushort: nextcase;
                            case short:
                                char *tmp;
                                puts(string::itoa(*(int*)(vars[counter++].ptr), tmp));
                                i++;

                            case char: nextcase;
                            case ichar:
                                putc(*(char*)(vars[counter++].ptr), console_x, console_y);
                                i++;

                            case char*:
                                puts(*(char**)(vars[counter++].ptr));
                                i++;
                        }
                }
            default:
                putc(fmt[i], console_x, console_y);
        }
    }
}
