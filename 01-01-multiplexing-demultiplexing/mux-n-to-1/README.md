# 1.1.2 — N:1 multiplexer

Selects one of N equal-width data words using a binary index. All input words are packed into a single vector, while generics define the number of sources, the width of each word, and the width of the select index.

Companion to *FPGA Identikits* by Andrea Fato, group **1.1 — Data selection and distribution**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Size and decode the index explicitly.** Keep `SEL_WIDTH` in 1--30 and require `SEL_WIDTH >= max(1, ceil(log2(N)))`; the template checks `N <= 2**SEL_WIDTH`. Each legal binary code selects one word, with no priority between sources. Check for literal `'0'`/`'1'` bits before numeric conversion.

**Reserve `when others` for a fallback.** In an explicit `case` or selected assignment, name every legal route's binary code. Using `others` for the last source also selects it for unknown or weak control values. The indexed template instead checks validity and range, leaving zero for rejected values.

**Separate width from tree depth.** Increasing W adds parallel bit paths and routing load without necessarily adding logic levels. Increasing N, or cascading muxes, can instead deepen the selection tree. Because LUT size and synthesis affect the final structure, check area and timing rather than assuming one RTL expression becomes one logic stage.

**Preserve packing and capture timing.** Word 0 occupies the least-significant W bits, so the producer and consumer must use the same packing order. The index must also remain stable around capture. If data or control is asynchronous, use a coherent CDC (see the book's CDC appendix) transfer: the simulation fallback cannot protect against metastability.

## Files

- [`mux_n_to_1.vhd`](mux_n_to_1.vhd): synthesizable reference template (VHDL-2008).
- [`tb_mux_n_to_1.vhd`](tb_mux_n_to_1.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit mux-n-to-1
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_mux_n_to_1`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_mux_n_to_1`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `1,4,3`
- `4,4,3`
- `5,4,3`

Checks include:
- Mux fallback.
- Mux route.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity mux_n_to_1 is
    generic (
        N         : positive := 4;
        W         : positive := 8;
        SEL_WIDTH : positive range 1 to 30 := 2
    );
    port (
        d   : in  std_logic_vector(N*W-1 downto 0);
        sel : in  std_logic_vector(SEL_WIDTH-1 downto 0);
        y   : out std_logic_vector(W-1 downto 0)
    );
end entity mux_n_to_1;
```

## Source traceability

- Book identikit: **1.1.2**.
- Book source: `components/mux-n-to-1.tex`.
- RTL SHA-256 (UTF-8, LF): `78a184d583eb101c66ee2930fcb836370fe45725d93cfcc7f5e9e6167b0de050`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
