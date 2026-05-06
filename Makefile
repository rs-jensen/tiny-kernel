CC := gcc
LD := ld
AS := nasm

CFLAGS := -m32 -ffreestanding -O2 -Wall -Wextra -fno-pic -fno-stack-protector -fno-builtin -nostdlib -Iinclude
ASFLAGS := -f elf32
LDFLAGS := -m elf_i386 -T linker.ld

BUILD := build
DIST := dist
ISO := $(DIST)/os.iso

OBJS := $(BUILD)/boot.o $(BUILD)/kernel.o $(BUILD)/tty.o

all: $(ISO)

$(BUILD):
	mkdir -p $(BUILD)

$(DIST):
	mkdir -p $(DIST)

$(BUILD)/boot.o: src/boot.asm | $(BUILD)
	$(AS) $(ASFLAGS) $< -o $@

$(BUILD)/kernel.o: src/kernel.c include/tty.h | $(BUILD)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD)/tty.o: src/tty.c include/tty.h | $(BUILD)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD)/kernel.elf: $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $(OBJS)

$(DIST)/iso/boot/grub/grub.cfg: | $(DIST)
	mkdir -p $(DIST)/iso/boot/grub
	cp grub.cfg $(DIST)/iso/boot/grub/grub.cfg

$(DIST)/iso/boot/kernel.elf: $(BUILD)/kernel.elf | $(DIST)
	mkdir -p $(DIST)/iso/boot
	cp $(BUILD)/kernel.elf $(DIST)/iso/boot/kernel.elf

$(ISO): $(DIST)/iso/boot/kernel.elf $(DIST)/iso/boot/grub/grub.cfg
	grub-mkrescue -o $(ISO) $(DIST)/iso >/dev/null 2>&1

run: $(ISO)
	qemu-system-i386 -cdrom $(ISO)

clean:
	rm -rf $(BUILD) $(DIST)

.PHONY: all run clean
