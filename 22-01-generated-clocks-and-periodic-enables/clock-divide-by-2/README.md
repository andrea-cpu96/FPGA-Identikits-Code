# 23.1.1 — Divide-by-2

A toggle flip-flop changes state at each rising edge of clk. After reset, its output has half the source frequency and equal high and low intervals of one source-clock period each.

Companion to *FPGA Identikits* by Andrea Fato, group **23.1 — Generated clocks and periodic enables**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Prefer an enable for ordinary logic.** Connecting `clk_div2` to register clock pins creates a second clock network, and the fabric output does not automatically use dedicated clock routing. If the aim is simply to update less often, keep the registers on `clk` and use an enable to select their active cycles.

**Constrain the divided clock.** If this signal actually clocks registers, define its relationship to `clk` in the timing flow and use appropriate device clocking resources and routing. Check crossings, clock skew, and reset release in the implemented design.

**Reset establishes phase, not an immediate level.** `rst` is synchronous. Raising it between edges does not immediately pull the output low; it is sampled at the next rising edge. Without a reset edge, the RTL starts unknown in simulation.

**Interpret duty cycle after reset.** The first toggle occurs on the first non-reset source edge. The exact 50% duty claim applies to the continuing waveform, not the reset interval or clock-startup transients. Only binary reset levels form the intended functional contract.

## Files

- [`clock_divide_by_2.vhd`](clock_divide_by_2.vhd): synthesizable reference template (VHDL-2008).
- [`tb_clock_divide_by_2.vhd`](tb_clock_divide_by_2.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit clock-divide-by-2
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_clock_divide_by_2`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_clock_divide_by_2`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `no generics`

Checks include:
- Clock division.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity clock_divide_by_2 is
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        clk_div2 : out std_logic
    );
end entity clock_divide_by_2;
```

## Source traceability

- Book identikit: **23.1.1**.
- Book source: `components/clock-divide-by-2.tex`.
- RTL SHA-256 (UTF-8, LF): `480fe3535a8ff49d5c9145286db5e52f2315f8ec363d15bdf5c8588a6fb82803`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
