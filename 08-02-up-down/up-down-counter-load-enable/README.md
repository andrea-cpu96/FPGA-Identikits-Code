# 8.2.2 — Up/down counter with load and enable

Combines a parallel preload with enable-gated bidirectional counting. At each rising edge the priority is reset, load, enabled count, then hold.

Companion to *FPGA Identikits* by Andrea Fato, group **8.2 — Up / Down**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Document priority at the interface.** Simultaneous requests are not ambiguous here: reset wins, then load, then count. A different order changes observable behavior and is a different component.

**Constrain the sampled inputs.** Synchronous `rst`, `load`, and `en` must meet setup and hold at `clk`. When counting, `dir` must also meet timing; when loading, `d` must be stable across that edge. For another clock domain, transfer the word with a handshake; independent bit synchronizers can create a mixed value.

**Validate only controls that matter.** An invalid `dir` is relevant only while counting. The template warns and holds in that case; while loading or disabled it does not inspect direction.

**Enable is not clock gating.** It controls the register data path and preserves use of the dedicated clock network.

## Files

- [`up_down_counter_load_enable.vhd`](up_down_counter_load_enable.vhd): synthesizable reference template (VHDL-2008).
- [`tb_up_down_counter_load_enable.vhd`](tb_up_down_counter_load_enable.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit up-down-counter-load-enable
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_up_down_counter_load_enable`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_up_down_counter_load_enable`; a failure assertion or timeout is a failure.
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
entity up_down_counter_load_enable is
    generic (N : positive := 8);
    port (
        clk, rst : in  std_logic;
        load, en : in  std_logic;
        dir      : in  std_logic;
        d        : in  std_logic_vector(N-1 downto 0);
        q        : out std_logic_vector(N-1 downto 0)
    );
end entity up_down_counter_load_enable;
```

## Source traceability

- Book identikit: **8.2.2**.
- Book source: `components/up-down-counter-load-enable.tex`.
- RTL SHA-256 (UTF-8, LF): `c0f0ce23370ecff44a3e3859b17eb067aed13fa33795d2713cf2f21338206c30`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
