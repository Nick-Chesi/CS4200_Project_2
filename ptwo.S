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
    la a1, buf2
    addi a2, zero, 100
    ecall
    sb zero, buf2(a0)
    la a0, buf2
    call atoi
    mv t3, a0 # Divisor


    # Call division
    mv a0, t2  # Dividend
    mv a1, t3  # Divisor
    call do_division
    mv t4, a0  # Quotient

    # Return here after division
    
    # Exit
    li a7, __NR_EXIT
    li a0, 0
    ecall


#######################################
#ASCII to Integer
#######################################
# DIAGRAM
# Initialize result to 0
# Set t2 to 10 for multiplication
# Load next byte
#
# If byte is null, end
# Move to next byte
# Convert ASCII to integer
# Multiply result by 10
# Add current digit to result
# Set return value to result
atoi:
    # a0 = address of string
    # result = integer in a0

    li t1, 0  # Initialize result to 0
    lb t0, 0(a0)  # Load first byte
    bnez t0, not_end
    j atoi_done

not_end:
    li t2, 10  # Set t2 to 10 for multiplication
    li t3, 48  # Set t3 to ASCII '0' = 48
    li t4, 1  # Initialize sign to 1
    li t5, 45  # Set t5 to ASCII '-' = 45
    beq t0, t5, atoi_neg  # Check for '-' sign

atoi_loop:
    sub t0, t0, t3  # Convert ASCII to integer
    mul t1, t1, t2  # Multiply result by 10
    add t1, t1, t0  # Add current digit to result
    lb t0, 0(a0)  # Load next byte
    addi a0, a0, 1
    bnez t0, atoi_loop

atoi_done:
    mv a0, t1
    ret

atoi_neg:
    li t4, -1  # Set sign to -1
    addi a0, a0, 1  # Increment address
    lb t0, 0(a0)  # Load next byte
    bnez t0, atoi_loop

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

division_loop:
    blt t0, t1, division_done
    sub t0, t0, t1
    addi a0, a0, 1
    j division_loop

division_done:
    ret

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


promptDivErr: .ascii "Error With Division"
promptDivErr_end:

#Input buffers
buf1: .space 25
buf1_end:

buf2: .space 25
buf2_end:
