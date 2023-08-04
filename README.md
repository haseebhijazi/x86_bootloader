## X86-BOOTLOADER
A bootloader written in `NASM` which showcases low-level system designing to bootload a retro boot sector game written in... you guessed it, `NASM`.

## How BIOS works?
When we turn an `x86` device on, the processor immediately starts executing instructions from a fixed memory location called the  `reset vector` located at physical address `0xFFFFFFF0`. The CPU fetches the first instructions from the `reset vector` (`0xFFFFFFF0`), which contain the jump instruction (`JMP`) to the BIOS code. <br> 
BIOS is stored somewhere on ROM. It initializes and tests the hardware components (known as `POST` or `Power-On Self-Test`). After ensuring that the system is functioning correctly, BIOS searches for acceptable boot media from which to load the OS. BIOS checks if the first sector of the bootable device, known as `boot sector`, is `512` bytes in size and ends with a `2`-byte signature of `0x55AA`. If yes, then it is a bootable. <br>
BIOS loads the first `512` bytes of the MBR into memory at address `0x007C00` (segment:offset) and transfers program control to this address using a `JMP` instruction. This program loaded is typically the `bootloader`. <br>


## Requirements
- NASM (NetWide Assembler) : as Assembler and Deassembler (x86 architecture)
    - Fedora : ```sudo dnf install nasm```
    - Arch   : ```sudo pacman -S nasm```
- Bochs : as Emulator
    - Fedora : ```sudo dnf install bochs```
    - Arch   : ```sudo pacman -S bochs```

## NASM assembling
```bash
nasm -f bin bootloader.asm -o bootloader.com
```

## Emulate
```bash
bochs -f bochsrc.txt
```

## Features to be added
 [ ] stackoverflow
 [ ] boot snake retro games


## References
- [JOE-BERGERSON: Writing Tiny x86 BootLoader](https://www.joe-bergeron.com/posts/Writing%20a%20Tiny%20x86%20Bootloader/)