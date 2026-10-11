# 7.1.1 — SISO -- shift left

Samples one serial bit per rising edge, inserts it into bit 0, and moves every stored bit toward the most significant stage. The last stage is exposed as the serial output, producing an N-stage serial delay.

Companion to *FPGA Identikits* by Andrea Fato, group **7.1 — Serial I/O**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Name the direction by index.** This book calls motion from bit 0 toward bit `N-1` a left shift. Serial protocols may instead speak about LSB-first or MSB-first transmission, so document both entry and exit stages.

**Startup is not reset.** No initial state is declared, so simulation starts with `'U'` stages and hardware power-up is device-dependent. A synchronous reset clears the chain only when sampled at a rising edge; without reset, N known captures are needed to replace all startup values.

**Observe the correct side of the edge.** A same-clock downstream register samples the pre-edge value of `dout`; it captures $b$ at the edge after $b$ first appears at the output. For `N=1`, the newly captured input is visible immediately after the current edge.

**Check implementation mapping.** Dedicated shift-register resources are device- and tool-dependent and may not support the requested reset. Inspect the synthesized result. An asynchronous `din` still needs an appropriate synchronizer or receiver before reliable shifting.

## Files

- [`siso_shift_left.vhd`](siso_shift_left.vhd): synthesizable reference template (VHDL-2008).
- [`tb_siso_shift_left.vhd`](tb_siso_shift_left.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit siso-shift-left
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_siso_shift_left`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_siso_shift_left`; a failure assertion or timeout is a failure.
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
entity siso_shift_left is
    generic (N : positive := 8);
    port (
        clk  : in  std_logic;
        rst  : in  std_logic;
        din  : in  std_logic;
        dout : out std_logic
    );
end entity siso_shift_left;
```

## Source traceability

- Book identikit: **7.1.1**.
- Book source: `components/siso-shift-left.tex`.
- RTL SHA-256 (UTF-8, LF): `f6facd122777a9dab2ef9f6790e17d440e1c2684d556a5d6e7f2ee9af17ef8c5`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
