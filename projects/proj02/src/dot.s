.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:
    addi t0, x0, 1
    blt a2, t0, exception_length
    blt a3, t0, exception_stride
    # Prologue
    li t1, 0                # index
    li t2, 0                # result
loop_start:
    beq t1, a2, loop_end
    slli t3, t1, 2
    mul t4, t3, a3
    mul t5, t3, a4
    add t4, a0, t4
    add t5, a1, t5

    lw t4, 0(t4)
    lw t5, 0(t5)

    mul t3, t4, t5
    add t2, t2, t3
    addi t1, t1, 1
    j loop_start

loop_end:
    mv a0, t2

    # Epilogue


    ret

exception_length:
    li a0, 17
    li a1, 75
    ecall

exception_stride:
    li a0, 17
    li a1, 76
    ecall
