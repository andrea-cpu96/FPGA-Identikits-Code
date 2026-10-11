# 14.1.3 — Absolute value

Converts a two's-complement word into its nonnegative magnitude. Widening before taking the absolute value preserves the most-negative input. The N-bit output is unsigned, so that largest magnitude remains representable.

Companion to *FPGA Identikits* by Andrea Fato, group **14.1 — Running sums, limits, and magnitudes**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Widen before taking the magnitude.** An N-bit signed value cannot represent $+2^{N-1}$. Sign-extend the input first, then apply `abs` at N+1 bits. Applying `abs` in N bits and widening afterward preserves the already-overflowed result for the most-negative input.

**Keep the output unsigned.** Dropping the widened result's top bit is exact here because it is zero for every binary input. The remaining N bits hold a magnitude, not a signed result. A downstream signed interface needs N+1 bits, or an explicit saturation policy at $2^{N-1}-1$.

**Avoid stale intermediate values.** Signal assignments update after a process suspends. A process sensitive only to a that writes an intermediate and immediately reads it uses the old value, without waking when it changes. Use concurrent assignments as below, or variables in one complete process.

**Magnitude is not validation.** Non-binary inputs follow `numeric_std` handling; this block has no custom fallback or valid flag. Changes to several input bits can cause glitches before settling. Register or otherwise sample the result with appropriate timing constraints.

## Files

- [`absolute_value.vhd`](absolute_value.vhd): synthesizable reference template (VHDL-2008).
- [`tb_absolute_value.vhd`](tb_absolute_value.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit absolute-value
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_absolute_value`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_absolute_value`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `1`
- `4`
- `8`

Checks include:
- Sat abs product.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity absolute_value is
    generic (N : positive := 8);
    port (
        a : in std_logic_vector(N-1 downto 0);
        absval : out std_logic_vector(N-1 downto 0)
    );
end entity absolute_value;
```

## Source traceability

- Book identikit: **14.1.3**.
- Book source: `components/absolute-value.tex`.
- RTL SHA-256 (UTF-8, LF): `e4f44d9c123761b2bbdd0400d2b8b7b047059aff56c5919ae92e148cb19375a5`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
