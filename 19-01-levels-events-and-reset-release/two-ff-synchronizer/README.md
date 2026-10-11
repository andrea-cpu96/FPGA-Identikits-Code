# 19.1.1 — Two-FF synchronizer

Samples an asynchronous level through two registers on the destination clock. The first stage may become metastable; the time before the second stage samples it reduces the chance that an unsettled value reaches downstream logic.

Companion to *FPGA Identikits* by Andrea Fato, group **19.1 — Levels, events, and reset release**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Preserve the resolving interval.** Use the target's synchronizer attributes and placement guidance; prevent retiming or shift-register extraction. Keep the stage-to-stage route short and timed. Exempt the asynchronous entry path as appropriate, not the path between the two registers.

**Do not use the first stage elsewhere.** Feed only the next stage from its output. Extra fanout or combinational logic can compromise implementation. If a source clock exists, register the source level to avoid glitches and unnecessary input transitions.

**A bus needs a protocol.** Independent synchronizers on each bit do not preserve word coherence. Use a handshake, a suitably constrained Gray representation, or an asynchronous FIFO for multi-bit information. Even a single-bit event needs a different scheme if its pulse may be missed.

**Check reliability and startup.** Two stages reduce but do not eliminate metastability risk. Use device data, clock and toggle rates, and available settling time to assess mean time between failures. Initial zero is not proof that the external input is low; it takes time for its real level to arrive.

## Files

- [`two_ff_synchronizer.vhd`](two_ff_synchronizer.vhd): synthesizable reference template (VHDL-2008).
- [`tb_two_ff_synchronizer.vhd`](tb_two_ff_synchronizer.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit two-ff-synchronizer
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_two_ff_synchronizer`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_two_ff_synchronizer`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `no generics`

Checks include:
- Two FF latency.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity two_ff_synchronizer is
    port (
        clk : in std_logic;
        async_in : in std_logic;
        sync_out : out std_logic
    );
end entity two_ff_synchronizer;
```

## Source traceability

- Book identikit: **19.1.1**.
- Book source: `components/two-ff-synchronizer.tex`.
- RTL SHA-256 (UTF-8, LF): `de0d517e28cc7a7238e0256f05ec00c771ab82c931deee1c136c9213ab107f38`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
