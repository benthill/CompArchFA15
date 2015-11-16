# Lab3 Test Program: Multiplication

This program multiplies two integers (by default 2 and 3), stores the result to memory and compares the result to the expected value. It also compares the result to a prime number (some number that is not the expected result).

##Expected Result

The output of the program is a XORI zero flag that checks if the result of multiplication matches the expected result. The result of the multiplication is stored to $s0, while the value of the XORI with the expected result is stored to $s1. When the result is correct, the output of the program is going to be “0”. The program then does an XORI between the result of the multiplication and a prime number (7) and stores the value to $s2. This result should should be "1". 

##Memory Requirements  

```
.data
	one: .word 1
	opA: .word 3
	opB: .word 2
	negtwelve: .word -12
	twelve: .word 12
	ten: .word 10
  ```
## Extra Instructions
`syscall` is used to exit the program.
