.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero,
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    li t0, 5
    bne a0, t0, arg_error

    addi sp, sp, -52
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)
    sw s10, 44(sp)
    sw s11, 48(sp)

    lw s0, 4(a1)    # M0_PATH point
    lw s1, 8(a1)    # M1_PATH point
    lw s2, 12(a1)   # INPUT_PATH point
    lw s3, 16(a1)   # OUTPUT_PATH point
    mv s4, a2       # print_classification

	# =====================================
    # LOAD MATRICES
    # =====================================

    # Load pretrained m0
        # malloc rows
        li a0, 4
        jal malloc

        li t0, 0
        beq a0, t0, malloc_error
        mv s5, a0

        # malloc cols
        li a0, 4
        jal malloc

        li t0, 0
        beq a0, t0, malloc_error
        mv s6, a0

    mv a0, s0
    mv a1, s5   # M0 rows
    mv a2, s6   # M0 cols
    jal read_matrix
    mv s0, a0   # Set to pointer to the matrix m0

    # Load pretrained m1
        # malloc rows
        li a0, 4
        jal malloc

        li t0, 0
        beq a0, t0, malloc_error
        mv s7, a0

        # malloc cols
        li a0, 4
        jal malloc

        li t0, 0
        beq a0, t0, malloc_error
        mv s8, a0

    mv a0, s1
    mv a1, s7   # M1 rows
    mv a2, s8   # M1 cols
    jal read_matrix
    mv s1, a0   # Set to pointer to the matrix m1

    # Load input matrix
        # malloc rows
        li a0, 4
        jal malloc

        li t0, 0
        beq a0, t0, malloc_error
        mv s9, a0

        # malloc cols
        li a0, 4
        jal malloc

        li t0, 0
        beq a0, t0, malloc_error
        mv s10, a0

    mv a0, s2
    mv a1, s9   # INPUT rows
    mv a2, s10  # INPUT cols
    jal read_matrix
    mv s2, a0   # Set to pointer to the matrix input


    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    # Linear m0 * input
        # Memory allocation for result
        lw t0, 0(s5)
        lw t1, 0(s10)
        mul a0, t0, t1
        slli a0, a0, 2
        jal malloc

        li t0, 0
        beq a0, t0, malloc_error
        mv s11, a0          # Set memory for result

    mv a0, s0
    lw t0, 0(s5)
    mv a1, t0
    lw t0, 0(s6)
    mv a2, t0

    mv a3, s2
    lw t0, 0(s9)
    mv a4, t0
    lw t0, 0(s10)
    mv a5, t0
    mv a6, s11
    jal matmul

    # ReLU
    mv a0, s11
    lw t0, 0(s5)
    lw t1, 0(s10)
    mul a1, t0, t1
    jal relu

    # Linear m0 * input
    mv a0, s1
    lw t0, 0(s7)
    mv a1, t0
    lw t0, 0(s8)
    mv a2, t0

    mv a3, s11
    lw t0, 0(s5)
    mv a4, t0
    lw t0, 0(s10)
    mv a5, t0
    mv a6, s0
    jal matmul


    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    mv a0, s3
    mv a1, s0
    lw t0, 0(s7)
    mv a2, t0
    lw t0, 0(s10)
    mv a3, t0
    jal write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0, s0
    lw t0, 0(s5)
    lw t1, 0(s10)
    mul a1, t0, t1
    jal argmax

    # Classification result is in a0


    # Print classification
    bne s4, x0, after_print
    mv a1, a0
    jal print_int
    li a1, '\n'
    jal print_char

    # Print newline afterwards for clarity
after_print:

    #Free allocated memory
    mv a0, s0
    jal free
    mv a0, s1
    jal free
    mv a0, s2
    jal free
    mv a0, s5
    jal free
    mv a0, s6
    jal free
    mv a0, s7
    jal free
    mv a0, s8
    jal free
    mv a0, s9
    jal free
    mv a0, s10
    jal free
    mv a0, s11
    jal free

    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    lw s10, 44(sp)
    lw s11, 48(sp)
    addi sp, sp, 52
    ret


malloc_error:
    li a1, 88
    jal exit2

arg_error:
    li a1, 89
    jal exit2
