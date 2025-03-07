.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -28
    sw s5, 24(sp)
    sw s4, 20(sp)
    sw s3, 16(sp)
    sw s2, 12(sp)
    sw s1, 8(sp)
    sw s0, 4(sp)
    sw ra, 0(sp)

    #Save args
    mv s0, a0
    mv s1, a1
    mv s2, a2

open_file:
    mv a1, s0
    li a2, 0
    jal fopen

    # Check file opened successfully
    li t0, -1
    li t1, 90
    beq a0, t0, error

    mv s3, a0               # Save file descriptor

read_rows:
    mv a1, s3
    mv a2, s1
    li a3, 4
    jal fread

    # Check if read was successful
    li t0, 4
    li t1, 91
    bne t0, a0, error
    lw s4, 0(s1)            # Store number of rows

read_cols:
    mv a1, s3
    mv a2, s2
    li a3, 4
    jal fread

    # Check if read was successful
    li t0, 4
    li t1, 91
    bne t0, a0, error
    lw s5, 0(s2)            # Store number of cols

allocate_memory:
    mul t0, s4, s5          # Matrix size
    slli t0, t0, 2          # Matrix size in bits
    mv a0, t0
    addi sp, sp, -4
    sw a0, 0(sp)
    jal malloc

    # Check if memory allocation was successful
    li t0, 0
    li t1, 88
    beq a0, t0, error

    mv s4, a0               # pointer to allocated memory
    lw s5, 0(sp)
    addi sp, sp, 4
read:
    mv a1, s3
    mv a2, s4
    mv a3, s5
    jal fread

    # Check if read was successful
    mv t0, s5
    li t1, 91
    bne t0, a0, error
    mv s5, a0

close_file:
    mv a1, s3
    jal fclose

        # Check file closed successfully
        li t0, -1
        li t1, 92
        beq a0, t0, error

    mv a0, s4
    mv a1, s1
    mv a2, s2

    # Epilogue
    lw s5, 24(sp)
    lw s4, 20(sp)
    lw s3, 16(sp)
    lw s2, 12(sp)
    lw s1, 8(sp)
    lw s0, 4(sp)
    lw ra, 0(sp)
    addi sp, sp, 28

    ret

error:
    mv a1, t1
    jal exit2
