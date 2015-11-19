lw $t0, numberRun
xori $t1, $zero, 200
jal sectionOne
j endScript


sectionOne:
        slt $t2, $t1, $t0
        bne $t2, $zero, sectionTwo
	sub $t1, $t1, $t0
	sub $t0, $t0, 1
	bne $t0, $zero, sectionOne
	jr $ra
	
sectionTwo:
	slt $t2, $t0, $t1
	bne $t2, $zero, sectionOne
	add $t1, $t1, $t0
	sub $t0, $t0, 1
	bne $t0, $zero, sectionTwo
	jr $ra

endScript:
	sw $t1, finalCount
	
.data
	numberRun: .word 15
	finalCount: .word 0
