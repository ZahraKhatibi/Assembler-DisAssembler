# Machine Language and Assembly Course Project
![](assembly.png)

This project implements an assembler and disassembler for Assembly64 in Python. Assembly64 commands can be 8, 16, 32, or 64 bits with various addressing modes (specifically for 64-bit).This project focuses on designing an assembler and a disassembler for the Assembly Language. The assembler is responsible for converting asm64 commands into hexadecimal equivalents, while the disassembler converts binary strings back into asm64 commands. Both implementations are provided in both Python and Assembly Languages.

## Features
- Both projects are thoroughly commented for easy comprehension.
- Achieved high score in class and successfully passed all test cases.

## Built With
- Python3
- Assembly64

## Getting Started
### Prerequisites
- Ubuntu and an Intel chip
- VSCode, that is easier than terminal!
- 
## Supported Arguments
Arguments can be:

- First Operand: Register (8/16/32/64 bits)
- Second Operand: Register (8/16/32/64 bits)
- First Operand: Register (8/16/32/64 bits), Second Operand: Memory (32/64 bits - direct/indirect)
- First Operand: Memory (32/64 bits - direct/indirect), Second Operand: Register (8/16/32/64 bits)
- First Operand: Register (8/16/32/64 bits), Second Operand: Immediate Data
- First Operand: Memory (32/64 bits - direct/indirect), Second Operand: Immediate Data

## Input Rules
1. A space must separate the instruction and the first operand (if present).
2. If there are two operands, they are separated by a comma without spaces (e.g., `mov rax,rbx`).
3. When an operand is memory, its size must be specified, and it should be preceded by `PTR` within square brackets (e.g., `or WORD PTR [edx*8],ax`).
4. No spaces should exist between elements within memory operands (e.g., `mov edx,DWORD ptr [ebx+ecx*1+0x32345467]`).
5. If displacement exists in memory operands, it must be in hexadecimal format starting with `0x`.
6. All characters should be in lowercase English, except for `BYTE`, `WORD`, `DWORD`, `QWORD`.
7. When a memory operand includes a register index, the `scale` value must be displayed, even if it's 1.
8. The order for base, index, scale, and displacement in memory operands is `[base+index*scale+disp]`.
9. Carefully handle cases where `ebp` or `rbp` is chosen as the base register. Refer to the Defuse website for different scenarios.
10. The only exception to hex input is for `imul`, and you only need to code for single-operand `idiv`. No need to handle cases where shift counts are held in `cl`.

## Output Rules
1. The output must be in hexadecimal.
2. There should be no `0x` prefix in the output.

**Note:** Refer to the Defuse website for all test cases: [Defuse x86 Assembler](https://defuse.ca/online-x86-assembler.htm)





## Supported Commands

| Command |           |           |           |           |           |   
|---------|-----------|-----------|-----------|-----------|-----------|
| mov     |  add      | adc       |   sub     |  sbb      |    and    |
|   or    |  xor      |  dec      |    inc    |  cmp      |  test     |
|   xchg  |  xadd     |   imul    |    idiv   |   bsf     | bsr       |
|   stc   |    clc    |     std   |    cld    |   jmp     |    jcc    |
|   shr   |  shl      |   neg     |    not    |  call     |   ret     |
| syscall |    push   |  pop      |           |           |           |

