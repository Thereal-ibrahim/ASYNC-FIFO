# Asynchronous FIFO Design Specification

## 1. Purpose

An asynchronous FIFO transfers data between two independent clock domains.

The write side receives data using a write clock, while the read side removes data using a separate read clock. The two clocks may have different frequencies and unrelated phase relationships.

The design must:

- Accept writes only when space is available.
- Accept reads only when data is available.
- Preserve data ordering.
- Prevent overflow and underflow.
- Safely communicate status between clock domains.
- Support independent reset behavior as defined by the design.
- Be parameterized by FIFO depth and data width.

---

## 2. Overall Architecture

The FIFO consists of three main functional areas:

1. **Write-domain control**
2. **Read-domain control**
3. **Dual-port storage memory**

The write and read controllers operate independently.

The write controller owns the write address and write-side status. The read controller owns the read address and read-side status. Since the controllers use different clocks, their state must not be transferred directly between clock domains.

Each side communicates its progress to the other side through synchronized status information.

---

## 3. Recommended Project Modules

The project can be organized into the following modules:

```text
FIFO_MEMORY
FIFO_WR
FIFO_RD
```

Additional helper modules may be added if desired:

```text
FIFO_SYNC_WR_TO_RD
FIFO_SYNC_RD_TO_WR
ASYNC_FIFO_TOP
```

The helper modules are not required to be separate files, but separating them can make the design easier to understand and verify.

---

# 4. FIFO_MEMORY

## Purpose

`FIFO_MEMORY` stores the data written into the FIFO until it is read.

## Responsibilities

The memory module should:

- Store one data word for each FIFO entry.
- Accept write operations from the write clock domain.
- Provide read data to the read clock domain.
- Support independent write and read operations.
- Allow the write side and read side to operate at different rates.
- Provide the configured data width and FIFO depth.

## Main Interface Concepts

The memory requires:

- A write clock.
- A read clock.
- A write enable.
- A read enable, depending on the selected read behavior.
- A write address.
- A read address.
- Write data.
- Read data.
- Reset handling, if required by the chosen memory model.

## Memory Behavior

A valid write stores the input data at the location selected by the write address.

A valid read retrieves the data at the location selected by the read address.

The memory itself should not decide whether the FIFO is full or empty. Those decisions belong to the write and read controllers.

## Read Behavior Decision

The design should explicitly choose one of these read behaviors:

### Registered read

The output data changes on a read clock edge. This gives predictable timing and is commonly used for synchronous memory implementations.

### Combinational read

The output reflects the current memory location without requiring a read clock edge. This is simpler conceptually but may not map to all memory resources in the same way.

The chosen behavior should be documented because it affects the timing expected by the receiving logic.

---

# 5. FIFO_WR

## Purpose

`FIFO_WR` controls all FIFO activity in the write clock domain.

## Responsibilities

The write controller should:

- Maintain the current write position.
- Accept incoming write requests.
- Prevent writes while the FIFO is full.
- Generate the write address used by the memory.
- Generate the write-side representation of FIFO progress.
- Make write-side progress available to the read domain.
- Generate the full status signal.
- Respond correctly to reset.

## Inputs

Conceptually, the write controller receives:

- Write clock.
- Reset.
- Write request or incoming-data indication.
- Read-side progress information after synchronization.
- Optional write data-valid information.

## Outputs

Conceptually, it produces:

- Write address.
- Write enable.
- Full status.
- Write-side progress information for synchronization.
- Optional accepted-write indication.

## Write Acceptance

A write is accepted only when:

- A write request is present.
- The FIFO is not full.
- The write side is not held in reset. 

If the FIFO is full, the incoming write must not alter the FIFO contents or advance the write position.

The design should decide whether rejected writes are:

- Ignored,
- Reported through a status signal,
- Counted as an error,
- Or handled using backpressure.

For a learning design, exposing an `overflow_attempt` indication can be useful during verification.

## Write Position

The write position identifies where the next accepted data word will be stored.

The position must support:

- Addressing every storage entry.
- Detecting when the write side has completed a full traversal.
- Comparing progress with the read side.
- Distinguishing equal positions that represent different FIFO states.

The write controller should expose both the local form used for memory addressing and the safe form used for clock-domain communication.

## Full Status

The full condition belongs to the write clock domain.

It indicates that accepting another write would overwrite unread data.

The full status must be generated using write-side state and a synchronized view of read-side progress. The read-side state must not be consumed directly by the write clock domain.

The full status should be registered or otherwise timed consistently with the write clock so that write acceptance and full reporting do not disagree.

---

# 6. FIFO_RD

## Purpose

`FIFO_RD` controls all FIFO activity in the read clock domain.

## Responsibilities

The read controller should:

