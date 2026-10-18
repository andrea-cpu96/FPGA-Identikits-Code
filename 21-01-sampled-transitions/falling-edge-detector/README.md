# 22.1.2 — Falling-edge detector

Compares the current clock-domain input with its previous sample. A 1-to-0 change raises a registered pulse for one complete clock period; unchanged or rising samples leave it low.

Companion to *FPGA Identikits* by Andrea Fato, group **21.1 — Sampled transitions**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Present a clock-domain level.** This is not a synchronizer. An asynchronous input can violate sampling timing and make behavior uncertain. Synchronize a persistent external level first; debounce a contact before converting its accepted change into a pulse.

**Mind missed changes.** A high-low-high excursion entirely between clock edges cannot be detected. This output reports sampled history, not every physical transition on the pin.

**Control startup.** The zero initialization is part of this template's contract and must be supported by the FPGA flow. A reset can establish a known zero baseline; if the first sample must not be compared, capture it while detection is disabled instead.

**Keep the pulse synchronous.** Do not replace the registered comparison with `not d and d_prev`: that combinational output may respond between clock edges and need not last a full clock period. Invalid `std_logic` values may produce non-binary simulation results.

## Files

- [`falling_edge_detector.vhd`](falling_edge_detector.vhd): synthesizable reference template (VHDL-2008).
- [`tb_falling_edge_detector.vhd`](tb_falling_edge_detector.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit falling-edge-detector
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_falling_edge_detector`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_falling_edge_detector`; a failure assertion or timeout is a failure.
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
entity falling_edge_detector is
    port (
        clk  : in  std_logic;
        d    : in  std_logic;
        fall : out std_logic
    );
end entity falling_edge_detector;
```

## Source traceability

- Book identikit: **22.1.2**.
- Book source: `components/falling-edge-detector.tex`.
- RTL SHA-256 (UTF-8, LF): `7ed27505bfb0febed9ce8a759c147f424a909e50177c50618d769b436b9d4368`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
