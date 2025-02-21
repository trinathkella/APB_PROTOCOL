# APB_PROTOCOL (Advanced Peripheral Bus)

1. APB is part of **AMBA (Advanced Microcontroller Bus Architecture)**, which was developed by ARM.
2. It's specifically used for peripheral control and register access.
3. APB is a synchronous and non pipilined protocol.
4. APB is mainly used for connecting low bandwidth peripherals with the SOCs.
5. Mainly works in two states, setup and access phase.
6. In "Setup Phase", particular operation has to be selected, like read or write.
7. In "Access Phase" the operation is done.
8. Transfer is complete when ready signal is asserted high for read or write.
9. If ready is not asserted, Master has to be in the wait state.

