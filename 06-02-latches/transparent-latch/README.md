# 6.2.1 — Transparent latch

While the enable is high the output follows the data continuously; when the enable drops, the last value is held. There is no clocked sampling edge: the latch is level-sensitive, not edge-triggered.

Companion to *FPGA Identikits* by Andrea Fato, group **6.2 — Latches**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**An open latch can pass glitches.** Changes on `d` can reach `q` after propagation delay while `en` is high. A clocked register samples only at its edge, but can still capture a glitch that overlaps its setup/hold window.

**Check the inferred hardware.** Intentional latches are less common in FPGA designs than edge-triggered registers. Their implementation and timing can depend on the device and synthesis tool. Verify the inferred resource and timing paths in the synthesis and timing reports.

**Closing the latch has timing.** The missing `else` intentionally holds `q` while `en` is low. Data must meet the latch's setup and hold requirements around the falling `en` transition that closes it; also constrain the path while the latch is transparent. An `else` assigning a non-feedback value removes the hold behavior; `q <= q` does not.

## Files

- [`transparent_latch.vhd`](transparent_latch.vhd): synthesizable reference template (VHDL-2008).
- [`tb_transparent_latch.vhd`](tb_transparent_latch.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit transparent-latch
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_transparent_latch`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_transparent_latch`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `no generics`

Checks include:
- Latch follow/hold.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity transparent_latch is
    port (
        en : in  std_logic;
        d  : in  std_logic_vector(7 downto 0);
        q  : out std_logic_vector(7 downto 0)
    );
end entity transparent_latch;
```

## Source traceability

- Book identikit: **6.2.1**.
- Book source: `components/transparent-latch.tex`.
- RTL SHA-256 (UTF-8, LF): `8b275f3575848bd12b8d1a99e84ed5280abcc6b7244c1cb21ff98b7f36ddd039`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
