#include <stdio.h>
#include "bit_ops.h"

// Return the nth bit of x.
// Assume 0 <= n <= 31
unsigned get_bit(unsigned x,
                 unsigned n)
{
    unsigned mask = 0b1 << n;
    return (x & mask) >> n;
}
// Set the nth bit of the value of x to v.
// Assume 0 <= n <= 31, and v is 0 or 1
void set_bit(unsigned *x,
             unsigned n,
             unsigned v)
{
    unsigned mask = 0b1 << n;
    *x = (*x & ~mask) | (v << n);
}
// Flip the nth bit of the value of x.
// Assume 0 <= n <= 31
void flip_bit(unsigned *x,
              unsigned n)
{
    unsigned mask = 0b1 << n;
    *x ^= mask;
}
