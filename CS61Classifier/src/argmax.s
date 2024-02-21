.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    bgt a1, zero, start
    li a0, 36
    j exit
    # Prologue

start:
    mv t0, zero  # iterator
    mv t1, zero  # max index
    lw t2, 0(a0) # max element

loop_start:
    bge t0, a1, loop_end
    lw t3, 0(a0)
    ble t3, t2, loop_continue
    mv t1, t0
    mv t2, t3

loop_continue:
    addi a0, a0, 4
    addi t0, t0, 1
    j loop_start

loop_end:
    mv a0, t1
    jr ra
