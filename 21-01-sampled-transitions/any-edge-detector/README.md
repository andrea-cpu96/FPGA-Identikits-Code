# 22.1.3 — Any-edge detector

Compares the current clock-domain input with its previous sample. The registered output is high in each cycle whose sample changed in either direction. Consecutive changed samples can keep it high across cycles.

Companion to *FPGA Identikits* by Andrea Fato, group **22.1 — Sampled transitions**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Synchronize asynchronous inputs first.** The detector assumes its input already meets the local clock timing. An asynchronous input can violate that assumption, so first synchronize a persistent external level. For a mechanical contact, also debounce the synchronized level before converting accepted changes into pulses.

**Expect an event on every sampled toggle.** If the input alternates on consecutive edges, the output stays high across those adjacent event cycles; it is not guaranteed to have a low gap between separate events.

**Control startup.** The zero initialization is part of this template's contract and must be supported by the FPGA flow. Qualify the first sample if a high initial level must not count as a change; clearing history to zero with a reset alone would still report that first high sample.

**Keep the pulse synchronous.** Do not replace the registered comparison with `d xor d_prev`: that combinational output may respond between clock edges and need not last a full clock period. Invalid `std_logic` values may produce non-binary simulation results.

## Files

- [`any_edge_detector.vhd`](any_edge_detector.vhd): synthesizable reference template (VHDL-2008).
- [`tb_any_edge_detector.vhd`](tb_any_edge_detector.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit any-edge-detector
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_any_edge_detector`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_any_edge_detector`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `no generics`

Checks include:
- Edge detect.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity any_edge_detector is
    port (
        clk        : in  std_logic;
        d          : in  std_logic;
        edge_pulse : out std_logic
    );
end entity any_edge_detector;
```

## Source traceability

- Book identikit: **22.1.3**.
- Book source: `components/any-edge-detector.tex`.
- RTL SHA-256 (UTF-8, LF): `5d34d18af17c41bd25ce0e8aa670851ddef4a7d07f0204ea31d494bbf2db4a35`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
