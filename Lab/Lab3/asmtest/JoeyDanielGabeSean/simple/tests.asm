main:
  xori $t7, $zero, 1 # LW/SW flag
  xori $t0, $zero, 5
  sw $t0, 0x00007000
  lw $t1, 0x00007000
  bne $t0, $t1, error

  xori $t7, $zero, 2 # J flag
  xori $t0, $zero, 0
  xori $t1, $zero, 0
  j skipbad
  xori $t0, $t0, 999
  skipbad:
  bne $t0, $t1, error

  xori $t7, $zero, 3 # JR/JAL flag
  xori $t0, $zero, 0
  xori $t1, $zero, 1
  jal increment0
  bne $t0, $t1, error

  xori $t7, $zero, 4 # BNE flag
  xori $t0, $zero, 6
  xori $t1, $zero, 6
  bne $t0, $t1, error

  xori $t7, $zero, 5 # XORI flag
  xori $t0, $zero, 5
  xori $t1, $t0, 4
  bne $t1, 1, error
  xori $t0, $zero, 6
  xori $t1, $t0, 3
  bne $t1, 5, error
  xori $t0, $zero, 12
  xori $t1, $t0, 12
  bne $t1, 0, error

  xori $t7, $zero, 6 # ADD flag
  xori $t0, $zero, 200
  xori $t1, $zero, 300
  add $t2, $t0, $t1
  bne $t2, 500, error
  xori $t0, $zero, -100
  xori $t1, $zero, 0
  add $t2, $t0, $t1
  bne $t2, -100, error
  xori $t0, $zero, 128
  xori $t1, $zero, -128
  add $t2, $t0, $t1
  bne $t2, 0, error

  xori $t7, $zero, 7 # SUB flag
  xori $t0, $zero, 200
  xori $t1, $zero, 120
  sub $t2, $t0, $t1
  bne $t2, 80, error
  xori $t0, $zero, 500
  xori $t1, $zero, -100
  sub $t2, $t0, $t1
  bne $t2, 600, error
  xori $t0, $zero, -8
  xori $t1, $zero, 0
  sub $t2, $t0, $t1
  bne $t2, -8, error

  xori $t7, $zero, 8 # SLT flag
  xori $t0, $zero, 10
  xori $t1, $zero, 20
  slt $t2, $t0, $t1
  bne $t2, 1, error
  xori $t0, $zero, 5
  xori $t1, $zero, 3
  slt $t2, $t0, $t1
  bne $t2, 0, error
  xori $t0, $zero, -6
  xori $t1, $zero, 4
  slt $t2, $t0, $t1
  bne $t2, 1, error
  xori $t0, $zero, 10
  xori $t1, $zero, 10
  slt $t2, $t0, $t1
  bne $t2, 0, error
  
  j end

increment0:
  add $t0, $t0, 1
  jr $ra

error:
  add $v0, $t7, $zero

end:
