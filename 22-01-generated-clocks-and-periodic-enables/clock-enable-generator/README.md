# 23.1.3 — Clock-enable generator

A modulo-DIV counter asserts a registered tick when it wraps. The enable repeats every DIV source-clock cycles while all receiving registers remain on the original clk.

Companion to *FPGA Identikits* by Andrea Fato, group **23.1 — Generated clocks and periodic enables**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Use tick as an enable.** A consumer tests `tick` within its `rising_edge(clk)` process. Do not wire it to a clock input: that would defeat the single-domain purpose and create a new timing problem.

**Allow for next-edge tick sampling.** Other clocked processes read the old tick value at an edge, not the value scheduled by this process on that edge. Align data and state to the receiving edge. A combinational terminal decode would have different phase and glitch considerations.

**Reset establishes the interval.** A reset edge clears count and tick; the first high tick follows `DIV` non-reset source rising edges. A separate consumer can still read the *pre-edge* high tick at that reset edge. Give the consumer's own reset or inhibit condition priority if reset must suppress its action. Only binary reset levels are intended.

**Distinguish rate from protocol phase.** This generator runs freely from its reset origin and has neither an enable gate nor a phase preload. A protocol such as UART reception may instead need sampling ticks aligned to a detected start bit. Use a generator with an explicitly defined restart or alignment behavior for that purpose.

## Files

- [`clock_enable_generator.vhd`](clock_enable_generator.vhd): synthesizable reference template (VHDL-2008).
- [`tb_clock_enable_generator.vhd`](tb_clock_enable_generator.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit clock-enable-generator
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_clock_enable_generator`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_clock_enable_generator`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `1`
- `3`
- `7`

Checks include:
- Tick period.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity clock_enable_generator is
    generic (
        DIV : positive := 4
    );
    port (
        clk  : in  std_logic;
        rst  : in  std_logic;
        tick : out std_logic
    );
end entity clock_enable_generator;
```

## Source traceability

- Book identikit: **23.1.3**.
- Book source: `components/clock-enable-generator.tex`.
- RTL SHA-256 (UTF-8, LF): `636dd9a962b95e01672a7895220d042a0d43966783894d87c28250ea664e28c7`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
