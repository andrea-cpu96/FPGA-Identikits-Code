# 7.1.2 — SISO -- shift right

Samples one serial bit per rising edge, inserts it into stage N-1, and moves every stored bit toward bit 0. The least significant stage is exposed as the serial output.

Companion to *FPGA Identikits* by Andrea Fato, group **7.1 — Serial I/O**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Document both endpoints.** ``Shift right'' means decreasing vector indices here. Name the input stage, output stage, and protocol bit order so a connection does not silently reverse a word.

**Startup is not reset.** Simulation begins with `'U'` stages and hardware power-up is device-dependent. Reset clears the chain only when high at a rising edge; otherwise N known captures replace the unknown state.

**The receiver samples the pre-edge output.** A same-clock receiver captures the pre-edge `dout`; the post-edge output is available for the next capture. With `N=1`, `din` appears just after its capture edge.

**Check implementation mapping.** A requested reset may prevent synthesis from using a dedicated shift-register resource, so check the mapping for the chosen device and tool. Also provide an appropriate receiver or synchronizer before shifting a serial stream from another clock domain.

## Files

- [`siso_shift_right.vhd`](siso_shift_right.vhd): synthesizable reference template (VHDL-2008).
- [`tb_siso_shift_right.vhd`](tb_siso_shift_right.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit siso-shift-right
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_siso_shift_right`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_siso_shift_right`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `1`
- `5`
- `8`

Checks include:
- Serial history.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity siso_shift_right is
    generic (N : positive := 8);
    port (
        clk  : in  std_logic;
        rst  : in  std_logic;
        din  : in  std_logic;
        dout : out std_logic
    );
end entity siso_shift_right;
```

## Source traceability

- Book identikit: **7.1.2**.
- Book source: `components/siso-shift-right.tex`.
- RTL SHA-256 (UTF-8, LF): `07347f10789a4978110013245123dd786e2cc2e0d189b9ce6fa0d29d517763d6`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
