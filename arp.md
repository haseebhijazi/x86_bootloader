## 1. Stack implmentation
Data Segment  (`ds`) : `0x7C0`  (default in BIOS-based systems : 0x7C00 / 16) <br>
Stack Segment (`ss`) : `0x7E0`  (add 512 bytes to 0x7C00 and then div by 16) <br>
Stack Pointer (`sp`) : `0x2000` (8kB of stack) <br>

## 2. Sub-Routines
IDEA : store certain values in regs and send an opcode as an interrupt to the BIOS

                            :: CLEARSCREEN ::
If `AH` is `0x07` and interrupt code is `0x10`, we can scroll down the window to the number of rows stored in `AL` (`0x00` to clear the window).

`BH` refers to BIOS color attribute. `0x07`: Black BG `0x0` and Light Grey Text `0x7`

`CX` and `DX` refer to top-left and bottom-right of the sub-section of the screen respectively.
The standard number of character rows/cols here is `25`/`80`, so we set `CH` and `CL` to `0x00` to set (0,0), and `DH` as `0x18` = `24`, `DL` as `0x4f` = `79` to set (24,79). 

                            :: MOVECURSOR ::
`AH` : `0x02` and interrupt code : `0x10` <br>

`DH` represents row and `DL` coloumn. Value is passed as an arg. <br>
The `bp` reg is used to reference function args and local vars. `bp` takes `2` `bytes` and arg below it takes `2` `bytes`. In order to point to the base of arg, we need to add `4` `bytes` to the `bp`.

`BH` represents page no we want to move the cursor to. Though, we will use page no 0, but, the BIOS allows you to draw to off-screen pages, in order to facilitate smoother visual transitions by rendering off-screen content before it is shown to the user. This is called `multiple` or `double buffering`. 

                            :: PRINT ::
`AH` : `0x0E` and interrupt code : `0x10` <br>

`SI` is used to point to the string passed as an arg. <br>
We keep checking if the current character is `null`. If it is, then we are `done`. Otherwise, keep looping for printing the `char`.

## 3. WRAP UP
`bits` `16` tells the assembler that we're working in 16-bit real mode.<br>
The code in a bootsector has to be exactly `512` `bytes`, ending in `0xAA55` `signature`. Signature takes `2 bytes`. The rest of the code is padded with `0s` till it becomes `510 bytes` and ends with `0xAA55`. 

