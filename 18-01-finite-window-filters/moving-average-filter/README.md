# 18.1.1 — Moving average filter

Forms the mean of the most recent $L=2^K$ signed samples. Each enabled edge replaces the oldest sample and updates a running sum. The first valid result appears when the window is full; subsequent accepted samples each produce another result.

Companion to *FPGA Identikits* by Andrea Fato, group **18.1 — Finite-window filters**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Advance only on accepted samples.** The filter advances in sample time, not on every clock. A pause in `ce` preserves the entire window. It holds `dout` and clears `valid`; continuously asserted valid therefore means a new result on every clock.

**Keep the sum wide.** The W+K-bit signed sum accommodates all L full-scale samples. Arithmetic right shift implements division with downward rounding, so a sum of $-1$ produces $-1$, not zero.

**Choose the window for the signal.** A larger window smooths rapid changes but spreads a step over more samples. It also needs more sample storage. Resetting every history element makes this a register-based reference; large windows need a memory-oriented implementation.

**Respect the sample interface.** Supply coherent binary data and synchronous controls. Reset has priority over an offered sample. The subtract-add path must meet the clock period; this template contains no backpressure.

## Files

- [`moving_average_filter.vhd`](moving_average_filter.vhd): synthesizable reference template (VHDL-2008).
- [`tb_moving_average_filter.vhd`](tb_moving_average_filter.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit moving-average-filter
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_moving_average_filter`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_moving_average_filter`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `1,1`
- `16,2`
- `4,1`
- `4,10`
- `8,2`
- `8,4`

Checks include:
- Accepted sample model, reset priority, numerical precision or output hold.
- Startup validity or disabled-cycle valid pulse.
- Synchronous outputs changed before clock edge.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity moving_average_filter is
    generic (W : positive := 16;
             K : positive range 1 to 10 := 2);
    port (clk, rst, ce : in std_logic;
          din : in signed(W-1 downto 0);
          dout : out signed(W-1 downto 0);
          valid : out std_logic);
end entity moving_average_filter;
```

## Source traceability

- Book identikit: **18.1.1**.
- Book source: `components/moving-average-filter.tex`.
- RTL SHA-256 (UTF-8, LF): `a7e181e16736a2c9a790de91d0119050c89186a684b79f764bbe2df75ef9fa89`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
