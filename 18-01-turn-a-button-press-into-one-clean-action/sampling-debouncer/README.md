# 18.1.2 — Sampling debouncer

Synchronizes a single asynchronous input and shifts one observation into a K-bit history at every rising edge. An all-one history sets the accepted level; an all-zero history clears it. Mixed history holds the previous level.

Companion to *FPGA Identikits* by Andrea Fato, group **18.1 — Turn a button press into one clean action**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Set the actual sample interval.** Every clock samples. At 50 MHz, K=8 gives a nominal $K/f_{clk}=160$ ns setting; the eight observations span seven periods (140 ns), not milliseconds. Choose a suitable K or use a clock-enable variant while keeping the input synchronizer at the full clock rate.

**Account for storage cost.** History needs K bits plus decode logic; a counter needs roughly logarithmic storage for the same threshold. Long mechanical debounce intervals usually favor the counter. A mixed window holds the output; this is unanimity, not majority voting.

**Respect the old-history timing.** Both assignments read pre-edge signals. A qualifying run can be reported after its last sample has passed. Decoding a next-history variable instead would remove one cycle but change this documented contract. The accepted output is a level, not a pulse.

**Verify startup and CDC .** Initial values require target support; no run-time reset is supplied. Preserve and place the two synchronizer stages using vendor guidance and check metastability reliability. Sampled agreement does not prove analog stability, and this filter has no invalid-input diagnostic.

## Files

- [`sampling_debouncer.vhd`](sampling_debouncer.vhd): synthesizable reference template (VHDL-2008).
- [`tb_sampling_debouncer.vhd`](tb_sampling_debouncer.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit sampling-debouncer
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_sampling_debouncer`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_sampling_debouncer`; a failure assertion or timeout is a failure.
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
entity sampling_debouncer is
    generic (K : positive := 8);
    port (
        clk, btn : in std_logic;
        debounced : out std_logic
    );
end entity sampling_debouncer;
```

## Source traceability

- Book identikit: **18.1.2**.
- Book source: `components/sampling-debouncer.tex`.
- RTL SHA-256 (UTF-8, LF): `b7cd18db889dfb8dff871e954d87a8902479ca0f7406dc20781e11534a88a65c`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
