# 13.1.1 — Divide by a power of two

Shifts an unsigned word right by a fixed number of bit positions. The output is the integer quotient after division by $2^K$; discarded low bits contain the remainder. This combinational block has no clock or stored state.

Companion to *FPGA Identikits* by Andrea Fato, group **13.1 — Fixed scaling and iterative division**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Keep the shift constant.** A generic K fixes the bit routing during elaboration. Synthesis normally reduces this operation to wiring and zeros, not a general divider. Making K a run-time input changes the circuit into a variable shifter, which may need a multiplexer network.

**Choose the rounding rule.** Discarding low bits rounds an unsigned quotient down. If the application needs rounding to the nearest integer, define that rule separately and allow enough intermediate width. Adding a rounding bias in only N bits can overflow before the shift takes place.

**Signed right shifts round down.** An arithmetic right shift repeats the sign bit. For a negative value it rounds toward negative infinity: $-3$ shifted right once gives $-2$, while signed integer division by 2 truncates toward zero and gives $-1$. Do not exchange these operations blindly.

**A shift does not validate data.** This template copies retained `std_logic` elements and inserts zeros. Unknown and weak values in retained positions remain; discarded positions no longer affect the output. The wiring does not synchronize asynchronous data or ensure glitch-free sampling.

## Files

- [`divide_by_power_of_two.vhd`](divide_by_power_of_two.vhd): synthesizable reference template (VHDL-2008).
- [`tb_divide_by_power_of_two.vhd`](tb_divide_by_power_of_two.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit divide-by-power-of-two
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_divide_by_power_of_two`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_divide_by_power_of_two`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `1,0`
- `1,1`
- `5,0`
- `5,1`
- `5,5`
- `8,0`
- `8,1`
- `8,8`

Checks include:
- Logical shift.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity divide_by_power_of_two is
    generic (
        N : positive := 8;
        K : natural := 1
    );
    port (
        a : in  std_logic_vector(N-1 downto 0);
        q : out std_logic_vector(N-1 downto 0)
    );
end entity divide_by_power_of_two;
```

## Source traceability

- Book identikit: **13.1.1**.
- Book source: `components/divide-by-power-of-two.tex`.
- RTL SHA-256 (UTF-8, LF): `7f4d02f798e5c565908f4cbf734630dbb178475f9fbcb55618f3cd356d82ed88`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