- Maintain the current read position.
- Accept read requests.
- Prevent reads while the FIFO is empty.
- Generate the read address used by the memory.
- Generate the read-side representation of FIFO progress.
- Make read-side progress available to the write domain.
- Generate the empty status signal.
- Respond correctly to reset.

## Inputs

Conceptually, the read controller receives:

- Read clock.
- Reset.
- Read request.
- Write-side progress information after synchronization.
- Memory read data, depending on the selected memory behavior.

## Outputs

Conceptually, it produces:

- Read address.
- Read enable.
- Empty status.
- Read-side progress information for synchronization.
- Read data-valid or accepted-read indication.

## Read Acceptance

A read is accepted only when:

- A read request is present.
- The FIFO is not empty.
- The read side is not held in reset.

If the FIFO is empty, the read request must not advance the read position.

The design should decide whether rejected reads are:

- Ignored,
- Reported through a status signal,
- Counted as an error,
- Or handled using backpressure.

For learning and verification, an `underflow_attempt` indication can help identify invalid read requests.

## Read Position

The read position identifies the next data word to be removed from the FIFO.

The position must support:

- Addressing every storage entry.
- Detecting when the read side has completed a full traversal.
- Comparing progress with the write side.
- Distinguishing an empty FIFO from a full FIFO when both positions have the same storage address.

The read controller should expose both the local form used for memory addressing and the safe form used for clock-domain communication.

## Empty Status

The empty condition belongs to the read clock domain.

It indicates that no unread data is currently available to the read side.

The empty status must be generated using read-side state and a synchronized view of write-side progress. The write-side state must not be consumed directly by the read clock domain.

The empty status should be timed consistently with the read clock so that read acceptance and empty reporting do not disagree.

---

# 7. Clock-Domain Crossing

## Purpose

The write and read clocks are asynchronous to each other. Signals generated in one clock domain must not be used directly in the other clock domain.

## Information That Crosses Domains

The write side must communicate its progress to the read side.

The read side must communicate its progress to the write side.

Only the information required for status calculation should cross the clock boundary.

The actual data values remain in the shared memory. The control logic communicates where valid data begins and ends.

## Synchronization Requirements

Each cross-domain progress signal should pass through a dedicated synchronization mechanism clocked by the receiving domain.

The synchronizer should:

- Be clocked by the destination clock.
- Reduce the probability of metastability propagating into destination logic.
- Preserve the ordering of progress updates.
- Be reset consistently with the rest of the FIFO.

The synchronized value is delayed relative to the source value. Consequently, full and empty flags may be conservative:

- The read side may take several read-clock cycles to observe newly written data.
- The write side may take several write-clock cycles to observe newly freed space.

This delay is expected and must be included in verification.

## Data Safety

The memory data path and control path must be considered separately.

The control path communicates whether a location contains valid data. The data path stores and retrieves the data itself.

The design must ensure that a read is not accepted until the write-side progress has safely crossed into the read domain.

Likewise, a write must not reuse a memory location until the read-side progress has safely crossed into the write domain.

---

# 8. FIFO Status Model

The FIFO has two primary status signals:

## Full

Full is generated in the write domain.

It means that the FIFO cannot accept another write without overwriting unread data.

## Empty

Empty is generated in the read domain.

It means that the FIFO cannot provide another valid data word.

## Status Timing

Because status information crosses clock domains through synchronizers, status signals are not instantaneous representations of the other clock domain.

The design should document that:

- Full may remain asserted briefly after a read creates space.
- Empty may remain asserted briefly after a write creates data.
- Neither status signal should be generated by directly comparing unsynchronized signals.

---

# 9. Reset Design

Reset behavior must be defined before implementing the modules.

## Reset Questions to Decide

The design should specify:

- Whether reset is synchronous or asynchronous for each clock domain.
- Whether both clock domains share one reset input.
- Whether reset is active-high or active-low.
- What happens if one clock is stopped during reset.
- What happens if the two sides leave reset at different times.
- Whether memory contents are reset.
- What values are required for full, empty, and data-valid outputs after reset.

## Expected Initial State

After a successful reset:

- The write position represents the beginning of the storage space.
- The read position represents the beginning of the storage space.
- The FIFO is empty.
- The FIFO is not full.
- No read is considered valid.
- No stale memory value is considered valid data.
- Synchronizer state is initialized to a consistent empty condition.

The memory usually does not need to be cleared because the control state determines whether each location contains valid data.

---

# 10. Top-Level Integration

An optional top-level module, such as `ASYNC_FIFO_TOP`, can connect the three primary modules.

## Top-Level Responsibilities

The top-level module should:

- Expose the external FIFO interface.
- Connect the write controller to the memory.
- Connect the read controller to the memory.
- Connect the clock-domain synchronization paths.
- Route full and empty status to the external interface.
- Route accepted-write and accepted-read events if they are exposed.
- Apply the selected reset scheme.

