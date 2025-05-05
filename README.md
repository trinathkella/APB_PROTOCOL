# APB Protocol (Advanced Peripheral Bus)

The **Advanced Peripheral Bus (APB)** is a part of ARM's **AMBA (Advanced Microcontroller Bus Architecture)** family. It is specifically designed for connecting low-bandwidth, low-power peripherals in a System-on-Chip (SoC) environment.

---

## Key Characteristics
1. Synchronous protocol
2. Non-pipelined architecture
3. Low power and low complexity
4. Primarily used for register-level access to peripherals

## Common Use Cases
APB is best suited for interfacing with peripherals such as:
- UART
- Timers
- GPIO
- SPI
- Watchdog timers

## APB Transfer Phases
Each APB transfer occurs in ## Two phases:

### 1.Setup Phase
- Master sets up:
  - Address (`PADDR`)
  - Control signals (`PWRITE`, `PSEL`)
  - Write data (`PWDATA`) if applicable
- The slave prepares for the transfer

### 2.Access Phase
- Master asserts `PENABLE`
- Data is either:
  - Written to the slave (if `PWRITE = 1`)
  - Read from the slave (if `PWRITE = 0`)

The transfer completes when the slave asserts `PREADY = 1`.

## Transfer Control
_______________________________________________________
| Signal    | Description                             |
|-----------|-----------------------------------------|
| `PADDR`   | Address bus                             |
| `PWRITE`  | Write enable (1 = write, 0 = read)      |
| `PWDATA`  | Data to write to the slave              |
| `PRDATA`  | Data read from the slave                |
| `PSEL`    | Peripheral select                       |
| `PENABLE` | Indicates Access phase                  |
| `PREADY`  | Slave ready to complete the transfer    |
| `PSLVERR` | Indicates a transfer error (optional)   |
-------------------------------------------------------
If `PREADY` remains low, the master must remain in the **wait state** until the slave is ready.

## Summary

APB is a simple, robust protocol optimized for **low-speed control** operations. It minimizes power and area, making it ideal for peripheral interfacing in SoCs.
