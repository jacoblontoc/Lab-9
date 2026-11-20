# CMPE 310 Lab 9

Lab report: [Lab_Report_8255_SHE.pdf](Lab_Report_8255_SHE.pdf)

## Assemble

The code targets an 8086 system with an 8255 at I/O address 0x640, so it is assembled and checked here but not run on a PC. In GitHub Codespaces or Linux, run:

```sh
as --32 she_scroll.s -o she_scroll.o
objdump -d -mi8086 she_scroll.o
```

## Design

The 8255 sits at 0x640–0x643. Port A (0x640) drives the PNP digit transistors and is active low, so a 0 turns a digit on. Port B (0x641) drives the NPN segment transistors and is active high, with bits X g f e d c b a. Control word 0x80 sets every port to a Mode 0 output.

| Letter | Segments | Port B |
| --- | --- | ---: |
| S | a, c, d, f, g | 0x6D |
| H | b, c, e, f, g | 0x76 |
| E | a, d, e, f, g | 0x79 |

## Code

`she_scroll.s` shows S, H and E on digits SI, SI−1 and SI−2, 100 times per position. The `show` routine blanks all digits, writes the letter to Port B, then turns on one digit by rotating 0xFE left by the digit number and writing it to Port A. After each position, the direction in BP is added to SI, and BP flips at the left edge (SI = 7) and the right edge (SI = 2), so "SHE" bounces back and forth.
