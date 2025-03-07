.data
n: .word 8

.text
main:
    add t0, x0, x0
    addi t1, x0, 1
    la t3, n
    lw t4, 0(t3)
fib:
    beq t4, x0, finish
    add t2, t1, t0
    mv t0, t1
    mv t1, t2
    addi t4, t4, -1
    j fib
finish:

    addi a0, x0, 1
    addi a1, t0, 0
    ecall # print integer ecall

    addi a0, x0, 10
    ecall # terminate ecall
