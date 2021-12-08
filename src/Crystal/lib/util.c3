module util;

/* Note: This does not work on strings */
macro vararg($value)
{
    // Macro to avoid writing & or && for varargs using variants.
    // Usage example:
    // console::print(_fmt_, @vararg(2)) -> console::print(_fmt_, &&(int)(x));
    return &&($typeof($value))($value);
}
