# 11.1.1 — Adder with carry

Adds two equally wide unsigned words and a single carry-in. The lower W bits form the sum; the extra bit reports carry-out. The combinational block has no clock and does not retain an earlier result.

Companion to *FPGA Identikits* by Andrea Fato, group **11.1 — Unsigned word arithmetic**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Keep the widened bit.** Resize or prepend a zero to both operands before adding. Truncating first and trying to recover carry from the W-bit sum loses information. A carry-in must be added at the same widened precision.

**State the operand convention.** A bit pattern is not inherently signed. This template uses `unsigned` and `numeric_std`; do not mix signed and unsigned interpretations in one carry chain.

**Do not treat carry as a clock.** The outputs can glitch while operands change. Register the sum and carry together when a receiving interface needs a stable cycle result, and budget the carry-chain delay at the chosen width.

**Handle invalid simulation values.** The strict binary check exposes unknown, high-impedance, and weak input levels instead of silently coercing them. Zero can also be a valid result, so consumers cannot detect the fallback from the outputs alone; the warning is the simulation diagnostic.

## Files

- [`adder_with_carry.vhd`](adder_with_carry.vhd): synthesizable reference template (VHDL-2008).
- [`tb_adder_with_carry.vhd`](tb_adder_with_carry.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit adder-with-carry
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_adder_with_carry`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_adder_with_carry`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `1`
- `4`
- `8`

Checks include:
- Add.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity adder_with_carry is
    generic (W : positive := 8);
    port (
        a, b : in  std_logic_vector(W-1 downto 0);
        cin  : in  std_logic;
        sum  : out std_logic_vector(W-1 downto 0);
        cout : out std_logic
    );
end entity adder_with_carry;
```

## Source traceability

- Book identikit: **11.1.1**.
- Book source: `components/adder-with-carry.tex`.
- RTL SHA-256 (UTF-8, LF): `30746005db6fa840ac29e5fc4b0f09c6b0c0f27320e432a51a096e8a1eeea75e`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
