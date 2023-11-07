.globl main

# Constants
.equ STDOUT, 1
.equ STDIN, 0
.equ __NR_READ, 63
.equ __NR_WRITE, 64
.equ __NR_EXIT, 93

.text
main:

 PROMPT INITIAL INTEGER
    li a7, __NR_WRITE
    li a0, STDOUT
    la a1, promptInt
    addi a2, zero, promptInt_end - promptInt
    ecall

# INTEGER ONE INPUT
    li a7, __NR_READ
    li a0, STDIN
    la a1, buf1
    addi a2, zero, 100
    ecall
    sb zero, buf1(a0)
    la a0, buf1
    call atoi
    mv t2, a0

# PROMPT SECOND INTEGER
    li a7, __NR_WRITE
    li a0, STDOUT
    la a1, promptInt
    addi a2, zero, promptInt_end - promptInt
    ecall

# INTEGER TWO INPUT
    li a7, __NR_READ
    li a0, STDIN
    la a1, buf3
    addi a2, zero, 100
    ecall
    sb zero, buf3(a0)
    la a0, buf3
    call atoi
    mv t3, a0

######################
# Division Diagram
######################
# Initilize Quotient, Remainder, Divisor, and Dividend.
# Normalize.
# Subtract the divisor from the dividend and count the number of times, 
# until the dividend is less than divisor.

do_division:

.data
promptInt: .ascii "Please enter an integer: \n"
promptInt_end:

promptOne: .ascii "\n"
promptOne_end:
