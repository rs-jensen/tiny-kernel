#include "tty.h"

static const size_t VGA_WIDTH = 80;
static const size_t VGA_HEIGHT = 25;

static size_t row;
static size_t column;
static uint8_t color;
static uint16_t* const buffer = (uint16_t*)0xB8000;

static uint16_t vga_entry(char c, uint8_t color) {
    return (uint16_t)c | (uint16_t)color << 8;
}

void terminal_initialize(void) {
    row = 0;
    column = 0;
    color = vga_entry_color(VGA_COLOR_LIGHT_GREY, VGA_COLOR_BLACK);
    for (size_t y = 0; y < VGA_HEIGHT; y++) {
        for (size_t x = 0; x < VGA_WIDTH; x++) {
            buffer[y * VGA_WIDTH + x] = vga_entry(' ', color);
        }
    }
}

void terminal_putentryat(char c, uint8_t col, size_t x, size_t y) {
    buffer[y * VGA_WIDTH + x] = vga_entry(c, col);
}

void terminal_putchar(char c) {
    if (c == '\n') {
        column = 0;
        if (++row == VGA_HEIGHT) row = 0;
        return;
    }
    terminal_putentryat(c, color, column, row);
    if (++column == VGA_WIDTH) {
        column = 0;
        if (++row == VGA_HEIGHT) row = 0;
    }
}

void terminal_writestring(const char* data) {
    for (size_t i = 0; data[i] != '\0'; i++)
        terminal_putchar(data[i]);
}
