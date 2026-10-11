# 2.1.1 — 3:8 decoder

Converts a three-bit binary index into an eight-bit one-hot vector. For every literal binary input, exactly one output bit is asserted and its position is the unsigned value of the input code.

Companion to *FPGA Identikits* by Andrea Fato, group **2.1 — Code selection and representation**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Keep the bit order explicit.** This template maps the numeric code directly to the output subscript: code zero selects `y(0)` and code seven selects `y(7)`. Reversing the external wiring changes the apparent numbering even though the VHDL remains type-correct.

**A combinational decode can glitch.** Several select bits may change at slightly different times in hardware, briefly activating an intermediate decode. Do not use ordinary decoder RTL as a glitchless clock, reset, or asynchronous strobe source. Register the result or constrain the receiving protocol when hazards matter.

**The fallback is a simulation policy.** The assertion exposes invalid control; the fallback only defines the simulated output. Neither can make a metastable hardware input safe. Apply the appropriate CDC (see the book's CDC appendix) scheme before decoding an asynchronous multi-bit value.

## Files

- [`decoder_3_to_8.vhd`](decoder_3_to_8.vhd): synthesizable reference template (VHDL-2008).
- [`tb_decoder_3_to_8.vhd`](tb_decoder_3_to_8.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit decoder-3-to-8
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_decoder_3_to_8`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_decoder_3_to_8`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `no generics`

Checks include:
- Decoder.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity decoder_3_to_8 is
    port (
        sel : in  std_logic_vector(2 downto 0);
        y   : out std_logic_vector(7 downto 0)
    );
end entity decoder_3_to_8;
```

## Source traceability

- Book identikit: **2.1.1**.
- Book source: `components/decoder-3-to-8.tex`.
- RTL SHA-256 (UTF-8, LF): `5f7ec64e68cb43b43c094446b1a7d58e087cd7af70bca47240a42764a8de699e`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
