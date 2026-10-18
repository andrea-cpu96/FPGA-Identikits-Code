# 21.1.2 — Timing-isolating skid buffer

Stores stream words in an output register and a spare register. The spare captures one more accepted word when the consumer stalls. Both output data and validity are registered; input readiness depends only on stored state, breaking the combinational ready path between stages.

Companion to *FPGA Identikits* by Andrea Fato, group **20.1 — Ready/valid buffering**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Reserve space for delayed backpressure.** The spare catches one extra accepted word. A full buffer cannot accept on its first draining edge; readiness returns afterward. Output transfers can still continue every clock.

**Respect the handshake.** Use synchronous binary controls. Hold input valid/data while blocked, and keep sideband fields in the same stored word. The output holds valid/data during a stall.

**Coordinate reset.** Reset overrides transfers and discards pending words. Keep `in_valid` low and inhibit consumption on reset edges; ready may be high during reset. Invalid data bits are unspecified.

**Check the timing boundary.** Ready has no combinational path across this stage. Check the local register paths and routing after implementation. Both interfaces share one clock; this buffer does not synchronize clock domains.

## Files

- [`skid_buffer.vhd`](skid_buffer.vhd): synthesizable reference template (VHDL-2008).
- [`tb_skid_buffer.vhd`](tb_skid_buffer.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit timing-isolating-skid-buffer
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_skid_buffer`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_skid_buffer`; a failure assertion or timeout is a failure.
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
entity skid_buffer is
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
end entity skid_buffer;
```

## Source traceability

- Book identikit: **21.1.2**.
- Book source: `components/timing-isolating-skid-buffer.tex`.
- RTL SHA-256 (UTF-8, LF): `02ac2c510b63f47be944b707e8f83b2b2ac3cc05aabe47503ab6538294b5a2de`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
