# 1.2.1 — Tri-state buffer

Drives a bidirectional pad while output enable is asserted and otherwise releases the connection to high impedance. data_in continuously reports the resolved value on the pad, whether it is driven by the FPGA or by an external device.

Companion to *FPGA Identikits* by Andrea Fato, group **1.2 — Shared I/O and bus ownership**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Use tri-state only at the device boundary.** Contemporary FPGA fabrics normally do not contain internal tri-state routing. An internal `'Z'` description is either rejected or converted into multiplexing logic. Keep the `inout` port at the top level so the tool can map it to an I/O buffer.

**Prevent bus contention.** If two enabled drivers drive opposite values, simulation resolves the bus to `'X'` and hardware can draw excessive current. Prevent this by disabling the current driver before enabling the next. Allow enough time for the pad, package and remote-device delays when setting the turnaround interval.

**Treat asynchronous input separately.** A released pad may float unless the board provides a pull device. When an external pad value is asynchronous to the receiving clock, synchronize it or use the protocol-specific CDC (see the book's CDC appendix) circuit before consuming it internally.

**Define the released level.** Add a board-level pull-up or pull-down resistor whenever an undriven line must settle high or low. Choose the polarity to match the protocol's idle state and ensure that every device sharing the line can safely override the pull.

## Files

- [`tri_state_buffer.vhd`](tri_state_buffer.vhd): synthesizable reference template (VHDL-2008).
- [`tb_tri_state_buffer.vhd`](tb_tri_state_buffer.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit tri-state-buffer
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_tri_state_buffer`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_tri_state_buffer`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `4`

Checks include:
- Expected output for the applied input combinations (see testbench assertions).

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity tri_state_buffer is
    generic (
        W : positive := 8
    );
    port (
        data_out : in    std_logic_vector(W-1 downto 0);
        oe       : in    std_logic;
        pad      : inout std_logic_vector(W-1 downto 0);
        data_in  : out   std_logic_vector(W-1 downto 0)
    );
end entity tri_state_buffer;
```

## Source traceability

- Book identikit: **1.2.1**.
- Book source: `components/tri-state-buffer.tex`.
- RTL SHA-256 (UTF-8, LF): `66e499e9dc685a64e5c81304fd7e74639dae53faac06a443b2139426344af5e7`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
