# 12.1.3 — Multiply-accumulate (MAC)

Adds the unsigned product of two operands to a stored accumulator on each enabled rising edge. A synchronous, active-high reset clears the sum with priority over accumulation; a disabled edge holds the previous result.

Companion to *FPGA Identikits* by Andrea Fato, group **12.1 — Products and accumulated products**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Budget accumulation headroom.** A full product needs 2N bits, but a sum of K maximum products needs $2^{`ACC_W`}>K(2^N-1)^2$ to avoid wrap. The default width holds one full product, not an arbitrary sum. A narrower accumulator discards high product bits; no rounding or saturation is performed.

**Reset defines a new sum.** No initial value is declared; sample reset before the first accumulation. Reset wins even when enable is high. Holding enable high counts the current operand pair again on every edge; there is no request handshake or automatic end-of-sum event.

**Respect the feedback timing path.** Multiplication and addition must meet the same receiving edge. DSP mapping is target-dependent. Inserting registers changes the operand and feedback timing; it is not equivalent to adding a delay to the output of this recurrence.

**Keep inputs synchronous and binary.** Data and controls must meet setup and hold. There is no custom invalid-input fallback: an unknown enabled operand can contaminate the running sum until reset. Only literal `'1'` activates each control branch; invalid controls are not diagnosed.

## Files

- [`multiply_accumulate.vhd`](multiply_accumulate.vhd): synthesizable reference template (VHDL-2008).
- [`tb_multiply_accumulate.vhd`](tb_multiply_accumulate.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit multiply-accumulate
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_multiply_accumulate`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_multiply_accumulate`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `1,1`
- `4,12`
- `4,3`
- `4,8`

Checks include:
- MAC wrap/resize.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity multiply_accumulate is
    generic (
        N     : positive := 8;
        ACC_W : positive := 2*N
    );
    port (
        clk, rst, en : in std_logic;
        a, b : in std_logic_vector(N-1 downto 0);
        result : out
            std_logic_vector(ACC_W-1 downto 0)
    );
end entity multiply_accumulate;
```

## Source traceability

- Book identikit: **12.1.3**.
- Book source: `components/multiply-accumulate.tex`.
- RTL SHA-256 (UTF-8, LF): `2340acdba67d9fabdd09faeab8a7af8765e1430518daeeabfaeee5cd6367e72f`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
