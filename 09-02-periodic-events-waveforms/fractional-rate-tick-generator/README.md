# 9.2.2 — Fractional-rate tick generator

Emits NUM registered one-cycle ticks in every DEN clock cycles, for a rate that need not divide the clock evenly. A restart returns the phase to zero, so the first tick follows after a fixed delay.

Companion to *FPGA Identikits* by Andrea Fato, group **9.2 — Periodic Events & Waveforms**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Distinguish interval and phase error.** Gaps are the floor or ceiling of `DEN/NUM`; an integer ratio gives equal intervals. Each tick is less than one clock period late relative to ideal times measured from the reset/restart origin.

**Reduce the ratio.** Divide `NUM` and `DEN` by their greatest common factor to minimize the phase width. The assertion rejects $`NUM`>`DEN`$ and a `DEN` that would overflow the phase sum.

**Constrain the sampled controls.** Synchronous `rst` and `restart` must meet setup and hold requirements at `clk`.

**Consumers act on the following edge.** A same-clock consumer reads the previous `tick` value and therefore acts on the edge after the generator sets it high. Reset or restart clears the generator output, but does not cancel an old high value already being sampled. Reset or inhibit the consumer as well if that action must be suppressed.

**Use the tick as an enable, not a clock.** Test `tick` inside the source-clock process. Another clock domain needs its own generator, or a pulse synchronizer when ticks are spaced far enough apart for the destination clock.

## Files

- [`fractional_tick_generator.vhd`](fractional_tick_generator.vhd): synthesizable reference template (VHDL-2008).
- [`tb_fractional_tick_generator.vhd`](tb_fractional_tick_generator.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit fractional-rate-tick-generator
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_fractional_tick_generator`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_fractional_tick_generator`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `1,1`
- `1073741823,1073741824`
- `18,15625`
- `2,5`

Checks include:
- Fractional tick.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity fractional_tick_generator is
    generic (
        NUM : positive := 18;
        DEN : positive := 15625
    );
    port (
        clk, rst : in  std_logic;
        restart  : in  std_logic;
        tick     : out std_logic
    );
end entity fractional_tick_generator;
```

## Source traceability

- Book identikit: **9.2.2**.
- Book source: `components/fractional-rate-tick-generator.tex`.
- RTL SHA-256 (UTF-8, LF): `ddb90a854f9b1143e9416dbe23acd23c376572ed69367b1e8d658b71cdca12ce`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
