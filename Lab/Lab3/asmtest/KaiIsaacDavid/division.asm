#-------------------------------------------------------
# Divide
# 
# This function divides opA by opB.
#
# The result of the integer division is put in 
# register $v0 and the remainder is put in register $v1.
#
# The operand values can be changed in the .data section.
#--------------------------------------------------------

# Load operands into registers
xori $t3, $zero, 1
xori $a0, $zero, 1
xori $a1, $zero, 2

# Setup result registers
add $t2, $zero, $zero
add $t0, $zero, $a0

LOOP_START:

    slt $t1, $t0, $a1
    bne $t1, $zero, LOOP_END

    sub $t0, $t0, $a1
    add $t2, $t2, $t3

j LOOP_START


LOOP_END:

# Write results to registers
add $v0, $t2, $zero
add $v1, $t0, $zero

LOOP_DE_LOOP:
	add $v0, $v0, $zero
	add $v1, $v1, $zero
	j LOOP_DE_LOOP
