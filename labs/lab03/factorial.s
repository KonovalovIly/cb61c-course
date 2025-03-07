.globl factorial

.data
n: .word 8

.text
main:
    la t0, n
    lw a0, 0(t0)
    jal ra, factorial
    jal ra, print

    addi a0, x0, 10
    ecall # Exit

factorial:
    addi t0, x0, 1
    beq a0, t0, exit

    addi sp, sp, -8
    sw ra, 0(sp)
    sw a0, 4(sp)

    addi a0, a0, -1

    jal ra, factorial

    lw ra, 0(sp)
    lw a1, 4(sp)
    addi sp, sp, 8

    mul a0, a0, a1
exit:
    jr ra

print:
    addi sp, sp, -4
    sw a0, 0(sp)

    addi a1, a0, 0
    addi a0, x0, 1
    ecall # Print Result

    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    lw a0, 0(sp)
    addi sp, sp, 4
    jr ra
