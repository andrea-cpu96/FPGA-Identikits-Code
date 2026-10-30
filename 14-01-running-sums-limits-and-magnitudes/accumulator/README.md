# 14.1.1 — Accumulator

Adds an input word to a stored sum on each enabled rising edge. A synchronous, active-high reset clears the sum with priority over addition. The N-bit result wraps on overflow; disabled edges leave it unchanged.

Companion to *FPGA Identikits* by Andrea Fato, group **14.1 — Running sums, limits, and magnitudes**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Budget the sum, not just one term.** To sum M nonnegative terms no larger than D without wrapping, choose $2^N>MD$. Increasing the input width alone does not provide headroom. A wider accumulator needs a wider state register and an explicit extension of the input before addition.

**Count accepted terms.** Each enabled edge adds one term, even if the input has not changed since the previous edge. Keep track of the accepted terms externally because the block supplies neither a batch length nor a result-valid flag. Reset starts a new sum and takes priority over a term offered on the same edge.

**Reset is not power-up.** Simulation starts with unknown state; hardware startup depends on the target. Reset must be sampled at a rising edge. A pulse entirely between edges is ignored. Use synchronous controls and coherent data; this register is not a clock-domain crossing solution.

**Check feedback timing and data.** The addition must fit within one clock period. Unknown enabled data can contaminate the sum until reset; there is no custom fallback. Only literal `'1'` activates reset or enable, and non-binary controls are not diagnosed by this template.

## Files

- [`accumulator.vhd`](accumulator.vhd): synthesizable reference template (VHDL-2008).
- [`tb_accumulator.vhd`](tb_accumulator.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit accumulator
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_accumulator`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_accumulator`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `1`
- `4`
- `8`

Checks include:
- BCD accumulator.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity accumulator is
    generic (N : positive := 8);
    port (
        clk, rst, en : in std_logic;
        din : in std_logic_vector(N-1 downto 0);
        sum : out std_logic_vector(N-1 downto 0)
    );
end entity accumulator;
```

## Source traceability

- Book identikit: **14.1.1**.
- Book source: `components/accumulator.tex`.
- RTL SHA-256 (UTF-8, LF): `7955029eb07bd43c0e8bf39a00be6e1b465311655b4e62f88ee8948a7641017c`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
