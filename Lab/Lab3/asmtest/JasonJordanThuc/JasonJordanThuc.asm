# Multiply opA*opB, store result to $s0
# XORI $s0 with the expected result and then some other number
# To change values of opA and opB, modify .data
MAIN:
	lw $a0, opA
	lw $a1, opB
	jal MULTIPLY
	add $s0, $v1, $zero
	
	xori $s1, $v1, 6
	xori $s2, $v1, 7
	
	# exit program
	lw $v0, ten
	syscall


MULTIPLY:
	lw $t7, negtwelve
	lw $t6, one
	lw $t5, twelve
	add $sp, $sp, $t7
	sw $ra, 8($sp)
	sw $a0, 4($sp)
	sw $a1, 0($sp)
	
	
	add $t3, $zero, $t6 # t3 is 1
	add $t1, $a1, $zero # t1 is a1
	
	add $v1, $v1, $zero # v0 = 0 
	
	jal MULT
	
	lw $ra, 8($sp)
	lw $a0, 4($sp)
	lw $a1, 0($sp)
	add $sp, $sp, $t5
	
	
	jr $ra

	
	MULT:
		add $v1, $v1, $a0 # v0 += a
		sub $t1, $t1, $t3 # b--
		slt $t2, $t1, $t3 # return t1 < 1 
		bne $t2, $zero, END # if t1 < 1, GOTO END, else, MULT
		j MULT
	
	END:
		jr $ra
		
.data
	one: .word 1
	opA: .word 3
	opB: .word 2
	negtwelve: .word -12
	twelve: .word 12
	ten: .word 10
