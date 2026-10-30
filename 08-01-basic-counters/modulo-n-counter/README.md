# 8.1.3 — Modulo-N counter

Counts upward from zero through MOD_VAL-1, then returns to zero. Unlike natural binary overflow, the sequence length need not be a power of two.

Companion to *FPGA Identikits* by Andrea Fato, group **8.1 — Basic Counters**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Prove the value fits the width.** The template asserts `MOD_VAL <= 2**N`; otherwise the terminal code cannot be represented. The upper bound on `N` keeps that elaboration expression within the minimum VHDL integer range.

**Define illegal-state recovery.** If a fault puts the count above the terminal value, an equality-only test will miss it and counting will continue until binary overflow. This template uses `>=`, so the next active edge restores zero. Unknown simulation values still require separate diagnosis.

**Reset must meet timing.** Synchronous `rst` must meet setup and hold requirements at `clk`.

**The period is measured in edges.** During normal counting with reset inactive, exactly `MOD_VAL` rising edges separate successive zero states. A terminal decode and a registered tick may differ by one cycle; state the observation convention.

**Prefer an enable to a derived clock.** Use the wrap event as a one-cycle enable for same-clock logic, not as a fabric-generated clock.

## Files

- [`modulo_n_counter.vhd`](modulo_n_counter.vhd): synthesizable reference template (VHDL-2008).
- [`tb_modulo_n_counter.vhd`](tb_modulo_n_counter.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit modulo-n-counter
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_modulo_n_counter`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_modulo_n_counter`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `1,2**1`
- `3,2**3`

Checks include:
- Modulo at full range.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity modulo_n_counter is
    generic (
        N       : positive range 1 to 30 := 8;
        MOD_VAL : positive := 10
    );
    port (
        clk : in  std_logic;
        rst : in  std_logic;
        q   : out std_logic_vector(N-1 downto 0)
    );
end entity modulo_n_counter;
```

## Source traceability

- Book identikit: **8.1.3**.
- Book source: `components/modulo-n-counter.tex`.
- RTL SHA-256 (UTF-8, LF): `ed8c3d403776392b65f1bb2cf26f466de4d9e90fa05d86b82a4d3731eb5351fa`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
