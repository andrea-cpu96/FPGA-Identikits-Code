# 19.1.1 — Counter-based debouncer

Synchronizes a single asynchronous input, then accepts a different level only after STABLE consecutive qualifying clock samples. A sample matching the accepted level clears the timer. Both rising and falling changes are filtered.

Companion to *FPGA Identikits* by Andrea Fato, group **19.1 — Turn a button press into one clean action**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Choose a physical interval.** Use a threshold appropriate to the clock frequency and measured switch bounce. The nominal setting is STABLE/$f_{clk}$; the STABLE observations themselves span STABLE-1 clock periods. Include sampling phase and synchronizer latency in response budgets.

**No accumulation across bounces.** Every return to the currently accepted level clears the count, so only consecutive qualifying samples accumulate. This differs from an up/down noise integrator. A disturbance entirely between sampling edges can still be missed: agreement at the sampled instants does not prove that the analog signal was continuously stable.

**Implement the synchronizer physically.** Mark and place the two stages using the FPGA vendor's CDC (see the book's CDC appendix) flow; prevent retiming or shift-register extraction. Only the second stage feeds the filter. Two stages reduce metastability risk but do not eliminate it; check timing and the required reliability separately.

**Define startup and polarity.** Declared initial values require target support. A high input at startup still passes through synchronization and qualification. An active-low button produces a low accepted level when pressed; invert or edge-detect downstream if needed. There is no invalid-input fallback.

## Files

- [`counter_based_debouncer.vhd`](counter_based_debouncer.vhd): synthesizable reference template (VHDL-2008).
- [`tb_counter_based_debouncer.vhd`](tb_counter_based_debouncer.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit counter-based-debouncer
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_counter_based_debouncer`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_counter_based_debouncer`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `1`
- `4`
- `8`

Checks include:
- Debounce threshold.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity counter_based_debouncer is
    generic (STABLE : positive := 500000);
    port (
        clk, btn : in std_logic;
        debounced : out std_logic
    );
end entity counter_based_debouncer;
```

## Source traceability

- Book identikit: **19.1.1**.
- Book source: `components/counter-based-debouncer.tex`.
- RTL SHA-256 (UTF-8, LF): `1ec5532e342d03e3b2b9f895979cd437b582621fe9608f8d20e36fceb5ba8b9c`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
