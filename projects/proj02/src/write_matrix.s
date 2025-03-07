.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 95.
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -20
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)

    mv s0, a0   # Store filename point
    mv s1, a1   # Store matrix point
    mv s2, a2   # Store rows
    mv s3, a3   # Store cols

create_file:
    mv a1, s0
    li a2, 1    # write mode
    jal fopen
    li t1, -1
    li t0, 93
    beq a0, t1, error

    mv s0, a0   # Set file descriptor

write_row:
    mv a1, s0
    addi sp, sp, -4
    sw s2, 0(sp)
    mv a2, sp
    li a3, 1
    li a4, 4
    jal fwrite

    # Check fwrite successful
    li t1, 1
    li t0, 94
    bne a0, t1, error
    addi sp, sp, 4

write_cols:
    mv a1, s0
    addi sp, sp, -4
    sw s3, 0(sp)
    mv a2, sp
    li a3, 1
    li a4, 4
    jal fwrite

    # Check fwrite successful
    li t1, 1
    li t0, 94
    bne a0, t1, error
    addi sp, sp, 4

matrix_write:
    mv a1, s0
    mv a2, s1
    mul s2, s2, s3
    mv a3, s2
    li a4, 4
    jal fwrite

    li t0, 94
    bne a0, s2, error

close_file:
    mv a1, s0
    jal fclose

    # Check file closed successfully
    li t1, -1
    li t0, 95
    beq a0, t1, error

    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    addi sp, sp, 20

    ret

error:
    mv a1, t0
    jal exit2
