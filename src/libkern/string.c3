module string;

fn isize strlen(char *str)
{
    isize counter = 0;
    while (*str++ != '\0') counter++;
    return counter;
}