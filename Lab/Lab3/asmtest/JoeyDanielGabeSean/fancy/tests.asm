.data
  successmsg: .asciiz "All test cases passed succesfully."
  errormsgs:
    m0: .asciiz "Error: LW/SW test case(s) failed."
    m1: .asciiz "Error: J test case(s) failed."
    m2: .asciiz "Error: JR/JAL test case(s) failed."
    m3: .asciiz "Error: BNE test case(s) failed."
    m4: .asciiz "Error: XORI test case(s) failed."
    m5: .asciiz "Error: ADD test case(s) failed."
    m6: .asciiz "Error: SUB test case(s) failed."
    m7: .asciiz "Error: SLT test case(s) failed."
  erroraddrs:
    .word m0
    .word m1
    .word m2
    .word m3
    .word m4
    .word m5
    .word m6
    .word m7
    .word 0


.text
main:
  li $t6, 0 # LW/SW flag
  li $t0, 5
  sw $t0, 0x00007000
  lw $t1, 0x00007000
  bne $t0, $t1, error
  li $t0, 8
  sw $t0, 0x00007004
  lw $t1, 0x00007004
  bne $t0, $t1, error

  li $t6, 1 # J flag
  li $t0, 0
  li $t1, 0
  j skipbad
  addiu $t0, $t0, 999
  skipbad:
  bne $t0, $t1, error

  li $t6, 2 # JR/JAL flag
  li $t0, 0
  li $t1, 1
  jal increment0
  bne $t0, $t1, error

  li $t6, 3 # BNE flag
  li $t0, 7
  li $t1, 7
  bne $t0, $t1, error

  li $t6, 4 # XORI flag
  li $t0, 0x5
  xori $t1, $t0, 0x4
  bne $t1, 0x1, error
  li $t0, 0x6
  xori $t1, $t0, 0x3
  bne $t1, 0x5, error
  li $t0, 0x12
  xori $t1, $t0, 0x12
  bne $t1, 0x0, error
  
  li $t6, 5 # ADD flag
  li $t1, 100
  li $t2, 200
  add $t0, $t1, $t2
  bne $t0, 300, error
  li $t1, 150
  li $t2, 250
  add $t0, $t1, $t2
  bne $t0, 400, error
  li $t2, -100
  add $t0, $zero, $t2
  bne $t0, -100, error
  li $t1, 244
  li $t2, -244
  add $t0, $t1, $t2
  bne $t0, 0, error

  li $t6, 6 # SUB flag
  li $t1, 200
  li $t2, 0
  sub $t0, $t1, $t2
  bne $t0, 200, error
  li $t0, 200
  subi $t0, $t0, 120
  bne $t0, 80, error
  li $t1, 5000
  li $t2, -1000
  sub $t0, $t1, $t2
  bne $t0, 6000, error
  li $t1, -10
  sub $t0, $t1, $t1
  bne $t0, 0, error

  li $t6, 7 # SLT flag
  li $t1, 100
  li $t2, 200
  slt $t0, $t1, $t2
  bne $t0, 1, error
  li $t1, 200
  li $t2, 100
  slt $t0, $t1, $t2
  bne $t0, 0, error
  li $t1, -100
  li $t2, 50
  slt $t0, $t1, $t2
  bne $t0, 1, error
  li $t1, -10
  li $t2, 10
  slt $t0, $t1, $t2
  bne $t0, 1, error
  li $t1, 5
  li $t2, 5
  slt $t0, $t1, $t2
  bne $t0, 0, error

  # show off success
  li $v0, 4 # flag for syscall to print a string
  la $a0, successmsg # value to print
  syscall
  j end

increment0:
  addiu $t0, $t0, 1
  jr $ra

error:
  li $v0, 4 # flag for syscall to print a string
  sll $t6, $t6, 2 # multiply our case flag by 4 to align to word boundaries
  lw $t7, erroraddrs($t6) # get the error message corresponding to the case
  la $a0, ($t7) # load it into the right register
  syscall # perform the operation we set up

end:
