# 2.1.3 — N-output decoder

Converts a binary index into one of N active-high output lines. Set N through a VHDL generic when instantiating the block; the template derives the index width automatically. An unused binary code selects no output.

Companion to *FPGA Identikits* by Andrea Fato, group **2.1 — Code selection and representation**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Configure at elaboration.** The generic determines the hardware size; it is not a control input. Connect an index vector of the derived width. The package computes that width using integer division, including the one-line case.

**Check before converting.** The template rejects non-binary index bits before numeric conversion, then checks the range before indexing `y`. The upper bound on `N` keeps the index within 30 bits.

**Keep selection and timing separate.** A changing binary index can briefly activate an unintended output in hardware. Use the decoder for settled data selection, not as a glitchless clock or reset source. Register the result when the receiving interface requires it.

**Plan for realistic sizes.** The generic range is a numeric limit, not a promise that every size fits an FPGA. Check resource use and routing delay. Transfer asynchronous addresses coherently before decoding them.

## Files

- [`decoder_n.vhd`](decoder_n.vhd): synthesizable reference template (VHDL-2008).
- [`tb_decoder_n.vhd`](tb_decoder_n.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit decoder-n
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_decoder_n`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_decoder_n`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `1`
- `16`
- `2`
- `3`
- `5`
- `8`

Checks include:
- Decoder binary selection or unused code.
- Decoder nonliteral selector must reject.
- Decoder recovery after nonliteral input.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity decoder_n is
    generic (N : positive range 1 to 1073741824 := 8);
    port (
        sel : in  std_logic_vector(index_width(N)-1 downto 0);
        y   : out std_logic_vector(N-1 downto 0)
    );
end entity decoder_n;
```

## Source traceability

- Book identikit: **2.1.3**.
- Book source: `components/decoder-n.tex`.
- RTL SHA-256 (UTF-8, LF): `f57e6aea730aab156a91fe00cc77339442b4e010031a2f6592d3655960c564c4`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
