# 4.1.4 — Seven-segment decoder

Maps a four-bit hexadecimal digit to seven active-high segment controls in abcdefg order. The reference glyphs use uppercase A, C, E, and F and lowercase-style b and d for readable hexadecimal display.

Companion to *FPGA Identikits* by Andrea Fato, group **4.1 — Representation, checking, and display**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Match electrical polarity.** The table is active high and naturally describes common-cathode logic. Many boards use common-anode displays or active-low drivers; invert the complete pattern at a clearly documented boundary instead of changing individual rows.

**Keep order and wiring together.** Check that `abcdefg`, the vector indices, connector pins and physical segments all use the same order. If the board wiring differs from the lookup table, the decoder can produce recognizable but incorrect characters even though the table itself is correct.

**Limit segment current and control scanning.** Limit current in each segment path with suitable resistors or drivers, within both device and display ratings. For multiplexed digits, use digit enables and a timed scan controller; this combinational decoder alone does not provide multiplexing or brightness control.

**Sequence digit handover.** Registering the pattern alone does not prevent ghosting. A scan controller should disable the current digit, update the segment pattern, allow the signals to settle, and only then enable the next digit. This decoder supplies the pattern; the controller owns that sequence.

## Files

- [`seven_segment_decoder.vhd`](seven_segment_decoder.vhd): synthesizable reference template (VHDL-2008).
- [`tb_seven_segment_decoder.vhd`](tb_seven_segment_decoder.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit seven-segment-decoder
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_seven_segment_decoder`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_seven_segment_decoder`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `no generics`

Checks include:
- Segments.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity seven_segment_decoder is
    port (
        digit    : in  std_logic_vector(3 downto 0);
        segments : out std_logic_vector(6 downto 0)
    );
end entity seven_segment_decoder;
```

## Source traceability

- Book identikit: **4.1.4**.
- Book source: `components/seven-segment-decoder.tex`.
- RTL SHA-256 (UTF-8, LF): `9cbb932d8101ff7109cf7e8af1c8b157d50e1f31c4baa4f7a835857386cd41de`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
