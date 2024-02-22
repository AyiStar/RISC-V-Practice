.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:

    # Error checks
    ble a1, zero, exception
    ble a2, zero, exception
    bne a2, a4, exception
    ble a5, zero, exception

    # Prologue
    addi sp, sp, -28
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    mv s5, a5
    mv s6, a6

    mv t0, zero  # outer loop iterator
    mv t1, zero  # inner loop iterator
    mv t2, s0    # pointer to arr0
    mv t3, s3    # pointer to arr1
    mv t4, s6    # pointer to output

outer_loop_start:
    bge t0, s1, outer_loop_end
    mv t1, zero  # reset inner loop iterator
    mv t3, s3    # reset arr1


inner_loop_start:
    bge t1, s5, inner_loop_end

    addi sp, sp, -32
    sw ra, 0(sp)
    sw t0, 4(sp)
    sw t1, 8(sp)
    sw t2, 12(sp)
    sw t3, 16(sp)
    sw t4, 20(sp)
    sw t5, 24(sp)
    sw t6, 28(sp)

    mv a0, t2  # arr0
    mv a1, t3  # arr1
    mv a2, s2  # n_elements
    li a3, 1   # arr0 stride
    mv a4, s5, # arr1 stride
    jal ra, dot

    lw t6, 28(sp)
    lw t5, 24(sp)
    lw t4, 20(sp)
    lw t3, 16(sp)
    lw t2, 12(sp)
    lw t1, 8(sp)
    lw t0, 4(sp)
    lw ra, 0(sp)
    addi sp, sp, 32

    sw a0, 0(t4)  # store output

    addi t1, t1, 1  # increment iterator
    addi t3, t3, 4  # increment arr1
    addi t4, t4, 4  # increment output
    j inner_loop_start

inner_loop_end:
    addi t0, t0, 1  # increment iterator
    slli a1, s2, 2
    add t2, t2, a1  # increment arr0
    j outer_loop_start

outer_loop_end:

    # Epilogue
    lw s6, 24(sp)
    lw s5, 20(sp)
    lw s4, 16(sp)
    lw s3, 12(sp)
    lw s2, 8(sp)
    lw s1, 4(sp)
    lw s0, 0(sp)
    addi sp, sp, 28

    jr ra

exception:
    li a0, 38
    j exit