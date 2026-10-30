# 8.1.2 — Down counter

Stores an N-bit unsigned value, subtracts one on every rising edge, and wraps from zero to all ones. A synchronous reset establishes zero, so the first ordinary edge demonstrates the underflow behavior.

Companion to *FPGA Identikits* by Andrea Fato, group **8.1 — Basic Counters**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Zero is not an automatic stop.** After reaching zero, the next subtraction wraps to the maximum value. Detecting zero does not stop the counter. For a countdown that completes and then waits, use a timer with explicit busy and completion behavior instead of this free-running block.

**Choose the reset value deliberately.** Resetting to zero means the first decrement jumps to the maximum. Reset to a preload value when a descending sequence must begin elsewhere.

**Reset must meet timing.** Synchronous `rst` must meet setup and hold requirements at `clk`.

**Underflow wraps to the largest value.** The state is not a negative number after underflow; it is the maximum unsigned code. Use `signed` only when two's-complement ordering is genuinely the contract.

**Pause with an enable, not clock gating.** If a paused variant is needed, add a synchronous clock-enable condition rather than gating the clock.

## Files

- [`down_counter.vhd`](down_counter.vhd): synthesizable reference template (VHDL-2008).
- [`tb_down_counter.vhd`](tb_down_counter.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit down-counter
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_down_counter`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_down_counter`; a failure assertion or timeout is a failure.
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
entity down_counter is
    generic (N : positive := 8);
    port (
        clk : in  std_logic;
        rst : in  std_logic;
        q   : out std_logic_vector(N-1 downto 0)
    );
end entity down_counter;
```

## Source traceability

- Book identikit: **8.1.2**.
- Book source: `components/down-counter.tex`.
- RTL SHA-256 (UTF-8, LF): `ed1ef58ff514599d47eb030beea5e776cfd5c6d27a2695bba18ef80a92419031`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
