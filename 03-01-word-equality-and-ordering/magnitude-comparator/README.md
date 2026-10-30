# 3.1.2 — Magnitude comparator

Orders two words of the same width and asserts exactly one relation flag for valid binary operands. This reference form interprets both words as unsigned numbers and stores no state.

Companion to *FPGA Identikits* by Andrea Fato, group **3.1 — Word equality and ordering**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Signedness is part of the specification.** The same pattern can have a different order when read as signed: `"1000" < "0111"` means $-8<7$. Convert to `unsigned` or `signed` explicitly and do not mix interpretations along one decision path.

**Normalize operand widths.** Relational operands should have identical, intentional widths. Zero-extend unsigned values and sign-extend signed values; silent truncation or the wrong extension changes the numerical order.

**Keep comparison outputs consistent.** This template puts the comparisons and invalid-input defaults in one decision chain so their relationship is easy to check. Separate expressions are also correct if they use the same interpretation and assign every output. Either style must be checked after synthesis; source structure alone does not determine the hardware.

**Budget timing and crossings.** A wide comparison can create a long carry-like path, so check its timing before using the result. Register relation flags together when required, and do not use raw flags as clocks, asynchronous resets or event pulses. If an operand comes from another clock domain, transfer the complete word coherently before comparing it.

## Files

- [`magnitude_comparator.vhd`](magnitude_comparator.vhd): synthesizable reference template (VHDL-2008).
- [`tb_magnitude_comparator.vhd`](tb_magnitude_comparator.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit magnitude-comparator
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_magnitude_comparator`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_magnitude_comparator`; a failure assertion or timeout is a failure.
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
entity magnitude_comparator is
    generic (
        W : positive := 8
    );
    port (
        a  : in  std_logic_vector(W-1 downto 0);
        b  : in  std_logic_vector(W-1 downto 0);
        lt : out std_logic;
        eq : out std_logic;
        gt : out std_logic
    );
end entity magnitude_comparator;
```

## Source traceability

- Book identikit: **3.1.2**.
- Book source: `components/magnitude-comparator.tex`.
- RTL SHA-256 (UTF-8, LF): `cb9d05e3ed4512fba691b0bb09e2f5f823ed5c2d95e94d050c60096a2ca20918`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
