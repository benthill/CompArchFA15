# CompArch Lab 1: Arithmetic Logic Unit

**Work plan due:** Wed. October 7 at 2PM

**Lab due:** ~~Wed. October 14~~ Thu. October 15 at 5PM


This lab assignment creates the first component of your processor: the ALU.  Additionally, it will help you understand the timing constraints of your designs.

You will work in groups of ~3. You may shuffle teams from the first lab if you so choose. 

## Specification ##

The ALU you will implement is a subset of the standard MIPS ALU. The number of operations supported has been reduced, but otherwise we are emulating that standard.

<img src="https://e38023e2-a-62cb3a1a-s-sites.googlegroups.com/site/ca15fall/resources/alu.png" width="200" alt="ALU diagram">


| Operation	| Result 		| Sets flags?	| ALU Control 	|
|-----------|---------------|---------------|---------------|
| ADD		| `R=A+B`		| Yes			| `b000`		|
| SUB		| `R=A-B`		| Yes			| `b001`		|
| XOR		| `R=A^B`		| No			| `b010`		|
| SLT		| `R=(A<B)?1:0`	| No			| `b011`		|
| AND		| `R=A&B`		| No			| `b100`		|
| NAND		| `R=~(A&B)`	| No			| `b101`		|
| NOR		| `R=~(A|B)`	| No			| `b110`		|
| OR		| `R=A|B`		| No			| `b111`		|


Each group will construct ALUs with identical behaviors, but the internal structures will vary based on the design decisions you each make.

The ALU must be implemented in `alu.v`, and its top-level module must have the following definition:

```verilog
module ALU
(
output[31:0] 	result,
output 			carryout,
output 			zero,
output 			overflow,
input[31:0] 	operandA,
input[31:0]		operandB,
input[2:0]		command
);
	// Your code here
endmodule
```

## Work Plan ##

Draft a work plan for this lab.  Break down the lab in to small portions, and for each portion predict how long it will take (in hours) and when it will be done by (date).  You will be comparing your predictions to reality later.

**Submit this plan by 2PM on Wednesday, October 7** by pushing `work_plan.txt` to GitHub.

## Deliverables ##

### Verilog ###
Construct an ALU that implements the specification above.  We recommend that you use a "Bitslice + Control Logic LUT" approach to designing your ALU.

You must use structural Verilog (basic gates and modules wired together) for your ALU, with the exception of the Control Logic LUT.  You may use behavioral Verilog to describe this Look Up Table (see the Notes section below for details).

You may freely reuse code created for previous labs and homeworks.  **Be sure to redo the timing!**

#### Gate Delays ####

In order to be slightly more accurate, we will model gate delay as proportional to the number of inputs in the gate.  Standardize on 10 units per input.  Therefore, an inverter has delay 10, a 32-input NAND gate has delay 320.  The basic gates are NAND, NOR, NOT. Gates such as AND, OR, etc all have "hidden" inverters that must be accounted for in your propagation delays.

#### Documentation ####
Code legibility and commenting matter! The key is to make sure that your code is "inheritable" – another designer should be able to understand what you were up to without re-inventing it. Use block comments at the top of your modules, and occasional comments within modules where appropriate to describe interesting details.  


### Test Benches ###
Construct a (set of) test bench(es) for your ALU.  It is highly recommended that you create the tests before you create the ALU.

Be intelligent in your selection of your test cases. Making use of the hierarchy of your design will allow you to avoid exhaustive testing.



### Report ###
In this lab your team is designing the ALU subsystem. Write a report to the project manager in charge of the entire CPU demonstrating that your ALU design is complete, correct, and ready to be included in the CPU.

#### Implementation ####

Discuss any interesting design choices you made along the way.

Include block diagrams of your ALU at an appropriate level of detail: the top-level diagram above is too abstract to say anything about your particular design, while a single figure with every AND gate and wire would be unintelligible. Use your hierarchy and organization to show the important pieces. If you took a Bitslice approach, you should show a single bit and how they fit together.

#### Test Results ####
For each ALU operation, include the following in your report:
1. A written description of what tests you chose, and why you chose them.  This should be roughly a paragraph or two per operation.
1. Specific instances where your test bench caught a flaw in your design.
1. As your ALU design evolves, you may find that new test cases should be added to your test bench.  This is a good thing.  When this happens, record specifically why these tests were added. 


#### Timing Analysis ####
Provide the worst case propagation delay for each of the operations of the ALU.  This can be calculated or simulated (preferably both).  Note: the propagation delay for some operations depends heavily on your choice of operands.

#### Work Plan Reflection ####
Compare how long each unit work actually took to how long you predicted it would take.  This will help you better schedule future labs.


## Submission ##
Push your files to your team GitHub repository (the one listed on the team formation spreadsheet). It should include the following:

1. Work plan (due 10/7)
1. Report, as a self-contained PDF or MarkDown file
1. ALU Verilog, with the specified top-level module in `alu.v`
1. Test benches
1. Any do files or scripts used for testing


## Hints/Notes ##

### Define ###
You can use the define syntax to make your code cleaner.  For example, consider labeling your ALU commands with defines:

```verilog
`define ADD  3'd0
`define SUB  3'd1
`define XOR  3'd2
`define SLT  3'd3
`define AND  3'd4
`define NAND 3'd5
`define NOR  3'd6
`define OR   3'd7
```

### Control Logic LUT ###

A useful approach for implementing complex systems in a CPU is to separate the datapath (regular, possibly bit-sliced) from the control (irregular). You may choose to implement the control logic in your ALU as a Look Up Table. One way to implement this in (behavioral) Verilog is below:

```verilog
module ALUcontrolLUT
(
output reg[2:0] 	muxindex,
output reg	invertB,
output reg	othercontrolsignal,
...
input[2:0]	ALUcommand
)

  always @(ALUcommand) begin
    case (ALUcommand)
      `ADD:  begin muxindex = 0; invertB=0; othercontrolsignal = ?; end    
      `SUB:  begin muxindex = 0; invertB=1; othercontrolsignal = ?; end
      `XOR:  begin muxindex = 1; invertB=0; othercontrolsignal = ?; end    
      `SLT:  begin muxindex = 2; invertB=?; othercontrolsignal = ?; end
      `AND:  begin muxindex = 3; invertB=?; othercontrolsignal = ?; end    
      `NAND: begin muxindex = 3; invertB=?; othercontrolsignal = ?; end
      `NOR:  begin muxindex = ?; invertB=?; othercontrolsignal = ?; end    
      `OR:   begin muxindex = ?; invertB=?; othercontrolsignal = ?; end
    endcase
  end
endmodule
```

An advantage of this syntax is that it explicitly states what each control signal does for each command.

To add additional control signals: modify the module definition, add the corresponding `output reg` lines, and add the state of the lines in each case. Be careful to set each control signal in each case.  If you accidentally omit one, it will generate latches that you don’t want to implement the behavior that you don’t want.

### Overflow ###
Only ADD and SUB emit overflow signals per the MIPS specification.  The basic Boolean operations do not emit an overflow signal for obvious reasons, and during these operations that wire is always `false`.

The SLT operation is a bit weird here.  To calculate SLT you do need to determine whether or not there was an overflow.  However, in SLT this signal is not propagated outside of the ALU.  This is because the processor interprets the overflow signal as an "emergency" situation and begins an exception handling process.  Overflows generated during SLT are expected and are not emergencies.

