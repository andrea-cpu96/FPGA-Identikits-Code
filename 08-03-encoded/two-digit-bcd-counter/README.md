# 8.3.2 — Two-digit BCD counter

Stores separate four-bit ones and tens digits. Enabled edges increment the ones digit; its 9-to-0 transition carries into tens, which also wraps from 9 to 0.

Companion to *FPGA Identikits* by Andrea Fato, group **8.3 — Encoded**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**BCD is not ordinary eight-bit binary.** The packed BCD representation of decimal 42 is `x"42"` (`0100 0010`), not its ordinary binary representation `0010 1010`. Arithmetic must operate per digit or convert the representation.

**Carry is synchronous.** The tens digit updates on the same clock edge that wraps the ones digit. To add another decade, use that carry condition as its clock enable while keeping the same clock. Clocking the new digit from carry would create a separate ripple-clock structure.

**Define fault recovery.** The normal recurrence assumes legal digits. The template detects any digit above 9 and clears both digits on the next enabled edge.

**Constrain sampled controls.** `rst` and `en` must meet setup and hold requirements at `clk`.

**Display refresh is separate.** A packed BCD count does not drive LED segments directly; use a seven-segment decoder and multiplexing logic with the required polarity.

## Files

- [`two_digit_bcd_counter.vhd`](two_digit_bcd_counter.vhd): synthesizable reference template (VHDL-2008).
- [`tb_two_digit_bcd_counter.vhd`](tb_two_digit_bcd_counter.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit two-digit-bcd-counter
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_two_digit_bcd_counter`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_two_digit_bcd_counter`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `no generics`

Checks include:
- BCD accumulator.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity two_digit_bcd_counter is
    port (
        clk : in  std_logic;
        rst : in  std_logic;
        en  : in  std_logic;
        bcd : out std_logic_vector(7 downto 0)
    );
end entity two_digit_bcd_counter;
```

## Source traceability

- Book identikit: **8.3.2**.
- Book source: `components/two-digit-bcd-counter.tex`.
- RTL SHA-256 (UTF-8, LF): `7451ff6205ff09570ac3cce399c5f36dd3a0e88319d880f28a6cfc9ed7377bc1`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
