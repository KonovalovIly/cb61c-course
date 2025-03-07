.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:

    # Prologue
    addi t0, x0, 1
    blt a1, t0, exception
    mv t0, x0               # t0 - index
    lw t2, 0(a0)            # t2 - max value holder
    mv t3, x0
loop_start:
    slli t1, t0, 2          # t1 - offset
    add t1, t1, a0          # t1 - pointer to val
    lw t1, 0(t1)
    blt t1, t2 loop_continue
    mv t2, t1               # Update max value holder
    mv t3, t0               # Update index holder

loop_continue:
    addi t0, t0, 1
    blt t0, a1, loop_start
    mv a0, t3               # Return the index of the largest element

loop_end:


    # Epilogue


    ret

exception:
    li a0, 17
    li a1, 77
    ecall           # Terminate the program with error code 78
