# 1.1.1 — 2:1 multiplexer

Forwards one of two data words to a shared output. The select input controls the route directly: this block stores no state and responds after only its combinational propagation delay.

Companion to *FPGA Identikits* by Andrea Fato, group **1.1 — Multiplexing & Demultiplexing**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Define non-binary behavior.** Writing `d1 when sel='1' else d0` also selects `d0` for unknown or weak controls. This template instead warns and drives zero for every non-binary select value. That simulation fallback does not make a metastable input safe; Section B.5 explains the distinction.

**Selection is not synchronization.** A multiplexer can select data from different clock domains, but it cannot make asynchronous multi-bit data coherent. When signals cross clock domains, use an appropriate CDC (see the book's CDC appendix) technique and keep the select signal stable throughout the destination's capture window. Registering the mux output alone does not solve the CDC problem, and a standard RTL multiplexer should not be used as a glitchless clock-mux primitive.

## Files

- [`mux_2_to_1.vhd`](mux_2_to_1.vhd): synthesizable reference template (VHDL-2008).
- [`tb_mux_2_to_1.vhd`](tb_mux_2_to_1.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit mux-2-to-1
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_mux_2_to_1`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_mux_2_to_1`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `4`

Checks include:
- Expected output for the applied input combinations (see testbench assertions).

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity mux_2_to_1 is
    generic (
        W : positive := 8
    );
    port (
        d0  : in  std_logic_vector(W-1 downto 0);
        d1  : in  std_logic_vector(W-1 downto 0);
        sel : in  std_logic;
        y   : out std_logic_vector(W-1 downto 0)
    );
end entity mux_2_to_1;
```

## Source traceability

- Book identikit: **1.1.1**.
- Book source: `components/mux-2-to-1.tex`.
- RTL SHA-256 (UTF-8, LF): `e206c33e426b7be96e85b9d8d2d0b7de8101d3ac9c3164fa4bbecb459e63c378`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
