# 5.1.1 — Rotate-right barrel shifter

Rotates a word right by a selected number of bit positions. Bits leaving the least significant end re-enter at the most significant end, so rotation preserves every input bit and does not perform sign or zero extension.

Companion to *FPGA Identikits* by Andrea Fato, group **5.1 — Variable combinational shifting**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Allow for rotation area and delay.** A variable rotation normally infers a multistage multiplexer network rather than free wiring. Area and delay grow with width and with the number of selectable amounts. A constant amount, by contrast, usually collapses to rewiring.

**Make the operation explicit.** The term ``barrel shifter'' describes how an operation is implemented, but does not specify which bits fill the vacated positions. State the direction and whether the operation rotates, inserts zeros or extends the sign. These choices give the same input word different numerical meanings.

**Constrain the amount.** Every value admitted by this VHDL subtype has a defined meaning. Assigning a value outside the subtype causes a bounds error in simulation; it does not invoke the zero-data fallback. A vector-coded wrapper must validate meta-values and unused codes before numeric conversion, then reject, clamp, or reduce them modulo `W` as specified.

**Register long paths when needed.** Both data and amount feed a wide combinational network and may produce transients while changing. Use only the settled result, and pipeline it when delay exceeds the timing budget. The deterministic simulation fallback does not make asynchronous or metastable data and amount controls safe; establish a coherent transfer first.

## Files

- [`barrel_shifter.vhd`](barrel_shifter.vhd): synthesizable reference template (VHDL-2008).
- [`tb_barrel_shifter.vhd`](tb_barrel_shifter.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit barrel-shifter
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_barrel_shifter`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_barrel_shifter`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `1`
- `5`
- `8`

Checks include:
- Rotate.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity barrel_shifter is
    generic (W : positive := 8);
    port (
        d   : in  std_logic_vector(W-1 downto 0);
        amt : in  natural range 0 to W-1;
        q   : out std_logic_vector(W-1 downto 0)
    );
end entity barrel_shifter;
```

## Source traceability

- Book identikit: **5.1.1**.
- Book source: `components/barrel-shifter.tex`.
- RTL SHA-256 (UTF-8, LF): `83582ab7c18d66e13b077fd1cc499bd4f67015ab00a537eb45541b9369cee4c0`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
