#is_prime checks if a number, N, is prime by going through all number up to N and seeing if any of those are factors of N
# $a0 is N
# $t0 is a possible factor of N
# $t1 is a multiple of $t0

# test
addi $a0, $zero, 317

# initializing $t0 - a possible factor of N
addi $t0, $zero, 1

# base cases - if N is 0 or 1 - branch to NOTPRIME
beq $a0, 0 NOTPRIME
beq $a0, 1 NOTPRIME 

# increment possible factor and check if prime
NEXT_FACT:
addi $t0, $t0, 1
beq $t0, $a0, PRIME # branch to PRIME if $t0 makes it to $a0 without triggering NOTPRIME
add $t1, $t0, $zero # initialize $t1 as $t0

# loop through all multiples of $t0 up to N and branch back to NEXT_FACT if a multiple of $t0 is greater than N and $t1 is less than N
ADD_LOOP:
add $t1, $t1, $t0
blt $t1, $a0, ADD_LOOP
beq $t1, $a0, NOTPRIME
bgt $t1, $a0, NEXT_FACT

# return '0xa' if N is not prime
NOTPRIME:
addi $v0, $zero, 0xa
j END

# return '0xb' N is prime
PRIME:
addi $v0, $zero, 0xb

END:
