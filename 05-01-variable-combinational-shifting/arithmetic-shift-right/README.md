# 5.1.2 — Arithmetic shift right

Shifts a two's-complement word right by a selected amount. Vacated positions are filled with copies of the original most significant bit, preserving the sign while discarding low-order bits.

Companion to *FPGA Identikits* by Andrea Fato, group **5.1 — Variable combinational shifting**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Signedness selects the fill.** In `numeric_std`, a signed right shift replicates the leftmost bit, while an unsigned shift inserts zeros. Because `std_logic_vector` has no numeric signedness, convert it explicitly at the operation.

**Do not assume truncation toward zero.** Arithmetic right shift floors negative values. To truncate toward zero, apply a sign- and amount-dependent correction, or use division instead; never apply both scaling operations.

**Account for discarded bits.** A same-width right shift cannot overflow, but it loses low-order information and reports neither remainder nor inexact status. Add sticky-bit or rounding logic as needed. Saturation belongs only to surrounding arithmetic or a narrower destination that can exceed its range.

**Budget a variable path.** A constant shift is generally wiring; a run-time amount infers a barrel network. Register or pipeline the settled output when needed. The fallback does not make asynchronous or metastable controls safe; establish a coherent transfer before shifting.

## Files

- [`arithmetic_shift_right.vhd`](arithmetic_shift_right.vhd): synthesizable reference template (VHDL-2008).
- [`tb_arithmetic_shift_right.vhd`](tb_arithmetic_shift_right.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit arithmetic-shift-right
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_arithmetic_shift_right`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_arithmetic_shift_right`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `1`
- `5`
- `8`

Checks include:
- Arithmetic shift.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity arithmetic_shift_right is
    generic (W : positive := 8);
    port (
        d   : in  std_logic_vector(W-1 downto 0);
        amt : in  natural range 0 to W-1;
        q   : out std_logic_vector(W-1 downto 0)
    );
end entity arithmetic_shift_right;
```

## Source traceability

- Book identikit: **5.1.2**.
- Book source: `components/arithmetic-shift-right.tex`.
- RTL SHA-256 (UTF-8, LF): `fb43660e421732a13d40c41662079b28c438be660b66bb8559ab781231a2e359`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
