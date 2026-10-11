# 8.1.1 — Free-running up counter

Stores an N-bit unsigned value, increments it on every rising edge, and wraps from all ones to zero. A synchronous reset establishes the zero state.

Companion to *FPGA Identikits* by Andrea Fato, group **8.1 — Basic Counters**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Wrap is part of the arithmetic.** The N-bit `unsigned` result discards carry-out, so the period is exactly $2^N$. Use an explicit terminal test when the required modulus is not a power of two.

**Apply reset through an edge.** Without a sampled reset, simulation starts unknown and the hardware startup value is device-dependent.

**Decode with timing in mind.** A combinational comparison of a changing counter may glitch while bits settle. Register terminal events when an exact same-clock pulse is required. If the event crosses into another clock domain, use an appropriate CDC scheme.

**Do not use a counter bit as a new fabric clock.** Prefer a clock-enable pulse so all consuming logic remains on the primary clock network.

## Files

- [`free_running_up_counter.vhd`](free_running_up_counter.vhd): synthesizable reference template (VHDL-2008).
- [`tb_free_running_up_counter.vhd`](tb_free_running_up_counter.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit free-running-up-counter
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_free_running_up_counter`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_free_running_up_counter`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `1`
- `4`
- `8`

Checks include:
- Counter.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity free_running_up_counter is
    generic (N : positive := 8);
    port (
        clk : in  std_logic;
        rst : in  std_logic;
        q   : out std_logic_vector(N-1 downto 0)
    );
end entity free_running_up_counter;
```

## Source traceability

- Book identikit: **8.1.1**.
- Book source: `components/free-running-up-counter.tex`.
- RTL SHA-256 (UTF-8, LF): `edf0b9a0272cd89155b1bc3df8017857ac75e907244c5ae0cab4cd09ad763b44`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
