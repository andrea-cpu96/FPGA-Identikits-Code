# 3.1.1 — Equality comparator

Compares two same-width words and asserts one flag when every corresponding bit matches. The result follows operand changes after the combinational comparison path delay.

Companion to *FPGA Identikits* by Andrea Fato, group **3.1 — Word equality and ordering**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Do not let unknowns look equal.** The ordinary equality operator on `std_logic_vector` compares resolved symbols literally, so two matching `'X'` values can contribute to a true result. The template first validates both operands, then compares them. This is a simulation diagnostic; it cannot turn an uncertain physical level into valid data.

**Make the compared field explicit.** Match widths at the interface and slice packed buses deliberately. Accidental padding, truncation, or comparing reserved bits can produce a logically correct result for the wrong field.

**Allow for comparison delay and glitches.** A wide equality test combines many bit comparisons, so allow for its propagation delay. While operands change, the output can briefly indicate a match. For that reason, do not use raw `eq` as a clock, asynchronous reset or event pulse. Register it when a stable condition is needed, allowing for the added latency.

**Equality is not synchronization.** Comparing asynchronous words does not make them coherent. Synchronize control flags or transfer multi-bit data with a suitable CDC (see the book's CDC appendix) protocol before relying on the result in another clock domain.

## Files

- [`equality_comparator.vhd`](equality_comparator.vhd): synthesizable reference template (VHDL-2008).
- [`tb_equality_comparator.vhd`](tb_equality_comparator.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit equality-comparator
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_equality_comparator`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_equality_comparator`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `1`
- `4`
- `8`

Checks include:
- Compare.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity equality_comparator is
    generic (
        W : positive := 8
    );
    port (
        a  : in  std_logic_vector(W-1 downto 0);
        b  : in  std_logic_vector(W-1 downto 0);
        eq : out std_logic
    );
end entity equality_comparator;
```

## Source traceability

- Book identikit: **3.1.1**.
- Book source: `components/equality-comparator.tex`.
- RTL SHA-256 (UTF-8, LF): `59bcdd299f680d898dcc2bc0dd745fedfe1d9542fb0fcc96e4b39c4af31920fa`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
