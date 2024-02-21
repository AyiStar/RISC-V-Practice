.globl abs

.text
# =================================================================
# FUNCTION: Given an int return its absolute value.
# Arguments:
#   a0 (int) is input integer
# Returns:
#   a0 (int) the absolute value of the input
# =================================================================
abs:
    ebreak
    bge a0, zero, abs_return 
    sub a0, zero, a0

abs_return:
    jr ra
