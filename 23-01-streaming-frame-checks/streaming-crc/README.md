# 24.1.1 — Streaming CRC generator/checker

Updates a 16-bit remainder with one message bit on each enabled clock, each byte most significant bit first. The register holds the running CRC for a generator; once the appended CRC has also passed through, zero reports that the frame passes the CRC check.

Companion to *FPGA Identikits* by Andrea Fato, group **23.1 — Streaming frame checks**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Specify the complete profile.** Match width, polynomial representation, initial value, input order, output reflection, and final XOR; verify the check value.

**Match the input order.** Feed bytes MSB first. An LSB-first link can buffer bytes and reorder their bits; it does not require a reflected profile.

**Check the residue.** The default CRC, appended unmodified MSB first, leaves zero. Other profiles may share zero; check their residue, append order, and transformations.

**Assert `start` only at a frame boundary.** Holding it high reloads `INIT` every edge. With `en` high, that edge also processes the first bit. Read `crc` after the last message bit and before the next frame starts.

**Qualify `zero` with framing.** It continuously tests the remainder; it is not a frame-complete pulse. Check it only after the expected message and appended CRC have been accepted. Zero does not prove absence of corruption: some error patterns go undetected.

## Files

- [`crc16_serial.vhd`](crc16_serial.vhd): synthesizable reference template (VHDL-2008).
- [`tb_crc16_serial.vhd`](tb_crc16_serial.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit streaming-crc
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_crc16_serial`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_crc16_serial`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `default CRC-16/IBM-3740 profile`

Checks include:
- 123456789 check value.
- Appended CRC residue.
- Frame restart.
- Hold.
- Reset.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity crc16_serial is
    generic (
        POLY : std_logic_vector(15 downto 0) := x"1021";
        INIT : std_logic_vector(15 downto 0) := x"FFFF"
    );
    port (
        clk, rst : in  std_logic;
        start    : in  std_logic;
        en, din  : in  std_logic;
        crc      : out std_logic_vector(15 downto 0);
        zero     : out std_logic
    );
end entity crc16_serial;
```

## Source traceability

- Book identikit: **24.1.1**.
- Book source: `components/streaming-crc.tex`.
- RTL SHA-256 (UTF-8, LF): `c5dcedcad6e5cb8eaef9c49a4a780f4ac3d2f2cb63ed42db00e11433d45b6bdd`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
