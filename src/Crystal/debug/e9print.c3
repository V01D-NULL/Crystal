module debug;

import assembly;
import string;

fn void log(char* msg)
{
    isize len = string::strlen(msg);
    for (isize i = 0; i < len; i++) {
        assembly::outb(0xe9, msg[i]);
    }
}