.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    # Prologue
    addi t0, x0, 1
    blt a1, t0, exception
    add t0, x0, x0

loop_start:
    slli t1, t0, 2
    add t1, a0, t1
    lw t2, 0(t1)
    blt x0, t2, loop_continue
    mv t2, x0

loop_continue:
    addi t0, t0, 1
    sw t2, 0(t1)
    bne a1, t0, loop_start

loop_end:
    # Epilogue

	ret

exception:
    li a0, 17
    li a1, 78
    ecall           # Terminate the program with error code 78
