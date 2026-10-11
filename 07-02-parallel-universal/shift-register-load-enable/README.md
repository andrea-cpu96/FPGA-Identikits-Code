# 7.2.3 — Shift register with load and enable

Loads an N-bit parallel word on command, then shifts toward higher indices only on enabled rising edges. A separate serial input enters bit 0, while an asynchronous active-high reset clears the state without waiting for a clock edge.

Companion to *FPGA Identikits* by Andrea Fato, group **7.2 — Parallel / Universal**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Asynchronous reset has asynchronous timing.** It clears without an edge, but physical hardware has propagation delay. Release must satisfy recovery and removal requirements; synchronize deassertion per the reset plan.

**Load wins over shifting.** When both are high at an edge, the full word is captured. `en` enables only shifting, so `en='0'` does not block a requested load.

**Constrain synchronous inputs.** `load` and `en` must meet setup and hold at `clk`; `d` must meet timing on load and `si` on shift.

**Direction is defined by index.** Shifting left moves old bit $i-1$ to bit $i$ for $1\le i\le N-1$, while `si` enters bit 0. At `N=1`, an enabled shift simply captures `si` into the sole stage.

**Reset can change resource mapping.** Parallel load, enable, observable taps, and especially asynchronous reset may prevent inference of dedicated shift-register resources. Expect flip-flops when required by the target, and inspect synthesis instead of assuming an SRL-style implementation.

## Files

- [`shift_register_load_enable.vhd`](shift_register_load_enable.vhd): synthesizable reference template (VHDL-2008).
- [`tb_shift_register_load_enable.vhd`](tb_shift_register_load_enable.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit shift-register-load-enable
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_shift_register_load_enable`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_shift_register_load_enable`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `1`
- `5`
- `8`

Checks include:
- Load shift hold.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity shift_register_load_enable is
    generic (N : positive := 8);
    port (
        clk  : in  std_logic;
        rst  : in  std_logic;
        d    : in  std_logic_vector(N-1 downto 0);
        si   : in  std_logic;
        load : in  std_logic;
        en   : in  std_logic;
        q    : out std_logic_vector(N-1 downto 0)
    );
end entity shift_register_load_enable;
```

## Source traceability

- Book identikit: **7.2.3**.
- Book source: `components/shift-register-load-enable.tex`.
- RTL SHA-256 (UTF-8, LF): `8e7c32119e5180b2b27b35a910e341ffc8f8947e279380bc76e0908da0e636cf`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
