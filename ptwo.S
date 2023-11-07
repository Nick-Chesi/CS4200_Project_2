# Project 2
# Elise, Colby, Nick
# Gedare Bloom

.globl main

# Constants
.equ STDOUT, 1
.equ STDIN, 0
.equ __NR_READ, 63
.equ __NR_WRITE, 64
.equ __NR_EXIT, 93

.text
main:

    # PROMPT INITIAL INTEGER
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
    mv t2, a0 # Dividend

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
    mv t3, a0 # Divisor


    # Call division
    mv a0, t2  # Dividend
    mv a1, t3  # Divisor
    call do_division
    mv t4, a0  # Quotient

    # Exit
    li a7, __NR_EXIT
    li a0, 0
    ecall

######################
# Division Diagram
######################
# Initilize Quotient, Remainder, Divisor, and Dividend.
# Normalize.
# Subtract the divisor from the dividend and count the number of times, 
# until the dividend is less than divisor.

do_division:
    # Check if divisor is zero
    beq a1, zero, division_error

    li a0, 0          # Quotient
    mv t0, a0         # Dividend 
    mv t1, a1         # Divisor 

division_error:
    # PROMPT DIVISION ERROR
    li a7, __NR_WRITE
    li a0, STDOUT
    la a1, promptDivErr
    addi a2, zero, promptDivErr_end - promptDivErr
    ecall   

.data
promptInt: .ascii "Please enter an integer: \n"
promptInt_end:

promptDivErr: .ascii "Division Error \n"
promptDivErr_end:

promptOne: .ascii "\n"
promptOne_end:
