# APB_PROTOCOL (Advanced Peripheral Bus)

APB is part of "AMBA (Advanced Microcontroller Bus Architecture)", which was developed by ARM.
It's specifically used for peripheral control and register access.
APB is a synchronous and non pipilined protocol.
APB is mainly used for connecting low bandwidth peripherals with the SOCs.
Mainly works in two states, setup and access phase.
In "Setup Phase", particular operation has to be selected, like read or write.
In "Access Phase" the operation is done.
Transfer is complete when ready signal is asserted high for read or write.
If ready is not asserted, Master has to be in the wait state.

