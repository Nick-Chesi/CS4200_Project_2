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

    la a0, matrix     # Load address of matrix into a0
    li a1, 8              # Set nrow to 8
    li a2, 8              # Set ncol to 8
    la s0, avg         # Load address of avg array into s0

    # Call avg_columns
    call avg_columns

    # Exit
    li a7, __NR_EXIT
    li a0, 0
    ecall

#######################################
# ASCII to Integer
#######################################
atoi:
    li t1, 0  # Initialize result to 0
    lb t0, 0(a0)  # Load first byte
    bnez t0, not_end
    j atoi_done

not_end:
    li t2, 10  # Set t2 to 10 for multiplication
    li t3, 48  # Set t3 to ASCII '0' = 48
    li t4, 1   # Initialize sign to 1
    li t5, 45  # Set t5 to ASCII '-' = 45
    beq t0, t5, atoi_neg  # Check for '-' sign

atoi_loop:
    sub t0, t0, t3  # Convert ASCII to integer
    mul t1, t1, t2  # Multiply result by 10
    add t1, t1, t0  # Add current digit to result
    addi a0, a0, 1  # Increment address
    lb t0, 0(a0)    # Load next byte
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
# Division
######################
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

######################
# Average Columns Inital
######################
avg_columns:
    mv t2, a2       # t2 = ncol
    li t0, 0            # t0 = i = 0

column_loop:
    bge t0, t2, end_column_loop # if i >= ncol, exit loop

    li t1, 0        # t1 = k = 0
    li t3, 0        # t3 = sum = 0

row_loop:
    bge t1, a1, end_row_loop # if k >= nrow, exit loop

    # Calculate address of matrix[k][i]
    slli t4, t1, 2         # t4 = k * sizeof(unsigned int)
    add t5, t4, t0      # t5 = k * row size + i
    add t6, a0, t5     # t6 = &matrix[k][i]
    lw t5, 0(t6)         # t5 = matrix[k][i]

    add t3, t3, t5      # sum += matrix[k][i]
    addi t1, t1, 1      # Increment k
    j row_loop

end_row_loop:
    mv a0, t3               # Move sum to a0
    mv a1, a1              # Move nrow to a1
    call do_division      # Call do_division
    mv t3, a0               # Store division result in t3
    slli t6, t0, 2            # t6 = i * sizeof(unsigned int)
    add t6, s0, t6         # t6 = &avg[i]
    sw t3, 0(t6)           # avg[i] = avg
    addi t0, t0, 1         # Increment i
    j column_loop

end_column_loop:
    ret

######################
# Average Columns Re-written
######################

# avg_columns function
# a0 = matrix (pointer to first element)
# a1 = nrow
# a2 = ncol
# s0 = avg (pointer to the average array)
avg_columns_re:
    mv t1, a2       # t1 = ncol
    li t0, 0            # t0 = i = 0

row_loop:
    bge t0, a1, end_row_loop # if i >= nrow, exit loop

    li t2, 0        # t2 = k = 0
    li t3, 0        # t3 = sum = 0

column_loop:
    bge t2, t1, end_column_loop # if k >= ncol, exit loop

    # Calculate address of matrix[i][k]
    slli t4, t0, 2       # t4 = i * sizeof(int)
    mul t4, t4, t1    # t4 = i * ncol * sizeof(int)
    add t5, t4, t2    # t5 = i * ncol + k
    add t6, a0, t5   # t6 = &matrix[i][k]
    lw t5, 0(t6)       # t5 = matrix[i][k]

    add t3, t3, t5    # sum += matrix[i][k]
    addi t2, t2, 1    # Increment k
    j column_loop

end_column_loop:
    mv a0, t3             # Move sum to a0
    li a1, 1                 # a1 = 1 (as divisor)
    call do_division    # Call do_division
    mv t3, a0             # Store division result in t3
    slli t4, t0, 2          # t4 = i * sizeof(int)
    add t4, s0, t4       # t4 = &avg[i]
    sw t3, 0(t4)          # avg[i] = avg
    addi t0, t0, 1        # Increment i
    j row_loop

end_row_loop:
    ret

.data
promptInt: .ascii "Please enter an integer: \n"
promptInt_end:

promptDivErr: .ascii "Division Error \n"
promptDivErr_end:

promptOne: .ascii "\n"
promptOne_end:

buf1: .space 25
buf1_end:

buf2: .space 25
buf2_end:

matrix: .space 256    # Allocate space for 8x8 matrix (assuming 4 bytes per element)
avg:    .space 32     # Allocate space for average array (8 elements, 4 bytes each)
