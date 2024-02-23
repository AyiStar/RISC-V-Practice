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
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -28
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2

open_file:
    # mv a0, s0
    li a1, 0
    jal fopen
    bge a0, zero, read_num_row
    li a0, 27
    j exit

read_num_row:
    mv s3, a0 # file descripter
    mv a1, s1
    li a2, 4
    jal fread
    li a1, 4
    beq a0, a1, read_num_col
    li a0, 29
    j exit

read_num_col:
    mv a0, s3
    mv a1, s2
    li a2, 4
    jal fread
    li a1, 4
    beq a0, a1, alloc_mem
    li a0, 29
    j exit

alloc_mem:
    lw t0, 0(s1)
    lw t1, 0(s2)
    mul s4, t0, t1  # n_elements
    slli s4, s4, 2  # n_bytes
    mv a0, s4
    jal malloc
    bne a0, zero, read_data
    li a0, 26
    j exit

read_data:
    mv s5, a0  # (void*)data
    mv a0, s3
    mv a1, s5
    mv a2, s4
    jal fread
    beq a0, s4, close_file
    li a0, 29
    j exit

close_file:
    mv a0, s3
    jal fclose
    beq a0, zero, return
    li a0, 28
    j exit

return:
    mv a0, s5

    # Epilogue
    lw s5, 24(sp)
    lw s4, 20(sp)
    lw s3, 16(sp)
    lw s2, 12(sp)
    lw s1, 8(sp)
    lw s0, 4(sp)
    lw ra, 0(sp)
    addi sp, sp, 28
    jr ra
