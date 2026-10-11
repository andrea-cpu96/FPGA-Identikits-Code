# 8.2.3 — Saturating up/down counter

Counts while enabled but holds at zero on a downward request and at all ones on an upward request. The stored value therefore never wraps across a limit.

Companion to *FPGA Identikits* by Andrea Fato, group **8.2 — Up / Down**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Saturation loses excess events.** Additional upward requests at maximum or downward requests at zero are not remembered. Add overflow/underflow flags or wider bookkeeping if discarded demand matters.

**Use numeric comparisons.** Explicit zero and all-ones limits make the unsigned contract visible and avoid accidental signed tests.

**Treat controls as synchronous.** `rst`, `en`, and `dir` must meet setup and hold requirements at `clk`. Synchronizing independent event pulses can also lose their ordering; use a proper event-transfer protocol across domains.

**Boundary flags need a convention.** A level flag says the counter is at a limit; a pulse says an attempted crossing occurred. They are not interchangeable.

## Files

- [`saturating_up_down_counter.vhd`](saturating_up_down_counter.vhd): synthesizable reference template (VHDL-2008).
- [`tb_saturating_up_down_counter.vhd`](tb_saturating_up_down_counter.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit saturating-up-down-counter
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_saturating_up_down_counter`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_saturating_up_down_counter`; a failure assertion or timeout is a failure.
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
entity saturating_up_down_counter is
    generic (N : positive := 8);
    port (
        clk, rst : in  std_logic;
        en, dir  : in  std_logic;
        q        : out std_logic_vector(N-1 downto 0)
    );
end entity saturating_up_down_counter;
```

## Source traceability

- Book identikit: **8.2.3**.
- Book source: `components/saturating-up-down-counter.tex`.
- RTL SHA-256 (UTF-8, LF): `c9a80f41f2bd79241205a78b71eff8c5ab9cfacf753b8ef69fc764b64319e4d1`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
