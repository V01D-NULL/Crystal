module print;
import stivale2;
import string;

define Term_callback = fn void(char *string, isize len);
Term_callback term_write = null;

fn void print_init(stivale2::Stivale2_struct_tag_terminal *term)
{
    term_write = (Term_callback)(term.term_write);
}

fn void print(char *str)
{
    term_write(str, string::strlen(str));
}