# 7.3.3 — 16-bit Fibonacci LFSR

Generates a deterministic pseudorandom binary sequence by XORing selected stages into one feedback bit and shifting it into the most significant stage. The documented nonzero seed traverses all 65,535 nonzero states.

Companion to *FPGA Identikits* by Andrea Fato, group **7.3 — Feedback**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Taps depend on direction and indexing.** The polynomial alone does not identify source-code bit numbers. These taps are correct for a descending vector shifted toward bit 0 with feedback entering bit 15.

**Never use the zero seed.** Reset deliberately loads a nonzero word. Any configurable-seed variant must reject or replace zero, and recovery from an injected zero state requires explicit logic or another reset.

**Reset must meet timing.** Synchronous `rst` must meet setup and hold requirements at `clk`.

**Startup is not reset.** No declaration-time value is used. Simulation starts unknown and hardware power-up is device-dependent; sample reset at a rising edge before consuming the sequence.

**Pseudorandom is not secure random.** An LFSR is linear, deterministic, and recoverable from enough output. Use it for test, coding, and pattern generation, not for secrets or cryptographic randomness.

## Files

- [`lfsr_fibonacci_16.vhd`](lfsr_fibonacci_16.vhd): synthesizable reference template (VHDL-2008).
- [`tb_lfsr_fibonacci_16.vhd`](tb_lfsr_fibonacci_16.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit lfsr-fibonacci-16
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_lfsr_fibonacci_16`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_lfsr_fibonacci_16`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `fixed 16-bit recurrence`

Checks include:
- Maximal nonzero cycle.
- Period 65535.
- Recurrence.
- Reset seed.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity lfsr_fibonacci_16 is
    port (
        clk : in  std_logic;
        rst : in  std_logic;
        q   : out std_logic_vector(15 downto 0)
    );
end entity lfsr_fibonacci_16;
```

## Source traceability

- Book identikit: **7.3.3**.
- Book source: `components/lfsr-fibonacci-16.tex`.
- RTL SHA-256 (UTF-8, LF): `fb1c034dea546b66f856955aaa7c3ee703ae7a4e87e26a88580fa6701cca1cc7`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
