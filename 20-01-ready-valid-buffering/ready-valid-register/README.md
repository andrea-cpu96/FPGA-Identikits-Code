# 20.1.1 — Ready/valid register

Registers one stream word and its valid flag between a producer and a consumer. It accepts a new word whenever it is empty or its word is being taken in the same cycle, so it sustains one word per clock and holds its output during a stall.

Companion to *FPGA Identikits* by Andrea Fato, group **20.1 — Ready/valid buffering**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**The ready path is combinational.** `in_ready` follows `out_ready` through one gate, so chained stages form one long ready path. The timing-isolating skid buffer (20.1.2) adds a spare entry and readiness derived from registered state.

**Keep the handshake rules.** Upstream holds `in_valid` and `in_data` until accepted and never derives `in_valid` from `in_ready`. The stage holds its output the same way.

**Keep `in_valid` low during reset.** Reset clears only the valid flag. `in_ready` can read high while `rst` is held, but the reset branch takes nothing, so an offered word would be lost.

**Allow for occupancy.** Minimum transfer latency is one cycle; a stall can retain a word indefinitely. Backpressure propagates through full stages with gate delay. An empty stage absorbs one word even if `out_ready=0`.

## Files

- [`rv_register.vhd`](rv_register.vhd): synthesizable reference template (VHDL-2008).
- [`tb_rv_register.vhd`](tb_rv_register.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit ready-valid-register
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_rv_register`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_rv_register`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `16`

Checks include:
- Queue drain.
- Queue head/stalled data.
- Queue validity after edge.
- Queue validity pre-edge.
- Stored head.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity rv_register is
    generic (WIDTH : positive := 8);
    port (
        clk, rst  : in  std_logic;
        in_valid  : in  std_logic;
        in_data   : in  std_logic_vector(WIDTH-1 downto 0);
        in_ready  : out std_logic;
        out_valid : out std_logic;
        out_data  : out std_logic_vector(WIDTH-1 downto 0);
        out_ready : in  std_logic
    );
end entity rv_register;
```

## Source traceability

- Book identikit: **20.1.1**.
- Book source: `components/ready-valid-register.tex`.
- RTL SHA-256 (UTF-8, LF): `628c2efa0dd1422090b9371fa191b9447b0aac0d58d23ffdfaaef7b3d0f2e32f`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
