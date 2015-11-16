add $a0, $zero, 6
add $a1, $zero, 8
xori $v1, $a0, 1 #random result
slt $v0, $a0, $v1 #random result

jal FIRST_STEP
j END

FIRST_STEP:
	sub $sp, $sp, $a1
	sw $a0, 4($sp)
	sw $ra, 0($sp)
	bne $a0, $a1, NEXT_STEP
	
NEXT_STEP:
	lw $t1, 4($sp)
	lw $ra, 0($sp)
	add $sp, $sp, $a1
	jr $ra
	
END: 
	syscall