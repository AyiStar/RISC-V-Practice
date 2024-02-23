.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:

    li t0, 5
    beq a0, t0, start
    li a0, 31
    j exit

start:

    addi sp, sp, -72
    sw ra, 0(sp)
    sw s0, 4(sp)  # arg0
    sw s1, 8(sp)  # arg1
    sw s2, 12(sp) # arg2
    sw s3, 16(sp) # m0
    sw s4, 20(sp) # m1
    sw s5, 24(sp) # input
    sw s6, 28(sp) # output

    mv s0, a0
    mv s1, a1
    mv s2, a2

    # Read pretrained m0
    lw a0, 4(s1)  # file name
    addi a1, sp, 32  # m0 row
    addi a2, sp, 36  # m0 col
    jal read_matrix
    mv s3, a0

    # Read pretrained m1
    lw a0, 8(s1)  # file name
    addi a1, sp, 40  # m1 row
    addi a2, sp, 44  # m1 col
    jal read_matrix
    mv s4, a0

    # Read input matrix
    lw a0, 12(s1)  # file name
    addi a1, sp, 48  # input row
    addi a2, sp, 52  # input col
    jal read_matrix
    mv s5, a0

    # Compute h = matmul(m0, input)
    lw t0, 32(sp)  # h row
    lw t1, 52(sp)  # h col
    mul a0, t0, t1
    sw a0, 56(sp)  # n_elements of h
    slli a0, a0, 2
    jal malloc
    beq a0, zero, malloc_fail
    sw a0, 60(sp)  # h
    mv a0, s3
    lw a1, 32(sp)
    lw a2, 36(sp)
    mv a3, s5
    lw a4, 48(sp)
    lw a5, 52(sp)
    lw a6, 60(sp)
    jal matmul

    # Compute h = relu(h)
    lw a0, 60(sp)
    lw a1, 56(sp)
    jal relu

    # Compute o = matmul(m1, h)
    lw t0, 40(sp)  # o row
    lw t1, 52(sp)  # o col
    mul a0, t0, t1
    sw a0, 64(sp)  # n_elements of o
    slli a0, a0, 2
    jal malloc
    beq a0, zero, malloc_fail
    sw a0, 68(sp)  # o
    mv a0, s4
    lw a1, 40(sp)
    lw a2, 44(sp)
    lw a3, 60(sp)
    lw a4, 32(sp)
    lw a5, 52(sp)
    lw a6, 68(sp)
    jal matmul

    # Write output matrix o
    lw a0, 16(s1)
    lw a1, 68(sp)
    lw a2, 40(sp)
    lw a3, 52(sp)
    jal write_matrix

    # Compute and return argmax(o)
    lw a0, 68(sp)
    lw a1, 64(sp)
    jal argmax
    mv s0, a0

    # If enabled, print argmax(o) and newline
    bne s2, zero, return
    jal print_int
    li a0, '\n'
    jal print_char

return:
    lw a0, 60(sp)
    jal free
    lw a0, 68(sp)
    jal free
    mv a0, s0
    lw s6, 28(sp) # output
    lw s5, 24(sp) # input
    lw s4, 20(sp) # m1
    lw s3, 16(sp) # m0
    lw s2, 12(sp) # arg2
    lw s1, 8(sp)  # arg1
    lw s0, 4(sp)  # arg0
    lw ra, 0(sp)
    addi sp, sp, 72
    
    jr ra

malloc_fail:
    li a0, 26
    j exit