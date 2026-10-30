# 12.1.1 — Combinational multiplier

Multiplies two unsigned words without storing state. The output contains the complete product, with a width equal to the sum of the operand widths.

Companion to *FPGA Identikits* by Andrea Fato, group **12.1 — Products and accumulated products**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Keep the full result width.** The `numeric_std` vector multiply returns the sum of the operand widths. Assign it to a matching destination; a narrower output needs an explicit resize or slice and a stated truncation policy. A larger destination alone does not widen the expression.

**Choose signedness deliberately.** These casts interpret both operands as unsigned. Signed multiplication needs `signed` operands and a two's-complement result contract; changing the output cast alone is not enough.

**Budget the combinational path.** Synthesis may implement the multiply with DSP hardware or ordinary logic, depending on width, target and settings. The multiplication operator alone guarantees neither a DSP block nor a clock frequency. Check the mapped path, and register the result if the consumer needs stable data throughout a cycle.

**Check operand values in simulation.** This template uses standard `numeric_std` arithmetic, not the preceding add/subtract blocks' zero fallback. Unknown inputs can propagate unknown results; weak levels follow the library's normalization. Supply binary, settled operands.

## Files

- [`combinational_multiplier.vhd`](combinational_multiplier.vhd): synthesizable reference template (VHDL-2008).
- [`tb_combinational_multiplier.vhd`](tb_combinational_multiplier.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit combinational-multiplier
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_combinational_multiplier`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_combinational_multiplier`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `1,1`
- `4,4`
- `8,8`

Checks include:
- Sat abs product.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity combinational_multiplier is
    generic (
        A_W : positive := 8;
        B_W : positive := 8
    );
    port (
        a : in std_logic_vector(A_W-1 downto 0);
        b : in std_logic_vector(B_W-1 downto 0);
        product : out
            std_logic_vector(A_W+B_W-1 downto 0)
    );
end entity combinational_multiplier;
```

## Source traceability

- Book identikit: **12.1.1**.
- Book source: `components/combinational-multiplier.tex`.
- RTL SHA-256 (UTF-8, LF): `30006852fe3e0cc4b6ec5e9b8caa60e4013b1bb36e2570de2cac6f9c249d91db`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
