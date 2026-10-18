# 20.1.3 — Reset synchronizer

Asserts an active-low reset without waiting for a clock. When the external reset returns high, two rising clock edges shift ones through a register chain before the local reset is released. Each destination clock domain needs its own reset-release chain.

Companion to *FPGA Identikits* by Andrea Fato, group **19.1 — Levels, events, and reset release**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Check asynchronous-reset pulse width.** The input must meet the device's minimum pulse-width and electrical requirements. RTL can respond to a pulse that is too short for hardware. Reassertion takes priority over shifting; this circuit does not filter reset glitches.

**Preserve the reset synchronizer.** Use the target's approved reset-CDC pattern, register attributes, and placement. Asynchronous release can violate recovery/removal at the chain input; the resolving interval reduces, but does not eliminate, the chance of an unsettled release reaching the domain.

**Constrain the output reset network.** Releasing after a clock edge does not automatically satisfy every downstream register's recovery/removal or synchronous-reset setup/hold limits. Budget clock skew, reset fanout and routing delay, and check the relevant timing reports.

**Release each domain locally.** Do not reuse a reset synchronized to one clock as the release signal for unrelated clocks. Coordinate interfaces when domains leave reset at different times. Two edges describe ideal RTL; metastability and clock startup can delay physical release.

## Files

- [`reset_synchronizer.vhd`](reset_synchronizer.vhd): synthesizable reference template (VHDL-2008).
- [`tb_reset_synchronizer.vhd`](tb_reset_synchronizer.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit reset-synchronizer
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_reset_synchronizer`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_reset_synchronizer`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `no generics`

Checks include:
- Asynchronous reset assertion.
- Early reset release.
- Reset release latency.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity reset_synchronizer is
    port (
        clk : in std_logic;
        arst_n : in std_logic;
        rst_sync_n : out std_logic
    );
end entity reset_synchronizer;
```

## Source traceability

- Book identikit: **20.1.3**.
- Book source: `components/reset-synchronizer.tex`.
- RTL SHA-256 (UTF-8, LF): `e8c02880f87bddd793cac3ebc7ad02c8e0987685009b5b45730205d55be19012`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
