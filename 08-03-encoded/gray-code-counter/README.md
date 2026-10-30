# 8.3.1 — Gray-code counter

Maintains a binary count and registers its next reflected-Gray value on the same rising edge. Adjacent ordinary count outputs, including wrap, differ in exactly one bit.

Companion to *FPGA Identikits* by Andrea Fato, group **8.3 — Encoded**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Gray code reduces ambiguity; it is not a synchronizer.** For a CDC (see the book's CDC appendix) pointer, the source Gray value must be registered, every bit must pass through destination-domain synchronizers, and timing constraints must prevent skew from mixing successive source updates at the destination. Choose delay/skew limits for the source update rate and CDC implementation; verify them after routing.

**Reset is an exception to adjacency.** Resetting an arbitrary count to zero can change several Gray bits, so it is not an ordinary count step. Coordinate reset and pointer validity across domains.

**Do not perform ordinary arithmetic on Gray values.** Convert a coherent Gray sample back to binary before subtraction, range tests, or occupancy calculation.

**Reset must meet timing.** Synchronous `rst` must meet setup and hold requirements at `clk`.

**Recheck a modified sequence.** Discarding bits can make different counts look identical, although it cannot increase how many bits change between adjacent source codes. Changing the modulus can also introduce a multi-bit wrap. If you alter the sequence, check every transition, including wrap, against the intended CDC use.

## Files

- [`gray_code_counter.vhd`](gray_code_counter.vhd): synthesizable reference template (VHDL-2008).
- [`tb_gray_code_counter.vhd`](tb_gray_code_counter.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit gray-code-counter
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_gray_code_counter`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_gray_code_counter`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `1`
- `4`
- `8`

Checks include:
- Gray counter.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity gray_code_counter is
    generic (N : positive := 8);
    port (
        clk  : in  std_logic;
        rst  : in  std_logic;
        gray : out std_logic_vector(N-1 downto 0)
    );
end entity gray_code_counter;
```

## Source traceability

- Book identikit: **8.3.1**.
- Book source: `components/gray-code-counter.tex`.
- RTL SHA-256 (UTF-8, LF): `266c533405cb4f3c99bcb759b111f6e1f60aef1156ca508ee7e885f3d34bcedc`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
