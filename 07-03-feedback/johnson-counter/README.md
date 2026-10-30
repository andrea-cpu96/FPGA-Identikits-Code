# 7.3.2 — Johnson counter

Shifts the stored word toward bit 0 and feeds the complement of the outgoing bit back into stage N-1. From the all-zero reset state, runs of ones fill the register and then runs of zeros empty it.

Companion to *FPGA Identikits* by Andrea Fato, group **7.3 — Feedback**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Reset establishes the 2N-state cycle.** The counter visits 2N states when it starts in the intended cycle, which reset establishes. An arbitrary or corrupted state may enter a different cycle and keep circulating there. Use reset or recovery logic if the design must return to the legal sequence.

**Startup is not reset.** No initial state is declared. Apply the synchronous reset through a rising edge before interpreting the phase pattern; hardware power-up behavior depends on the target device.

**Reset must meet timing.** Synchronous `rst` must meet setup and hold requirements at `clk`.

**One-bit sequence changes aid decoding.** Adjacent legal states differ in one registered bit, which simplifies phase decoding. Clock-to-output skew and downstream combinational logic still determine physical glitch behavior.

**Tap orientation defines the sequence.** This form shifts toward bit 0 and inserts `not q(0)` at `N-1`. Moving the inversion or changing direction produces a different, though potentially equivalent, convention.

## Files

- [`johnson_counter.vhd`](johnson_counter.vhd): synthesizable reference template (VHDL-2008).
- [`tb_johnson_counter.vhd`](tb_johnson_counter.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit johnson-counter
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_johnson_counter`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_johnson_counter`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `1`
- `5`
- `8`

Checks include:
- Johnson.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity johnson_counter is
    generic (N : positive := 8);
    port (
        clk : in  std_logic;
        rst : in  std_logic;
        q   : out std_logic_vector(N-1 downto 0)
    );
end entity johnson_counter;
```

## Source traceability

- Book identikit: **7.3.2**.
- Book source: `components/johnson-counter.tex`.
- RTL SHA-256 (UTF-8, LF): `b307ed69220c827d21fb9f2a443a8ced97cc3f5cd9b2434c9933002a9014f9ae`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
