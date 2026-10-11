# 6.3.2 — JK flip-flop

A controllable single-bit flip-flop: with j and k the output holds, sets, resets, or toggles on the rising edge. Reset is synchronous and active high.

Companion to *FPGA Identikits* by Andrea Fato, group **6.3 — T / JK / SR**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**J and K together toggle.** That is the distinguishing rule of the JK: a simultaneous set and reset request is resolved as a toggle rather than an error. Verify the complete JK truth table matches the design intent before relying on it at a protocol boundary.

**Constrain both controls.** `j`, `k`, and synchronous `rst` must meet setup and hold at `clk`. Treat their source logic as part of the same register-to-register timing path, even when only one control is expected to change in a normal cycle.

**A held pair keeps toggling.** With reset inactive, holding both `j` and `k` high toggles the bit at every rising edge. Use a single-cycle request when one toggle is intended; these are controls of one register, not competing drivers.

## Files

- [`jk_flip_flop.vhd`](jk_flip_flop.vhd): synthesizable reference template (VHDL-2008).
- [`tb_jk_flip_flop.vhd`](tb_jk_flip_flop.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit jk-flip-flop
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_jk_flip_flop`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_jk_flip_flop`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `no generics`

Checks include:
- Register control.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity jk_flip_flop is
    port (
        clk : in  std_logic;
        j   : in  std_logic;
        k   : in  std_logic;
        rst : in  std_logic;
        q   : out std_logic
    );
end entity jk_flip_flop;
```

## Source traceability

- Book identikit: **6.3.2**.
- Book source: `components/jk-flip-flop.tex`.
- RTL SHA-256 (UTF-8, LF): `eb60db344ead291a653a0d0e6dd3d29e4b08e4193959d3281ea5e535a744d3e6`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
