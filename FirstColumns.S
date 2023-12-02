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

    # Setup for 1st avg_columns
    la a0, matrix       # Load address of matrix into a0
    li a1, 8            # Set nrow to 8
    li a2, 8            # Set ncol to 8
    la s0, avg          # Load address of avg array into s0

    # Call avg_columns
    call avg_columns

    # Exit
    li a7, __NR_EXIT
    li a0, 0
    ecall

######################
# Division
######################
do_division:
    beq a1, zero, division_error   # Check if divisor is zero

    li a0, 0          # Initialize quotient
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
    # Prompt division error and exit
    li a7, __NR_WRITE
    li a0, STDOUT
    la a1, promptDivErr
    addi a2, zero, promptDivErr_end - promptDivErr
    ecall   
    li a7, __NR_EXIT  # Exit syscall
    li a0, 1          # Error code
    ecall

######################
# Average Columns Initial
######################
avg_columns:
    mv t2, a2                # t2 = ncol
    li t0, 0                 # t0 = i = 0

avg_column_loop:
    bge t0, t2, avg_column_loop_end # if i >= ncol, exit loop

    li t1, 0                 # t1 = k = 0
    li t3, 0                 # t3 = sum = 0

avg_row_loop:
    bge t1, a1, avg_row_loop_end    # if k >= nrow, exit loop

    # Calculate address of matrix[k][i]
    slli t4, t1, 2           # t4 = k * sizeof(unsigned int)
    add t5, t4, t0           # t5 = k * row size + i
    add t6, a0, t5           # t6 = &matrix[k][i]
    lw t5, 0(t6)             # t5 = matrix[k][i]

    add t3, t3, t5           # sum += matrix[k][i]
    addi t1, t1, 1           # Increment k
    j avg_row_loop

avg_row_loop_end:
    mv a0, t3                # Move sum to a0
    mv a1, a1                # Move nrow to a1
    call do_division         # Call do_division
    mv t3, a0                # Store division result in t3
    slli t6, t0, 2           # t6 = i * sizeof(unsigned int)
    add t6, s0, t6           # t6 = &avg[i]
    sw t3, 0(t6)             # avg[i] = avg
    addi t0, t0, 1           # Increment i
    j avg_column_loop

avg_column_loop_end:
    ret

.data
promptDivErr: .ascii "Division Error \n"
promptDivErr_end:

matrix: .space 256    # Allocate space for 8x8 matrix (assuming 4 bytes per element)
avg:    .space 32     # Allocate space for average array (8 elements, 4 bytes each)
