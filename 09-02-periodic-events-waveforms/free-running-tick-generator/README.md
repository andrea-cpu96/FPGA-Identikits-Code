# 9.2.1 — Free-running tick generator

Counts clock edges modulo TIMEOUT. Its registered tick marks each expiry while all logic keeps the source clock.

Companion to *FPGA Identikits* by Andrea Fato, group **9.2 — Periodic Events & Waveforms**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Use the tick as an enable, not a clock.** Same-domain registers should test `tick` inside their source-clock process. This preserves the dedicated clock tree and makes timing analysis straightforward.

**Check parameter fit.** The positive subtype excludes a zero period, while the concurrent assertion checks that `TIMEOUT` fits the selected counter width.

**Constrain the sampled control.** Synchronous `rst` must meet setup and hold requirements at `clk`.

**Reset defines phase.** Instances on the same source clock, with the same period and reset-release edge, align their pulses. Different periods share a phase origin but have different pulse schedules.

**Account for same-clock sampling.** Another process testing `tick` at the edge that schedules it high sees the previous value; it acts at the edge ending the asserted interval. Align dependent state to that convention. If reset must cancel an old high tick, give the consumer's reset priority over its enable.

**A pulse is not a new timebase.** Logic in another clock domain still needs a pulse synchronizer or handshake; a one-cycle source pulse can be missed by a slower domain.

## Files

- [`free_running_tick_generator.vhd`](free_running_tick_generator.vhd): synthesizable reference template (VHDL-2008).
- [`tb_free_running_tick_generator.vhd`](tb_free_running_tick_generator.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit free-running-tick-generator
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_free_running_tick_generator`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_free_running_tick_generator`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `1,1`
- `3,3`
- `3,7`

Checks include:
- Tick period.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity free_running_tick_generator is
    generic (
        N       : positive range 1 to 30 := 8;
        TIMEOUT : positive := 10
    );
    port (
        clk  : in  std_logic;
        rst  : in  std_logic;
        tick : out std_logic
    );
end entity free_running_tick_generator;
```

## Source traceability

- Book identikit: **9.2.1**.
- Book source: `components/free-running-tick-generator.tex`.
- RTL SHA-256 (UTF-8, LF): `d1cc46d2738ccbd79616c80016004e8bed8ccb2f901f8916718ecfe6e2ed279d`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
