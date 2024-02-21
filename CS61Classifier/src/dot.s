.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the number of elements to use is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
    bgt a2, zero, check_a3
    li a0, 36
    j exit

check_a3:
    bgt a3, zero, check_a4
    li a0, 37
    j exit

check_a4:
    bgt a4, zero, start
    li a0, 37
    j exit

start:
    slli a3, a3, 2
    slli a4, a4, 2
    mv t0, zero  # iterator
    mv t1, zero  # sum


loop_start:
    bge t0, a2, loop_end
    lw t2, 0(a0)
    lw t3, 0(a1)
    mul t4, t2, t3
    add t1, t1, t4

    add a0, a0, a3
    add a1, a1, a4
    addi t0, t0, 1
    j loop_start

loop_end:
    mv a0, t1

    jr ra
