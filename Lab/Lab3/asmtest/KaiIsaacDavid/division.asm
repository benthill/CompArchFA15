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
lw $t3, one
lw $a0, opA
lw $a1, opB

# Setup result registers
add $t2, $zero, $zero
add $t0, $zero, $a0

LOOP_START:

    slt $t1, $t0, $a1
    bne $t1, 0, LOOP_END

    sub $t0, $t0, $a1
    add $t2, $t2, $t3

j LOOP_START


LOOP_END:

# Write results to registers
add $v0, $t2, $zero
add $v1, $t0, $zero

# finish with infinite jump loop
DONE:
j DONE

# Modify opA and opB to compute different quotients
.data
	one: .word 1
	opA: .word 11
	opB: .word 5


