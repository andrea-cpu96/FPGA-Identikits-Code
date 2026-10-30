# 9.1.2 — Retriggerable pulse stretcher

Raises a registered output when a synchronous trigger is sampled. It stays high for a configured number of clock periods after the most recent trigger edge. A new trigger restarts the interval without a low gap; reset clears it.

Companion to *FPGA Identikits* by Andrea Fato, group **9.1 — Intervals & Timeouts**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**A high trigger reloads on each rising edge.** A high input reloads on every clock edge. For one trigger per rising transition of a held status level, use an upstream edge detector. Held-high trigger keeps the output active and postpones expiry until $L$ periods after its final high edge.

**Overlapping events merge.** Retriggering extends the current high interval without adding a new output transition. A consumer watching rising edges therefore sees one assertion even if several triggers arrived. Use an event counter or queue when every trigger must be recorded or delivered separately.

**A timed level does not imply a single action.** Same-clock logic sees the new output at its next sampling edge. An enable driven by `q` authorizes an action on every edge where `q` is high. With a running clock and no retrigger or reset, the interval is $L/f_{\rm clk}$. This is not an asynchronous reset generator.

**Stretching is not synchronization.** Trigger must already be synchronous. A narrow asynchronous input can be missed before stretching. Crossing the output needs a defined high/low capture contract or an event protocol; see Appendix C. No count of closely spaced events is guaranteed.

## Files

- [`pulse_stretcher.vhd`](pulse_stretcher.vhd): synthesizable reference template (VHDL-2008).
- [`tb_pulse_stretcher.vhd`](tb_pulse_stretcher.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit retriggerable-pulse-stretcher
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_pulse_stretcher`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_pulse_stretcher`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `PULSE_CYCLES: 1, 2, 3, 4, 13`

Checks include:
- Duration.
- Retriggering.
- Held trigger.
- Reset priority.
- Between-edge stability.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity pulse_stretcher is
    generic (PULSE_CYCLES : positive := 4);
    port (
        clk, rst : in  std_logic;
        trig     : in  std_logic;
        q        : out std_logic
    );
end entity pulse_stretcher;
```

## Source traceability

- Book identikit: **9.1.2**.
- Book source: `components/retriggerable-pulse-stretcher.tex`.
- RTL SHA-256 (UTF-8, LF): `2e23deb8205342811197dddec8c337403e63b65582c1d997e0eb9731d9e998cb`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