## External Interface Concepts

A complete FIFO interface commonly includes:

### Write side

- Write clock.
- Write reset.
- Write request.
- Write data.
- Full status.
- Optional write-accepted indication.
- Optional overflow indication.

### Read side

- Read clock.
- Read reset.
- Read request.
- Read data.
- Empty status.
- Optional read-accepted indication.
- Optional underflow indication.

The write-side signals should be timed by the write clock. The read-side signals should be timed by the read clock.

---

# 11. Parameterization

The design should be configurable using at least:

- Data width.
- FIFO depth.

## Data Width

Data width determines the number of bits stored in each FIFO entry.

Changing the data width should not change the control behavior.

## FIFO Depth

FIFO depth determines the number of entries available for storage.

The design should document whether the depth is restricted to values that simplify address and progress tracking.

If arbitrary depths are supported, the design must define how address wraparound and full detection behave for non-power-of-two sizes.

For a first learning implementation, a restricted depth policy may make the control behavior easier to reason about.

---

# 12. FIFO Operation Examples

## Empty FIFO

1. Reset places both sides at the initial position.
2. The read side reports empty.
3. A read request is rejected.
4. A write request is accepted if the write side is not full.
5. After synchronization delay, the read side observes that data is available.
6. The read side removes the data.

## Continuous Writes

1. The write side accepts data while space remains.
2. The write position advances for each accepted write.
3. The read side eventually observes the updated write progress.
4. The read side can then consume the stored data.

## Continuous Reads

1. The read side accepts data while the FIFO is not empty.
2. The read position advances for each accepted read.
3. The write side eventually observes the updated read progress.
4. The write side can then reuse the released storage locations.

## Full FIFO

1. The write side reaches the condition representing no remaining space.
2. Full becomes asserted in the write domain.
3. Further write requests are rejected.
4. A read eventually advances the read side.
5. After synchronization delay, the write side observes available space.
6. Full deasserts.

## Empty FIFO After Reads

1. The read side consumes the final valid data word.
2. The read position advances.
3. Empty becomes asserted in the read domain.
4. Further read requests are rejected.
5. A later write eventually makes new data visible after synchronization delay.

---

# 13. Verification Requirements

The design should be verified independently from the implementation details.

## Basic Tests

Verify that:

- Reset produces an empty FIFO.
- A single write followed by a read returns the same data.
- Multiple writes preserve ordering.
- Multiple reads preserve ordering.
- The FIFO can fill to its defined capacity.
- The FIFO can return to empty.
- Writes are blocked while full.
- Reads are blocked while empty.

## Clock Tests

Use different clock frequencies, including:

- Write clock faster than read clock.
- Read clock faster than write clock.
- Nearly equal frequencies.
- Clocks with unrelated phases.
- Irregular relative timing.

## Boundary Tests

Test:

- The first write after reset.
- The first read after reset.
- The final write before full.
- The final read before empty.
- A write request while full.
- A read request while empty.
- Simultaneous read and write activity.
- Reset during partial FIFO occupancy.

## Data Integrity

A reference model should track accepted writes and accepted reads.

The testbench should compare:

- The sequence of accepted writes.
- The sequence of accepted reads.
- The read data returned.
- The number of valid entries.
- The full and empty behavior.

Only accepted operations should affect the reference model.

## Assertions

Useful properties include:

- A write cannot be accepted while full.
- A read cannot be accepted while empty.
- The FIFO cannot report both valid data and no storage consistently with its defined protocol.
- Read data is produced only for accepted reads.
- Data ordering is preserved.
- The number of stored entries never becomes negative.
- The number of stored entries never exceeds FIFO capacity.

---

# 14. Suggested Design Responsibilities

| Module | Clock Domain | Main Responsibility |
|---|---|---|
| `FIFO_MEMORY` | Both | Store and retrieve data |
| `FIFO_WR` | Write clock | Manage writes, write position, and full status |
| `FIFO_RD` | Read clock | Manage reads, read position, and empty status |
| Write-to-read synchronizer | Read clock | Transfer write progress safely |
| Read-to-write synchronizer | Write clock | Transfer read progress safely |
| `ASYNC_FIFO_TOP` | Both | Connect and expose the complete FIFO |

---

# 15. Design Completion Criteria

The asynchronous FIFO design is complete when:

- The write and read sides operate independently.
- No unsynchronized control signal crosses clock domains.
- Full is generated only in the write domain.
- Empty is generated only in the read domain.
- Memory locations are not overwritten before being read.
- Data is not read before being written.
- FIFO ordering is preserved.
- Reset behavior is documented and verified.
- Parameter limits are documented.
- Clock-domain and boundary cases pass verification.
