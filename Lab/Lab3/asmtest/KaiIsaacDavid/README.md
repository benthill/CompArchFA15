Divide
=======

This assembly program computes the result of an integer division. The quotient will be stored in register $v0 and the remainder will be put into register $v1. The program only uses operations listed in the lab instructions, so it should be able to run on any group's cpu.

In order to compute different results, change the values that are stored in registers $a0 and $a1. This can be done by modifying lines 14 and 15. The result is computed by dividing $a0 by $a1.

```verilog
# will compute 43 / 7
xori $a0, $zero, 43 # line 14
xori $a1, $zero, 7  # line 15
```
