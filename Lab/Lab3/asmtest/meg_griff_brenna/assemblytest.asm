#Test
#MUST USE: LW, J, JR, JAL, BNE, XORI, ADD, SUB, SLT 

li $t0, 1
li $t1, 2           
li $t2, 3
li $t3, 4

jumplocation: 
add $t4, $t0, $t1  #$t4 should be set to 3   Adds values from t0 and t1 and stores result in t4
sub $t5, $t2, $t1	#t5 should be set to  1  Subtracts t1 value from t2value  and stores result in t5
slt $t6, $t4, $t5	#$t6 should be set to 0  Checks if t4 is < t5. if TRUE: set t6 to 1, if FALSE: set t7 to 0
la $t7, ($t3)		#$t7 should equal 4 loads value of $t3 to $t7
lw $t0, 4($sp)		#loads stackpointer+4 memory value to $t0 (this will be 0 if we have not yet stored anything in this stack location)   
sw $t1, 0($sp)		#stores value at $t1 to stackpointer location
li $t2 0
bne $t4, 3, branchlocation
j jumplocation	#second time $t4 should be set to 2 instead of 3, $t5 should be set to -2 instead of 1, $t6 should still be 0

branchlocation: #Should branch after 2nd time
xori $s0, $t2, 2  #s0 should be set to 02
jal jumpandlinklocation

add $s2, $s0, $s1 #s2 should be set to 6 ($s0 + $s1 = 2+4 = 6)

#End 
li $v0, 10
syscall 

jumpandlinklocation: add $s1, $t6, $t7 #s1 should be set to 4 ($t6 + $t7 = 0 +4)
jr $ra  #return to $ra (line after jal)
      
       
   