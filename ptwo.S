.globl main

# Constants
.equ STDOUT, 1
.equ STDIN, 0
.equ __NR_READ, 63
.equ __NR_WRITE, 64
.equ __NR_EXIT, 93

.text
main:



.data
promptOne: .ascii "\n"
promptOne_end:
