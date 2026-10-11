# 7.3.1 — Ring counter

Stores an N-bit one-hot state: exactly one stage contains '1' and every other stage contains '0'. A synchronous reset creates that pattern. On each following rising edge, the '1' moves to the next stage; bit 0 wraps back to bit N-1, so the same '1' keeps circulating.

Companion to *FPGA Identikits* by Andrea Fato, group **7.3 — Feedback**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**One-hot is an invariant, not self-repair.** Rotation preserves the number of asserted bits. An all-zero or multi-hot corruption therefore keeps circulating until reset or explicit recovery logic restores a legal seed.

**Startup is not reset.** No initial value is declared. Simulation begins with unknown bits and hardware power-up is device-dependent; apply reset through a rising edge before using the phase outputs.

**Reset must meet timing.** Synchronous `rst` must meet setup and hold requirements at `clk`.

**Registered outputs avoid a decoder.** Each phase is a stored bit, so a separate binary-to-one-hot decoder is unnecessary. Physical clock-to-output skew still exists; do not treat the vector as an asynchronous hazard-free bus.

**Preserve the orientation.** This template calls the operation rotate right because bit 0 wraps into `N-1`. Reversing the vector convention reverses the visible phase order without changing the state count.

## Files

- [`ring_counter.vhd`](ring_counter.vhd): synthesizable reference template (VHDL-2008).
- [`tb_ring_counter.vhd`](tb_ring_counter.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit ring-counter
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_ring_counter`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_ring_counter`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `1`
- `5`
- `8`

Checks include:
- Ring.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity ring_counter is
    generic (N : positive := 8);
    port (
        clk : in  std_logic;
        rst : in  std_logic;
        q   : out std_logic_vector(N-1 downto 0)
    );
end entity ring_counter;
```

## Source traceability

- Book identikit: **7.3.1**.
- Book source: `components/ring-counter.tex`.
- RTL SHA-256 (UTF-8, LF): `f7f29e28e00142e45c6f2ed3f28f2975815d5d16884cbd11808f9715ba637abd`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
