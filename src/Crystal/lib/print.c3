module print;
import stivale2;
import string;

define Term_callback = fn void(char *string, isize len);
Term_callback term_write = null;

errtype TermErr
{
    TERM_WRITE_CALLBACK_IS_NULL,
    TERM_TAG_IS_NULL
}

fn void! print_init(stivale2::Stivale2_struct_tag_terminal *term)
{
    if (term == null) return TermErr.TERM_TAG_IS_NULL!;
    term_write = (Term_callback)(term.term_write);
    if (term_write == null) return TermErr.TERM_WRITE_CALLBACK_IS_NULL!;
}

fn void print(char *str)
{
    term_write(str, string::strlen(str));
}