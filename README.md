# Machine Language and Assembly Course Project

This project focuses on designing an assembler and a disassembler for the Assembly Language. The assembler is responsible for converting asm64 commands into hexadecimal equivalents, while the disassembler converts binary strings back into asm64 commands. Both implementations are provided in both Python and Assembly Languages.

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

## Commands Supported
The supported commands include:
- `mov`
- `add`
- `adc`
- `sub`
- `sbb`
- `and`
- `or`
- `xor`
- `dec`
- `inc`
- `cmp`
- `test`
- `xchg`
- `xadd`
- `imul`
- `idiv`
- `bsf`
- `bsr`
- `stc`
- `clc`
- `std`
- `cld`
- `shl`
- `shr`
- `neg`
- `not`
- `call`
- `ret`
- `syscall`
- `push`
- `pop`

## Supported Arguments
Arguments can be:

- First Operand: Register (8/16/32/64 bits)
- Second Operand: Register (8/16/32/64 bits)
- First Operand: Register (8/16/32/64 bits), Second Operand: Memory (32/64 bits - direct/indirect)
- First Operand: Memory (32/64 bits - direct/indirect), Second Operand: Register (8/16/32/64 bits)
- First Operand: Register (8/16/32/64 bits), Second Operand: Immediate Data
- First Operand: Memory (32/64 bits - direct/indirect), Second Operand: Immediate Data
