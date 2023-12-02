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

    # Setup for risc-v div avg_columns
    # Load the address of the matrix and average array
    la a0, matrix       # Address of the matrix
    li a1, 8            # Number of rows
    li a2, 8            # Number of columns
    la s0, avg          # Address of the average array

    # Call avg_columns_riscv_div
    call avg_columns_riscv_div

    # loading results into array avg
    # NOTE: we really do not need to do this I dont think
    # as we can just check registers after running the code
    # and count CPU Cycles - Nick
    la a0, avg        # Load the address of the avg array
    li t1, 8          # Assuming 8 elements in avg

    # Exit
    li a7, __NR_EXIT
    li a0, 0
    ecall

######################
# Average Columns With RISC-V Div
######################

avg_columns_riscv_div:
    mv t2, a2                # t2 = ncol
    li t0, 0                 # t0 = i = 0

avg_column_riscv_div_loop:
    # if i >= ncol, exit loop
    bge t0, t2, avg_column_riscv_div_loop_end

    li t1, 0                 # t1 = k = 0
    li t3, 0                 # t3 = sum = 0

avg_row_riscv_div_loop:
    # if k >= nrow, exit loop
    bge t1, a1, avg_row_riscv_div_loop_end

    # Calculate address of matrix[k][i]
    slli t4, t1, 2           # t4 = k * sizeof(unsigned int)
    add t5, t4, t0           # t5 = k * row size + i
    add t6, a0, t5           # t6 = &matrix[k][i]
    lw t5, 0(t6)             # t5 = matrix[k][i]

    add t3, t3, t5           # sum += matrix[k][i]
    addi t1, t1, 1           # Increment k
    j avg_row_riscv_div_loop

avg_row_riscv_div_loop_end:
    mv a0, t3                # Move sum to a0
    li t4, 1                 # Set divisor (nrow) to 1
    # Check for division by zero
    beqz t4, division_error
    div t3, a0, t4           # Divide sum by nrow
    slli t6, t0, 2           # t6 = i * sizeof(unsigned int)
    add t6, s0, t6           # t6 = &avg[i]
    sw t3, 0(t6)             # avg[i] = avg
    addi t0, t0, 1           # Increment i
    j avg_column_riscv_div_loop

avg_column_riscv_div_loop_end:
    ret

.data
promptDivErr: .ascii "Division Error \n"
promptDivErr_end:

matrix: .space 256    # Allocate space for 8x8 matrix (assuming 4 bytes per element)
avg:    .space 32     # Allocate space for average array (8 elements, 4 bytes each)
