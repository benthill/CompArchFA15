# Assembly Test Suite

#### Expected Test Results
* `$v0 == 0` means everything passed
* `$v0 == 1` means LW/SW failed
* `$v0 == 2` means J failed
* `$v0 == 3` means JR/JAL failed
* `$v0 == 4` means BNE failed
* `$v0 == 5` means XORI failed
* `$v0 == 6` means ADD failed
* `$v0 == 7` means SUB failed
* `$v0 == 8` means SLT failed

#### Memory Layout Requirements
None, but if testing in Mars, make sure to go to `Settings -> Memory Configuration... -> Compact, Text at Address 0 -> Apply and Close`

#### Non-Subset Instructions Used
None
