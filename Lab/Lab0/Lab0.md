# CompArch Lab 0: Full Adder on FPGA

**Due:** October 2 at 5pm

This lab assignment will develop one of the basic building blocks for your processor and introduce you to FPGAs.  

You should complete HW2 before beginning this lab.  Lab 0 depends on building blocks created in HW2.

You will work in groups of 3. If you have not yet formed a group, do so on the team formation spreadsheet (link is on Piazza).

## Setup ##

Install the required software by following the instructions on the [course website](https://sites.google.com/site/ca15fall/resources/fpga#TOC-Software).

Check out an FPGA kit for your team.

## Verify FPGA Tool Chain

This portion of the exercise is not collected.  It is intended only to verify that your full tool chain is correctly configured, and will save you headache later.

The easiest way to accomplish this is to attend the FPGA tutorial given by the NINJAs: **Thursday 9/24 at 7pm in the library lower level**.

Ensure that the switches, buttons, and LEDs on your FPGA board are functional. You may want to try instantiating various gates for additional practice.

## 4 bit Full Adder - ModelSim
In HW2 you constructed several modules in Structural Verilog and then tested them with ModelSim’s simulator.  Re-use the Full Adder component to create a 4 bit Full Adder.

This module should have the following definition:

```verilog
module FullAdder4bit(sum, carryout, overflow, a, b);
  output[3:0] sum;	// 2’s complement sum of a and b
  output carryout;	// Carry out of the summation of a and b
  output overflow;	// True if the calculation resulted in an overflow
  input[3:0] a;		// First operand in 2’s complement format
  input[3:0] b;		// Second operand in 2’s complement format
    // Your Code Here
endmodule

```

Your code will be verified by our own test bench, so it is critical your module definition and name matches.

Within this module, you will need to instantiate four of your single bit full adders and then appropriately wire them.  Reference a single bit of a bus with the bracket operator:  the first (least significant) bit of `a` is `a[0]`.

Each of the gates within your design should have a delay of 50 units of time.


## Test Bench - ModelSim

Create a test bench that exercises your 4 bit full adder, and verifies proper operation of its three outputs (Sum, Carry Out, Overflow).  It is probably in your best interest to write this at the same time you write the module that it tests.

An exhaustive test requires 2<sup>(4+4)</sup>= 256 test cases. Select a subset of those test cases that provides an appropriate level of coverage.  It may be helpful for you to explicitly document what each subset of test cases are testing.  For example, select several test cases that test the overflow flag and preface them with `$display(“Test Overflow:”);`.

**When a test case fails, a well-designed tester should make it easy to identify possible locations of the cause.**

Each time that your test bench catches an error in your design, document it in your write-up.  Include the test case, the cause of the error, and the fix that made the test case pass.

Note that your test bench will need to account for the gate delays in your design.  After setting the inputs, be sure to wait sufficiently long for the result to stabilize.


## Full Adder on FPGA

Load your tested 4 bit full adder design onto the FPGA board. 

**_ Detailed instructions coming soon _**

Verify correct operation by manually inputting test cases with the switches and buttons and examining the result on the LEDs.  Choose 16 test cases that provide a reasonable amount of coverage – you’ve already tested the design in ModelSim, so you do not need to provide the same level of coverage again.

Provide a photo of your FPGA correctly computing one of the 16 test cases you chose.

In your writeup include the full 16 test cases, why you chose them and their results.


## Report
Create a semi-formal lab report.  Minimally, it should include the following:

1.	Waveforms showing the full adder stabilizing after changing inputs.  What is the worst case delay?
1.	An explanation of your test case strategy.  Why did you choose the tests you did?
1.	A list of test case failures and the changes to your design they inspired.
1.	A summary of testing performed on the FPGA board.
1.	Summary statistics of your synthesized design (Propagation Delay, Resources Used, etc)

You may optionally include additional information, such as the timing performance or design tradeoffs of your modules.

The report should be a single PDF or MarkDown file.


## Submission
Push your files to your team GitHub repository (the one you listed on the team formation spreadsheet). It should include the following:

1.	Your report, as a PDF or MarkDown file
1.	Verilog code for
    1.	1 bit full adder
    1.	4 bit full adder
    1.	4 bit full adder test bench
    1.	The top level module for synthesis onto the FPGA
1.	Associated `do` file


## Hints
Now that we have signals that are more than 1 bit wide, it makes sense to refer to them using buses.  This allows us to reference all of the related bits in a convenient manner. 

If ModelSim gives really cryptic errors about missing declarations that aren’t actually missing, look at the module above to see if you missed an `end`.

## Rubric

<table>
<tr><td><b>Adder Functionality</b></td><td>	<b>25</b></td></tr>
<tr><td>Sum	</td><td>15</td></tr>
<tr><td>Carry Out, Overflow	</td><td>5</td></tr>
<tr><td>Gate Delays</td><td>5</td></tr>
<tr><td/><td/></tr>
<tr><td/><td/></tr>

<tr><td><b>Test Bench</b></td><td>	<b>	15	</b></td></tr>
<tr><td>Verifies Sum</td><td>5</td></tr>
<tr><td>Verifies Carryout</td><td>5</td></tr>
<tr><td>Verifies Overflow</td><td>5</td></tr>
<tr><td/><td/></tr>
<tr><td/><td/></tr>

<tr><td><b>FPGA</b> (Verified in report)</td><td><b>20</b></td></tr>
<tr><td>Tutorial / Verify tool chain</td><td>0</td></tr>
<tr><td>16 test cases are well chosen</td><td>10</td></tr>
<tr><td>Pass 16 test cases</td><td>5</td></tr>
<tr><td>Summary statistics</td><td>5</td></tr>
<tr><td/><td/></tr>

<tr><td><b>Report</b></td><td><b>35</b></td></tr>
<tr><td>Timing waveforms explained</td><td>5</td></tr>
<tr><td>Test bench explanation</td><td>20</td></tr>
<tr><td>Test bench failures / resulting changes</td><td>10</td></tr>
<tr><td/><td/></tr>
<tr><td/><td/></tr>

<tr><td> <b> Code commented</b> (Nice but not excessive)</td><td><b>5</b></td></tr>
</table>
