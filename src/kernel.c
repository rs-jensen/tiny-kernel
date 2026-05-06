#include "tty.h"

void kernel_main(void) {
    terminal_initialize();
    terminal_writestring("boot ok\n");
    terminal_writestring("tiny kernel in C + ASM\n");
}
