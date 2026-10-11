# 1.1.4 — 1:N demultiplexer

Routes one W-bit data word into one of N packed output slices. A binary index chooses the destination; every unselected slice is driven to zero, including all destinations for an invalid index.

Companion to *FPGA Identikits* by Andrea Fato, group **1.1 — Multiplexing & Demultiplexing**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Size the index deliberately.** Require `SEL_WIDTH >= max(1, ceil(log2(N)))`. Unused binary codes in non-power-of-two configurations retain the zero fallback.

**Drive every route and preserve packing.** Clear all slices before overriding the selected one to prevent latches. Route zero uses the low W bits; both ends must agree on packing.

**Consider a shared-bus alternative.** The source can drive one common data bus while a decoder enables only the selected destination. This works when disabled destinations ignore the bus. Unlike this demultiplexer, it does not drive every inactive data path to zero. Compare both structures after synthesis.

**One source still creates fanout.** Although only one output slice is functionally active, `din` feeds the routing logic for every possible destination. Large values of `N` can increase area, delay, and routing pressure; inspect the synthesized structure and timing report.

**Treat the route as combinational.** Select transitions can move or split an active pulse in physical hardware. Synchronize or handshake an asynchronous control, and capture the selected data under one coherent timing assumption.

## Files

- [`demux_1_to_n.vhd`](demux_1_to_n.vhd): synthesizable reference template (VHDL-2008).
- [`tb_demux_1_to_n.vhd`](tb_demux_1_to_n.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit demux-1-to-n
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_demux_1_to_n`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_demux_1_to_n`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `1,4,3`
- `4,4,3`
- `5,4,3`

Checks include:
- Expected output for the applied input combinations (see testbench assertions).

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity demux_1_to_n is
    generic (
        N         : positive := 4;
        W         : positive := 8;
        SEL_WIDTH : positive range 1 to 30 := 2
    );
    port (
        din : in  std_logic_vector(W-1 downto 0);
        sel : in  std_logic_vector(SEL_WIDTH-1 downto 0);
        y   : out std_logic_vector(N*W-1 downto 0)
    );
end entity demux_1_to_n;
```

## Source traceability

- Book identikit: **1.1.4**.
- Book source: `components/demux-1-to-n.tex`.
- RTL SHA-256 (UTF-8, LF): `54845e0d4de3ccd1a8072fe626b91e19388777ebd779d4037ddc10c6ffeefc64`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
