#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "lfsr.h"

void lfsr_calculate(uint16_t *reg) {
    *reg = (*reg >> 1) | ((*reg & 0b1) ^ ((*reg & 0b100) >> 2) ^ ((*reg & 0b1000) >> 3) ^ ((*reg & 0b100000) >> 5)) << 15;
}
