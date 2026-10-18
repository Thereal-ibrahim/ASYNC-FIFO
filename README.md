# Asynchronous FIFO

This project implements and simulates an asynchronous FIFO with separate write
and read clock domains.

## Design

The FIFO is composed of:

- `FIFO_TOP.sv` - top-level FIFO integration
- `FIFO_WR.sv` - write pointer and full-flag logic
- `FIFO_RD.sv` - read pointer and empty-flag logic
- `DATA_SYNC.sv` - two-register clock-domain synchronizer
- `MEMORY.sv` - dual-clock FIFO storage
- `FIFO_tb.sv` - simulation testbench

The default testbench configuration uses:

```text
Data width:  8 bits
FIFO depth:  16 words
Write clock: 10 ns period
Read clock:  15 ns period
```

Gray-coded read and write pointers are synchronized between the clock domains.
The read domain uses the synchronized write pointer to determine whether the
FIFO is empty. The write domain uses the synchronized read pointer to determine
whether the FIFO is full.

## Simulation

The ModelSim/Questa simulation can be launched with:

```tcl
do run.do
```

The script compiles the SystemVerilog sources, starts `FIFO_tb`, loads
`wave.do`, and runs the simulation.

The testbench generates:

- `Wr_Data.txt` - data accepted by the write side
- `Rd_Data.txt` - data accepted by the read side

Each file contains one hexadecimal data value per line.

## Comparing write and read data

Run the comparison utility from the project directory:

```powershell
python .\compare_fifo.py
```

Optional file paths can be provided:

```powershell
python .\compare_fifo.py .\Wr_Data.txt .\Rd_Data.txt
```

## Testbench timing

The testbench drives write data on the falling edge of `WR_CLK` and accepts the
write on the following rising edge. This ensures that `Wr_Data` and `Wr_Req`
are stable before the FIFO samples them.

The read side may temporarily be empty or full depending on the relative
write/read rates. Pointer synchronization adds latency when a newly written
word becomes visible in the read clock domain.

## Important limitations

- A FIFO depth of 16 stores at most 16 unread words.
- A burst request larger than the available space does not mean all requested
  words are accepted.
- Only transfers accepted by the FIFO should be used for data comparisons.
- The simulation must continue long enough after the final write for the
  synchronized read side to drain the remaining data.
