# 6.1.7 — D register with initial value

The plain D register whose storage is declared with an initial value. In simulation the word is defined from the first instant; whether hardware reproduces that depends on the FPGA family and synthesis support, so verify it for the target device. There is no reset control; the word then captures data on every rising clock edge.

Companion to *FPGA Identikits* by Andrea Fato, group **6.1 — D Registers**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**The initializer is not a reset.** It sets the internal register's initial value in RTL simulation. Hardware startup at that value requires support from the target device and synthesis flow. To load zero again, present zero on `d` at a rising edge; this block has no dedicated reset or reinitialize input.

**Constrain normal operation.** After configuration, this is an ordinary edge-triggered register: `d` must meet setup and hold at `clk`, and the path through `q` must satisfy the downstream timing constraint.

**Verify initialization support.** Check that the internal state's declared value maps to the device's register initialization feature in the selected synthesis flow. Section B.2 explains how to distinguish configuration-time initialization from a run-time reset.

## Files

- [`d_register_initial.vhd`](d_register_initial.vhd): synthesizable reference template (VHDL-2008).
- [`tb_d_register_initial.vhd`](tb_d_register_initial.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit d-register-initial-value
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_d_register_initial`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_d_register_initial`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `no generics`

Checks include:
- Init.
- Register capture.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity d_register_initial is
    port (
        clk : in  std_logic;
        d   : in  std_logic_vector(7 downto 0);
        q   : out std_logic_vector(7 downto 0)
    );
end entity d_register_initial;
```

## Source traceability

- Book identikit: **6.1.7**.
- Book source: `components/d-register-initial-value.tex`.
- RTL SHA-256 (UTF-8, LF): `b90d988e515e562c533118fbb8fd14d4ca92d88f3561cf4180bd91dde6ed1ffb`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
