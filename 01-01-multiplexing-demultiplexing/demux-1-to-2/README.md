# 1.1.3 — 1:2 demultiplexer

Routes one data word to one of two outputs. The selected output follows the input while the other output is driven to zero; the block stores no state and responds combinationally to both data and select changes.

Companion to *FPGA Identikits* by Andrea Fato, group **1.1 — Data selection and distribution**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Drive both outputs every time.** The process clears `y0` and `y1` before selecting a destination. The legal branch overrides only one output, while invalid control leaves the complete zero default in place. Assigning both outputs on every evaluation prevents unintended storage.

**Keep route numbering explicit.** Select zero routes data to `y0`. Swapping `y0` and `y1` reverses the routing without a type error because their types match.

**Hold selection stable during a pulse.** Changing select during an input pulse can shorten that pulse on one output or create a pulse on the other path. Hold the route stable over the destination capture interval, or register the control and data according to the receiving protocol.

**Selection is not synchronization.** A non-binary assertion is a simulation diagnostic, not protection from metastability. Apply the required CDC (see the book's CDC appendix) scheme before using an asynchronous select.

## Files

- [`demux_1_to_2.vhd`](demux_1_to_2.vhd): synthesizable reference template (VHDL-2008).
- [`tb_demux_1_to_2.vhd`](tb_demux_1_to_2.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit demux-1-to-2
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_demux_1_to_2`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_demux_1_to_2`; a failure assertion or timeout is a failure.
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
entity demux_1_to_2 is
    generic (
        W : positive := 8
    );
    port (
        din : in  std_logic_vector(W-1 downto 0);
        sel : in  std_logic;
        y0  : out std_logic_vector(W-1 downto 0);
        y1  : out std_logic_vector(W-1 downto 0)
    );
end entity demux_1_to_2;
```

## Source traceability

- Book identikit: **1.1.3**.
- Book source: `components/demux-1-to-2.tex`.
- RTL SHA-256 (UTF-8, LF): `f8a64584249297d24c9cf8c2168c2176476b9f7a2d28c99d9d325b58241ab69b`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
