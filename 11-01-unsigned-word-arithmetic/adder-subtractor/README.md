# 11.1.3 — Adder / subtractor

Computes a W-bit unsigned sum or difference from the same operand pair. The op input selects addition at zero and subtraction at one. Only the wrapped result is exposed; this simple interface has no carry, borrow, or signed-overflow output.

Companion to *FPGA Identikits* by Andrea Fato, group **11.1 — Unsigned word arithmetic**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Specify modular behavior.** With two W-bit `unsigned` operands, each `numeric_std` arithmetic expression produces W bits: addition and subtraction wrap modulo $2^W$. A wider destination alone would not retain a carry or borrow; extend operands *before* arithmetic, as in the two status-bearing identikits. Wrapping is not saturation or an error flag.

**Use an explicit numeric type.** Both operands are interpreted as `unsigned`. A signed arithmetic unit can share much of the hardware, but its overflow and comparison rules differ.

**Mode changes are combinational.** Switching `op` can change the output between clock edges, and the path may glitch while settling. Register the selected result when a cycle-stable interface is required.

**Reject ambiguous controls.** A weak or unknown `op` is not silently treated as subtraction. The template warns and drives zero, as it does for non-binary operand bits. Zero can also be a valid result, so the warning is the only diagnostic; these fallbacks do not cure metastability.

## Files

- [`adder_subtractor.vhd`](adder_subtractor.vhd): synthesizable reference template (VHDL-2008).
- [`tb_adder_subtractor.vhd`](tb_adder_subtractor.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit adder-subtractor
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_adder_subtractor`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_adder_subtractor`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `1`
- `4`
- `8`

Checks include:
- Addsub.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity adder_subtractor is
    generic (W : positive := 8);
    port (
        a, b   : in  std_logic_vector(W-1 downto 0);
        op     : in  std_logic;
        result : out std_logic_vector(W-1 downto 0)
    );
end entity adder_subtractor;
```

## Source traceability

- Book identikit: **11.1.3**.
- Book source: `components/adder-subtractor.tex`.
- RTL SHA-256 (UTF-8, LF): `cb479e3771e7846ad18aa4396f9724fd7d61a6cf963f1f693eabc5f42559cfd0`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
