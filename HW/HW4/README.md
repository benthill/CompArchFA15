# CompArch HW b0100: Register File #

**Due:** Wednesday, October 28 at 5pm

This homework is intended to introduce behavioral Verilog and practice test bench design. You will create your first memory, a register file, which will be reused in your CPU design.

Homework is to be completed individually.  If you seek help from another individual, note that per deliverable.


## The Register File ##
The register file is an extremely small, extremely fast memory at the heart of your CPU.  They vary per architecture, but you will create one with the following specifications:

 - Width: 32 bits
 - Depth: 32 words
 - Write Port: Synchronous, Positive Edge Triggered
 - Read Port 1: Asynchronous
 - Read Port 2: Asynchronous
 
We are mimicking the MIPS architecture, which has one unusual feature in its register file:  The first "register" is actually just the constant value zero.  We will exploit this oddity later when we write assembly programs for the processor.

The overall structure of the register file is shown below.  The core is the 32-bit registers: 31 normal registers and a constant zero.  The read ports are a pair of giant multiplexers connected to the register outputs.  The write port connects to the input of all registers, and a decoder optionally enables one register to be written.  This homework will build these units incrementally in behavioral Verilog (wrapped in structural shells), and then assemble them to create the full register file.
 
<img src="https://e38023e2-a-62cb3a1a-s-sites.googlegroups.com/site/ca15fall/resources/regfile.png?attachauth=ANoY7coxaffMnfwuftWJOBUSY8OdyOcpfSRp2MJMGS76O8AVIidsNCLx2synldoGKALHHXlA4n5YorYntr0jQ-oBuUX0N1rVOQOnK8ZmJ25513iH3ek-2tkEb28NN1C9iUZRQVvt4zpwB1txBKiNLXSDQ8Rb2GYo5VZNyvINrXv4SBmqHK5VPNngT5WzEyJapUDCQPcL86zR-MMyb1fKthgwZ8Q-6Y8JUg%3D%3D&attredirects=0" alt="Register File diagram">
 
## Register ##

It is critically important to write registers in Behavioral Verilog so that the synthesizer can figure out what to do.  
Here is the behavioral description of a D Flip Flop with enable, positive edge triggered: 

```verilog
module register
(
output reg	q,
input		d,
input		wrenable,
input		clk
);
    always @(posedge clk) begin
        if(wrenable) begin
            q = d;
        end
    end
endmodule
```

Note the enable logic.  It may feel more natural to instead “gate the clock” like this:

```verilog
always @(posedge (clk & wrenable)) begin
	q = d;
end
```

Theoretically this would work – the clock signal would be steady `FALSE` when disabled, and only have positive edges when enabled.  However, "gating the clock" is a bad idea in practice – what happens if that enable signal has glitches?  Additionally, FPGAs are typically designed to only support a few distinct clocks.

### Deliverable 1 ###
Draw a circuit diagram showing the structural equivalent for each of the two register implementations above. You may use primitives such as the D Flip-Flop, MUX, decoder, and basic logic gates.

### Deliverable 2 ###
Create a module named `register32`.  This module should exactly match the `register` definition above, but with 32 bits worth of D Flip Flops (`d` and `q` ports should increase width accordingly).  If you’d like, try parameterizing this width.

### Deliverable 3 ###

Create a module named `register32zero`.  This module should match the port definition above, but instead of storing data it should ignore its inputs and always output zero.


## Behavioral Muxes ##

Behavioral Verilog makes it very easy to create a multiplexer through its array syntax.  This array syntax is very similar to that of the procedural languages (e.g. MATLAB, Python, C, Java, etc) you may already be familiar:

```verilog
wire[31:0]	inputsofmux;
wire		outputofmux;
assign outputofmux=inputsofmux[address];
```

### Deliverable 4 ###
Create a 32:1 multiplexer with the following module definition:

```verilog
module mux32to1by1
(
output		out,
input[4:0]	address,
input[31:0]	inputs
);
  // Your code
endmodule
```

### Deliverable 5 ###

Create a multiplexer that is 32 bits wide and 32 inputs deep.  There are many syntaxes available to do so, and each of them have their own little bit of excitement.  The version below has more typing involved than other options, but it will allow better flexibility later.  Match the following module port definition:

```verilog
module mux32to1by32
(
output[31:0]	out,
input[4:0]		address,
input[31:0]		input0, input1, input2, ..., input31
);

  wire[31:0] mux[31:0];			// Create a 2D array of wires
  assign mux[0] = input0;		// Connect the sources of the array
  // Repeat 31 times...
  assign out = mux[address];	// Connect the output of the array
endmodule
```

## Decoder ##

The decoder selects which register of the register file is being written to.  Here is the full definition:

```verilog
module decoder1to32
(
output[31:0]	out,
input			enable,
input[4:0]		address
);
    assign out = enable<<address; 
endmodule
```

### Deliverable 6 ###

Provide a brief written description of how the above module works. How does this behavioral Verilog result in a decoder?

## Stitch it all together ##

You now have all the components necessary to create your register file.  Use the following module definition and structure to create your register file:

```verilog
module regfile
(
output[31:0]	ReadData1,		// Contents of first register read
output[31:0]	ReadData2,		// Contents of second register read
input[31:0]		WriteData,		// Contents to write to register
input[4:0]		ReadRegister1,	// Address of first register to read
input[4:0]		ReadRegister2,	// Address of second register to read
input[4:0]		WriteRegister,	// Address of register to write
input			RegWrite,		// Enable writing of register when High
input			Clk				// Clock (Positive Edge Triggered)
);
```                    

### Deliverable 7 ###
Submit Verilog files that containing your register file and all supporting modules.  Note that Deliverable 8 will help you with this.

### Deliverable 8 ###
Expand the provided test bench to classify the following register files:

1. A fully perfect register file.  Return True when this is detected, false for all others.
1. Write Enable is broken / ignored – Register is always written to.
1. Decoder is broken – All registers are written to.
1. Register Zero is actually a register instead of the constant value zero.
1. Port 2 is broken and always reads register 17.

These will be graded by instantiating intentionally broken register files with your tester.  Your tester must return true (works!) or false (broken!) as appropriate.

It is to your advantage to test more than just these cases to better ensure that your good register file is actually good.  However, those further tests do not need to be submitted.

## Submission ##

Push your work to GitHub, including:
 - Verilog: top-level `regfile.v` and any supporting files
 - Test benches: `regfile.t.v` and any other testing files
 - Scripts to run your tests
 - Writing/drawing for deliverables 1 and 6

## Rubric ##
Code portions of this assignment will be graded automatically by scripts.  It is therefore critical to follow the module definitions exactly – same port definitions, same names.
No partial credit will be given for these portions.

| Deliverable |	Weight | Grading |
|-------------|--------|---------|
| 1 |	10	| Manual |
| 2	| 5	| Automatic |
| 3	| 5	| Automatic |
| 4	| 10	| Automatic |
| 5	| 10	| Automatic |
| 6	| 10	| Manual |
| 7	| 25	| Automatic |
| 8	| 25	| Automatic |
|  Total |	100	| |

## Notes ##
We are not doing any time delay related analysis for this assignment.  Please do not include time delays.

