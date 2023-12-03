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
    la a0, matrix       # Address of the matrix
    li a1, 8            # Number of rows
    li a2, 8            # Number of columns
    la s0, avg          # Address of the average array

    # Call avg_columns_riscv_div
    call avg_columns_riscv_div

    # loading results into array avg
    la a0, avg          # Load the address of the avg array
    li t1, 8            # Assuming 8 elements in avg

    # Exit
    li a7, __NR_EXIT
    li a0, 0
    ecall

######################
# Average Columns With RISC-V Div
######################

avg_columns_riscv_div:
    mv t2, a2                # t2 = ncol
    li t0, 0                 # t0 = i = 0 (column index)

avg_column_riscv_div_loop:
    bge t0, t2, avg_column_riscv_div_loop_end  # Exit loop if i >= ncol

    li t1, 0                 # t1 = k = 0 (row index)
    li t3, 0                 # t3 = sum = 0

avg_row_riscv_div_loop:
    bge t1, a1, avg_row_riscv_div_loop_end    # Exit loop if k >= nrow

    # Corrected address calculation for matrix[k][i]
    la t4, matrix            # Load base address of matrix into t4
    mul t5, t1, t2           # k * ncol
    add t5, t5, t0           # k * ncol + i
    li t6, 4                 # Immediate value of 4
    mul t5, t5, t6           # 4(k * ncol + i)
    add t4, t4, t5           # Final memory address for matrix[k][i] in t4
    lw t5, 0(t4)             # Load word from matrix[k][i]

    add t3, t3, t5           # sum += matrix[k][i]
    addi t1, t1, 1           # Increment row index k
    j avg_row_riscv_div_loop  # Jump back to the start of the row loop

avg_row_riscv_div_loop_end:
    mv a0, t3                # Move sum to a0
    li a1, 8                 # Set divisor to nrow
    # RISC-V division
    beqz a1, division_error  # Check for division by zero
    div t3, a0, a1           # Divide sum by nrow using RISC-V div

    # Corrected address calculation for avg array
    la t4, avg               # Load base address of avg into t4
    li t6, 4                 # Immediate value of 4
    mul t5, t0, t6           # 4 * i
    add t4, t4, t5           # Final memory address for avg[i]
    sw t3, 0(t4)             # Store average in avg[i]

    addi t0, t0, 1           # Increment column index i
    j avg_column_riscv_div_loop  # Jump back to the start of the column loop

avg_column_riscv_div_loop_end:
    ret                      # Return from the function

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

.data
promptDivErr: .ascii "Division Error \n"
promptDivErr_end:

matrix: .space 256    # Allocate space for 8x8 matrix (assuming 4 bytes per element)
avg:    .space 32     # Allocate space for average array (8 elements, 4 bytes each)
