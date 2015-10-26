# CompArch Lab 2: SPI Memory

**Work Plan due:** Tue. October 27 end of day

**Midpoint Check In due:** Monday, November 2 at 5PM

**Lab due:** Monday, November 9 at 5PM

In this lab you will create an SPI Memory and instantiate it on FPGA.  You will also create an automated harness for End of Line testing.  You will then use your tester to verify your memory (and possibly the memories of the other groups in the class).  Finally, you will intentionally inject errors and detect failure modes.

<img src="https://e38023e2-a-62cb3a1a-s-sites.googlegroups.com/site/ca15fall/resources/lab2-arch.png" width=300 alt="System Diagram">

You will work in groups of ~3. You may shuffle teams if you so choose.

## Work Plan ##

Draft a work plan for this lab.  Break down the lab in to small portions, and for each portion predict how long it will take (in hours) and when it will be done by (date). Use your work plan reflection from Lab 1 to help with this task. 

Optional: read about [Evidence Based Scheduling](http://www.joelonsoftware.com/items/2007/10/26.html) for some of our rationale for collecting and reflecting on this information.

**Note:** If you think you will need an extension for this lab (e.g. due to approved travel), the work plan is the time to ask for it.

**Submit this plan by the end of the day Tuesday, October 27** by pushing `work_plan.txt` to GitHub. (Note: Markdown/PDF format also OK)

## Input Conditioning ##

The Input Conditioning subcircuit serves three purposes:

1. **Input Synchronization**:  The pair of D flip-flops at the front of this unit synchronize the external signal to the internal clock domain. The setup and hold requirements of the first flip-flop will likely be violated – its input can occur at any phase offset with respect to the internal oscillator.  The second flip-flop takes the partially synchronized signal and brings it fully into phase with the internal domain.

1. **Input Debouncing**:  Buttons and Switches are notoriously noisy, and may be unstable for several milliseconds after a transition due to mechanical oscillations.  Purely electrical signal sources may also show similar (but much less severe) oscillations due to noise and signal reflections.  This circuit cleans up that oscillation by waiting for it to stabilize. 

1. **Edge Detection**: These signals are asserted for a single clock cycle on each positive and negative edge of the external signal.  These are used by other subcircuits to emulate `@(posedge ___)` type behaviors without creating extra clock domains.

<img src="https://e38023e2-a-62cb3a1a-s-sites.googlegroups.com/site/ca15fall/resources/lab2-glitch.png" width=500 alt="Glitch Suppression and Edge Detection">

_Glitch Suppression and Edge Detection_

Start with the behavioral Verilog module provided in `inputconditioner.v`.

<img src="https://e38023e2-a-62cb3a1a-s-sites.googlegroups.com/site/ca15fall/resources/lab2-ic-box.png" width=300 alt="Input conditioner box diagram">

Modify the module so that the `positiveedge` and `negativeedge` signals are correctly generated. These signals should be high for exactly one clock period when `conditioned` has a positive/negative edge, in the same clock period that `conditioned` transitions.

Note: There are several possible ways to generate the edge signals. Remember that `assign` statements are continuous and operate on `wire`s, while assignments in `always` blocks (e.g. nonblocking `<=`) operate on `reg`s.

### Input Conditioner Deliverables ###
 - Complete module in `inputconditioner.v` 
 - Your test bench `inputconditioner.t.v` demonstrates the three Input Conditioner functions
 - Test script (`inputconditioner.do` or Linux equivalent). This script should execute the test bench, view appropriate signals and zoom the wave form to fit.
 - In your final report, include a circuit diagram of the structural circuit for the input conditioner. This should be drawn from primitives such as D flip-flops, adders, muxes, and basic gates.
 - If the main system clock is running at 50MHz, what is the maximum length input glitch that will be suppressed by this design for a `waittime` of 10?  Include the analysis in your report.

## Shift Register ##
Create a shift register supporting both "Serial In, Parallel Out" and "Parallel In, Serial Out" modes of operation.   It should have the following module definition:

```verilog
module shiftregister
#(parameter width = 8)
(
input               clk,                // FPGA Clock
input               peripheralClkEdge,  // Edge indicator
input               parallelLoad,       // 1 = Load shift reg with parallelDataIn
input  [width-1:0]  parallelDataIn,     // Load shift reg in parallel
input               serialDataIn,       // Load shift reg serially
output [width-1:0]  parallelDataOut,    // Shift reg data contents
output              serialDataOut       // Positive edge synchronized
);
```

The shift register is clocked by the main system oscillator `clk` running at 50MHz.  All behaviors are synchronous to this clock:

1. When the peripheral clock `peripheralClkEdge` has an edge, the shift register advances one position: `serialDataIn` is loaded into the LSB (Least Significant Bit), and the rest of the bits shift up by one.  This uses the Input Conditioner's edge detection capabilities.
1.  When `parallelLoad` is asserted, the shift register will take the value of `parallelDataIn`.
1. `serialDataOut` always presents the Most Significant Bit of the shift register.
1. `parallelDataOut` always presents the entirety of the contents of the shift register.

Each of these four behaviors can be implemented in one or two lines of behavioral Verilog.  You may want to look at Verilog's `{}` concatenate syntax for implementing the serial behavior.

It is good design practice to decide which behavior will "win" if a parallel load and a serial shift happen in the same clock edge.  Otherwise the synthesizer will make that decision for you (likely without a warning).

### Shift Register Deliverables ###
 - Complete module in `shiftregister.v`
 - Your test bench in `shiftregister.t.v` demonstrating both modes of operation for the shift register.
 - In your final report, you should describe your test bench strategy.


## Midpoint Check In ##

Create a top-level module with the following structure and load it onto the FPGA:

<img src="https://e38023e2-a-62cb3a1a-s-sites.googlegroups.com/site/ca15fall/resources/lab2-mid.png" width=500 alt="Midpoint Check In Structure">

The parallel load feature of the shift register is tied to a constant value, and is activated when button 0 is pressed.

Switches 0 and 1 allow manual control of the serial input.

LEDs show the state of the shift register (note: you only have 4 to work with, so you will have to show a subset of bits or use the Lab 0 trick)

### Loading to FPGA ###

The NINJAs have written a [quickstart guide](https://docs.google.com/document/d/1gCVD3G9wRk73NT843JtR1htCnbzCTgUvUQSzh4oTUGI/edit?usp=sharing) to help you load your SPI designs onto the Zybo and test them.

### Midpoint Deliverables ###

Push the module described above to GitHub as `midpoint.v`. Because testing will be done by hand, no Verilog test bench is required for this file.

Design a test sequence that demonstrates successful operation of this portion of the lab.  Provide a short written description of what the test engineer is to do, and what the state of the LEDs should be at each step.

Find a NINJA and show them your test being executed, and/or record a short (~60 seconds) video and submit the link.

**Midpoint Check In must be submitted by Monday, November 2 at 5PM.**


## SPI Memory ##

You now have everything you need to create a complete SPI memory. We will make it 128 bytes in size. It will have the following module definition:

```verilog
module spiMemory
(
    input           clk,        // FPGA clock
    input           sclk_pin,   // SPI clock
    input           cs_pin,     // SPI chip select
    output          miso_pin,   // SPI master in slave out
    input           mosi_pin,   // SPI master out slave in
    input           fault_pin,  // For fault injection testing
    output [3:0]    leds        // LEDs for debugging
)
```

The `SCLK`, `CS`, `MISO`, and `MOSI` signals obey the SPI standard. The Fault Injector will be used in the next section, we’re just scaffolding it in for now. The LED outputs are in case you need debugging information.

### Behavior ###

Each transaction begins with the Chip Select `CS` line being asserted `low`.  Whenever `CS` is `high`, the memory ignores all other inputs, tri-states `MISO`, and resets any communication state machines.  

Next, 8 bits are clocked in by the Master.  The first 7 bits are the memory address, Most Significant Bit first.  The 8th bit is the `R/~W` flag: Read when high, Write when low.

For a `Write` operation, the master will then clock in 8 bits of data and de-assert `CS`.

For a `Read` operation, the slave will assert `MISO` and clock out the data found at `address`.

Data is always presented on the falling edge, and always read on the rising edge of `SCLK`.

#### Write operation ####

<img src="https://e38023e2-a-62cb3a1a-s-sites.googlegroups.com/site/ca15fall/resources/lab2-write.png" alt="Write operation timing diagram">

#### Read operation ####

<img src="https://e38023e2-a-62cb3a1a-s-sites.googlegroups.com/site/ca15fall/resources/lab2-read.png" alt="Read operation timing diagram">

### Schematic ###

<img src="https://e38023e2-a-62cb3a1a-s-sites.googlegroups.com/site/ca15fall/resources/lab2-spi-schem.png" alt="SPI memory schematic">

This is a _recommended_ schematic for the SPI Memory.  The next few pages provide additional scaffolding for this design route, but you may choose to implement your SPI Memory by any means you find appropriate.  Stubbed signals are controlled by the Finite State Machine.  You may require additional signals as inputs to the FSM.  System Clock routed as a net label for clarity.

The Serial Out pin is synchronized to the falling edge of `SCLK` to obey the standard we are using (Data is presented on the falling edge, and captured on the rising edge).  

### Finite State Machine ###

This state machine provides the appropriate control signals to drive the schematic above.  It begins in `Get (address)`, where it waits for 8 `SCLK` strobes.  It then proceeds to the intermediate step `Got (address)`, where it grabs the address from the shift register.  This extra step provides an extra internal clock cycle for the shift register to finish its job and propagate the answer.  Based on the `R/~W` it then proceeds to `Read1` or `Write1`.

`Read1` is the cycle in which the Data Memory is read.  `Read2` follows immediately after and pushes that value into the shift register. It then enters `Done`, as the shift register will handle the rest of the Read Transaction.  In this incarnation further checking is not necessary, as we have not defined the behavior when more than 8 bits are read out.

`Write1` does count the number of bits strobed in, and when it reaches 8 it transitions to `Write2`.  `Write2` commits the data value to data memory.

If at any time `CS` is de-asserted (raised high), this state machine resets the counter to zero and the state to `Get`.  These transitions are suppressed in the diagram for clarity.  This is represented by the RESET line in the FSM description.

<img src="https://e38023e2-a-62cb3a1a-s-sites.googlegroups.com/site/ca15fall/resources/lab2-fsm.png" alt="SPI FSM">

<img src="https://e38023e2-a-62cb3a1a-s-sites.googlegroups.com/site/ca15fall/resources/lab2-fsm-table.PNG" alt="SPI FSM table">

### Load on FPGA ###

Repeat the process from the Midpoint Check In to instantiate your SPI memory on the FPGA and hook up the ports for test.

## SPI Memory Testing ##

In addition to the FPGA fabric, the Zynq chip on your board also contains an ARM processor. We will use this processor to test your SPI memory.

See the [NINJA quickstart guide](https://docs.google.com/document/d/1gCVD3G9wRk73NT843JtR1htCnbzCTgUvUQSzh4oTUGI/edit?usp=sharing) for more details. Run your test sequences and view the results by communicating with the ARM processor (i.e. using `xil_printf`). 

You may also optionally trigger your test sequence using the onboard buttons and report out results using the LEDs.

### Test Strategy ###
Your final report should include a detailed analysis of your testing strategy.  Why did you choose the test sequences you did?  

### External testing (optional) ###

You may also route your SPI port to the pins of the FPGA, and test it with an external device (such as an Arduino). Talk to the NINJAs if you're interested in this approach.

## Fault Injection ##

You now have a functioning SPI memory and a tester capable of confirming its behavior.  The final step is to break your memory and make sure that your tester can detect the failure.  This is known as "Fault Injection".

The failure mode you will be testing should simulate a manufacturing defect.  That is to say that the design is correct, but one of the thousands of copies coming off the line was damaged during manufacture.  Look through your design and identify a single gate or wire to break.  It can break by being stuck `high`, stuck `low`, or shorted to a nearby net.

Copy and modify your existing SPI memory so that it is now sensitive to the `fault_pin` signal.  When this is `low`, the memory should work correctly.  When it is `high`, the memory should exhibit the injected failure mode.

Connect the `fault_pin` signal to a switch on the board.  You should now have a device that will break at the flip of a switch.

When you modify your hierarchy, you'll need to propagate the fault injection signal.  In doing so, make sure not to break any of your existing modules.  Instead, create copies of those modules and append "_breakable" to their module name.  Add the fault signal as the last input to these breakable modules.  Place these breakable module definitions in the same file as their indestructible partners.

For example:

```verilog
module inputconditioner_breakable(clk, noisysignal, conditioned, positiveedge, negativeedge, faultactive);
```

### Fault Injection Deliverables ###

In your report, describe the fault you are injecting.  Include a schematic of the area local to the fault to better identify which gate or wire is broken.

Explain one specific test pattern that will identify this failure mode.

#### Example ####
> Our injectable failure mode is that the 1st  bit of the address bus is permanently 1.  This could occur if this D flip-flop (schematic) was broken during manufacturing.  We simulate this by ORing this signal with the fault injection signal.  This can be identified during test by noticing that adjacent memory locations have been merged.  For example, writing to address 10 affects address 11 as well.


## Notes/Hints ##

### Input Conditioning ###

You may need to adjust your deglitching wait period differently for when it is driven by switches vs when it is driven by the tester.  Switches are much noisier.

### Autograde Etiquette ##

The autograder will compile all Verilog files that are in your repository.  This means that things like `InputConditioner_OLD.v` may cause naming conflicts if they have the same modules inside.  Make sure that you do not have multiple modules with the same name.

### Do File Enhancements ###

To change ModelSim's tab spacing, use the following command: `set PrefSource(tabs) 4`. This can be done in the command window or added to your do-files.

The following commands flush the work library.  This makes issues associated with stale module definitions fail sooner with better error messages:

```
vdel -lib work -all
vlib work 
```

The first command will fail if the library does not exist yet.  You may need to manually execute the second one when you create a new project.

### FPGA Synthesis Preparation ###

Make sure that each of your always blocks' sensitivity lists are only `always @(posedge clk)`.  Other sensitivity lists may cause clock gating.

The Xilinx synthesizer obeys the `initial` block syntax with varying degrees of success.  To initialize a register, do so in its declaration: `reg regname = 0;`. This technique does not work with 2 dimensional arrays.

### FSM Debugging ###
ModelSim doesn’t have enumeration support.  To make your debugging life a little easier, define your state machine states with parameters and virtual signals.

Using parameters local to the module that uses the states keeps your name space a little cleaner.

```verilog
parameter state_GETTING_ADDRESS 	= 0;
parameter state_GOT_ADDRESS 	    = 1;
parameter state_READ_1 		        = 2;
parameter state_READ_2	 	        = 3;
```

In your .do file you can define a virtual type:

```
virtual type {{0 GET} {1 GOT} {2 READ} {3 READ2} {4 DONE}} state_type
virtual function {(state_type) /spiMemoryTest/spim/state} state_virtual
add wave -position insertpoint  \
sim:/spiMemoryTest/spim/state_virtual
```

This syntax creates virtual type `state_type`, where `0` is mapped to `GET`, `1` is mapped to `GOT` and so on.  The next line copies the state machine state as a new virtual signal with the type `state_type`.  This gets injected into the simulation GUI, where you can then plot it like a normal signal.
 
<img src="https://e38023e2-a-62cb3a1a-s-sites.googlegroups.com/site/ca15fall/resources/lab2-msimgui.png" alt="ModelSim virtual type">
 
You will need to keep the parameter and virtual definitions synchronized by hand.

