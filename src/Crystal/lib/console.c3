module console;
import stivale2;
import string;

define Term_callback = fn void(char *string, isize len);
Term_callback term_write = null;
int gcounter = 0;
errtype TermErr
{
    TERM_WRITE_CALLBACK_IS_NULL,
    TERM_TAG_IS_NULL
}

fn void! init(stivale2::Stivale2_struct_tag_terminal *term)
{
    if (term == null) return TermErr.TERM_TAG_IS_NULL!;
    term_write = (Term_callback)(term.term_write);
    if (term_write == null) return TermErr.TERM_WRITE_CALLBACK_IS_NULL!;
    reached_target("Terminal");
}

fn void puts(char *s)
{
    term_write(s, string::strlen(s));
}

fn void print(char* fmt, variant ...vars)
{
    // Is this just a plain string?
    if (vars.len == 0)
    {
        term_write(fmt, string::strlen(fmt));
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

                            case char*:
                                char *str = *(char**)(vars[counter++].ptr);
                                term_write(str, string::strlen(str));
                                i++;
                        }
                }
            default:
                term_write(fmt + i, 1);
        }
    }
}

fn void reached_target(char *target)
{
    print("Reached target: \e[97m{}\e[37m\n", &&(char*)(target));
}