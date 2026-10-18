# 23.1.2 — Divide-by-N (even)

A phase counter toggles a registered output every DIV/2 non-reset source rising edges. For an even divisor, the settled output repeats every DIV source cycles with equal high and low durations.

Companion to *FPGA Identikits* by Andrea Fato, group **22.1 — Generated clocks and periodic enables**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Reject unsupported divisors.** The exact 50% waveform requires an even `DIV` of at least 2. The assertion catches odd values in simulation; check generic legality and synthesis messages in the target flow. An odd integer divisor needs alternating half-period lengths and cannot have equal high and low durations using only source rising edges.

**Reset and phase.** A reset edge clears both counter and output. The first output transition follows `DIV/2` non-reset source rising edges. `DIV` is fixed at elaboration; run-time changes require a separate safe phase-update policy.

**Treat the output as a real clock if used as one.** Its source is a fabric register, not automatically a dedicated clock resource. Define a generated clock and examine routing, skew, timing, and any crossings before placing register clock pins on this net.

**Prefer a same-clock enable when possible.** A periodic enable leaves all downstream registers on `clk`. It avoids a second clock network, although it has its own registered-tick observation convention. Only binary reset values are within this template's intended contract.

## Files

- [`clock_divide_by_n_even.vhd`](clock_divide_by_n_even.vhd): synthesizable reference template (VHDL-2008).
- [`tb_clock_divide_by_n_even.vhd`](tb_clock_divide_by_n_even.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit clock-divide-by-n-even
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_clock_divide_by_n_even`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_clock_divide_by_n_even`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `2*1`
- `2*3`
- `2*7`

Checks include:
- Clock division.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity clock_divide_by_n_even is
    generic (
        DIV : natural range 2 to integer'high := 6
    );
    port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        clk_div : out std_logic
    );
end entity clock_divide_by_n_even;
```

## Source traceability

- Book identikit: **23.1.2**.
- Book source: `components/clock-divide-by-n-even.tex`.
- RTL SHA-256 (UTF-8, LF): `0a91b95ba23fde87c67fb1bcf5ab6682be1d39f43aa30cc8d4c551e33cb17c53`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
