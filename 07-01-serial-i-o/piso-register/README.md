# 7.1.4 — PISO register

Loads an N-bit word on command and exposes bit 0 as the serial output. Each enabled shift discards the transmitted bit, moves the remaining word toward bit 0, and inserts zero at the most significant position.

Companion to *FPGA Identikits* by Andrea Fato, group **7.1 — Serial I/O**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**State the sampling convention.** At a sampling/shift edge, the receiver captures the pre-edge bit and the PISO then exposes the next bit. In a testbench, sample before applying the edge or wait for the update and compare against the bit saved from the preceding cycle.

**Constrain the sampled inputs.** `load`, `shift`, and synchronous `rst` must meet setup and hold at `clk`. When `load='1'`, every bit of `d` must be stable across the edge.

**Startup is not reset.** Simulation begins at `'U'` and hardware power-up is device-dependent. A known reset, a known parallel load, or N zero-filling shifts establishes known state. Load wins over shift.

**Framing and bit order are external.** Add count and handshake logic for an exact transaction. The default LSB-first stream is reversed by the default SIPO after N captures; change one direction or ordering when reconstructing the original word.

**Check implementation mapping.** Parallel load, reset, enables, and visible outputs influence whether dedicated shift-register resources can be used. Mapping depends on device and synthesis tool. Zero fill empties the register after N shifts.

## Files

- [`piso_register.vhd`](piso_register.vhd): synthesizable reference template (VHDL-2008).
- [`tb_piso_register.vhd`](tb_piso_register.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit piso-register
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_piso_register`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_piso_register`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `1`
- `5`
- `8`

Checks include:
- Load shift hold.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity piso_register is
    generic (N : positive := 8);
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        d     : in  std_logic_vector(N-1 downto 0);
        load  : in  std_logic;
        shift : in  std_logic;
        so    : out std_logic
    );
end entity piso_register;
```

## Source traceability

- Book identikit: **7.1.4**.
- Book source: `components/piso-register.tex`.
- RTL SHA-256 (UTF-8, LF): `6b0c476c0dcd329a6b27d2d35de48f68e901f2d4a8b9c4722aac892c1ee8bd53`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
