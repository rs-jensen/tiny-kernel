# Tiny C + ASM Kernel (Multiboot)

Small 32-bit kernel built with NASM + GCC and booted by GRUB.

## Build
Requirements:
- gcc (with multilib)
- nasm
- grub-mkrescue
- qemu-system-i386

```bash
make
make run
```

## Output
- build/kernel.elf
- dist/os.iso
