# 4.1.6 — Binary to BCD

Converts an eight-bit unsigned binary value into three packed decimal digits. Each four-bit group represents one digit from zero to nine; the output is not an ordinary twelve-bit binary number or a display segment pattern.

Companion to *FPGA Identikits* by Andrea Fato, group **4.1 — Representation, checking, and display**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Do not read packed BCD as binary.** The pattern `0x255` means decimal 255; read as a plain binary number it would be 597. Each nibble can feed a decimal-only digit decoder; remove leading zeros at the display boundary, not in this mapping.

**Keep the range explicit.** The largest legal input is 255 and needs three digits. A wider source must be checked or resized before this block; truncating its upper bits silently changes its value.

**Budget the conversion path.** Eight add-three/shift stages form combinational logic. For a wider input or tighter timing, an iterative clocked converter or pipeline may trade latency for a shorter stage delay.

**Treat invalid simulation bits explicitly.** A meta-value does not represent an unsigned number. The template warns and drives zero until the input becomes literal binary again. This fallback cannot repair metastability; establish a coherent input first.

## Files

- [`binary_to_bcd.vhd`](binary_to_bcd.vhd): synthesizable reference template (VHDL-2008).
- [`tb_binary_to_bcd.vhd`](tb_binary_to_bcd.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit binary-to-bcd
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_binary_to_bcd`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_binary_to_bcd`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `no generics`

Checks include:
- BCD.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity binary_to_bcd is
    port (
        binary_in : in  std_logic_vector(7 downto 0);
        bcd_out   : out std_logic_vector(11 downto 0)
    );
end entity binary_to_bcd;
```

## Source traceability

- Book identikit: **4.1.6**.
- Book source: `components/binary-to-bcd.tex`.
- RTL SHA-256 (UTF-8, LF): `33e6221c073b915d8de90b28f745645c22182f0d2999e6d152f795f187d2cc8d`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
