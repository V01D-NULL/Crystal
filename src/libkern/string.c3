module string;
import debug;

define memcpy = memcpy8;

errtype StringErr
{
    DIGIT_OUT_OF_RANGE
}

fn isize strlen(char *str)
{
    isize counter = 0;
    while (*str++ != '\0') counter++;
    return counter;
}

fn char* strrev(char *src)
{
    char temp;
	int src_string_index = 0;
	isize last_char = strlen(src)-1;

	for (; src_string_index < last_char; src_string_index++)
	{
		temp = src[src_string_index]; 			  // Save current character
		src[src_string_index] = src[last_char];   // Swap out the current char with the last char
		src[last_char] = temp;	 				  // Swap out last character with the current character
		last_char--;
	}

    return src;
}

fn int digit_count(int num, int base=10)
{
    int count = 0;
    while (num != 0)
    {
        num /= base;
        count++;
    }
    return count;
}

fn bool is_digit(char digit)
{
    return (digit >= '0' && digit <= '9');
}

const char[16] CONVERSION_TABLE_LOWER = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'};
const char[16] CONVERSION_TABLE_UPPER = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'};

fn char itoc(isize digit, bool upper=false)
{
    return upper ? CONVERSION_TABLE_UPPER[digit] : CONVERSION_TABLE_LOWER[digit];
}

fn char* itoa(isize num, char* str, int base=10) {
    isize buffer_sz = 20;
    isize counter = 0;
    isize digit = 0;

    while (num != 0 && counter < buffer_sz) {
        digit = (num % base);
        if (digit > 9) {
            str[counter++] = itoc(digit, 16);
        } else {
            str[counter++] = itoc(digit);
        }
        num /= base;
    }

    str[counter] = '\0';
    return (str = strrev(str));
}

fn void memset(char *src, char val, uint n) @extname("memset")
{
    for (uint i = 0; i < n; i++) {
        *src = val;
        *src += 1;
    }
}

fn void memcpy64(ulong *src, ulong *dst, uint n)
{
    for (uint i = 0; i < n; i++) {
        *src++ = *dst++;
    }
}

fn void memcpy32(uint *src, uint *dst, uint n)
{
    for (uint i = 0; i < n; i++) {
        *src++ = *dst++;
    }
}

fn void memcpy8(char *src, char *dst, uint n)
{
    for (uint i = 0; i < n; i++) {
        *src++ = *dst++;
    }
}