# 22.1.1 — Rising-edge detector

Compares the current clock-domain input with its previous sample. A 0-to-1 change raises a registered pulse for one complete clock period; unchanged or falling samples leave it low.

Companion to *FPGA Identikits* by Andrea Fato, group **22.1 — Sampled transitions**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Synchronize asynchronous inputs first.** The detector assumes its input already meets the local clock timing. An asynchronous input can violate that assumption, so first synchronize a persistent external level. For a mechanical contact, also debounce the synchronized level before converting accepted changes into pulses.

**Mind missed changes.** A low-high-low excursion entirely between clock edges cannot be detected. A one-clock pulse here reports sampled history, not every physical transition on the pin.

**Decide whether an initial high counts.** The zero initialization is part of this template's contract and must be supported by the FPGA flow. If a high initial level must not count as an event, capture one baseline sample while detection is disabled; resetting `d_prev` to zero alone does not suppress it.

**Keep the pulse synchronous.** Do not replace the registered comparison with `d and not d_prev`: that combinational output may respond between clock edges and need not last a full clock period. Invalid `std_logic` values may produce non-binary simulation results.

## Files

- [`rising_edge_detector.vhd`](rising_edge_detector.vhd): synthesizable reference template (VHDL-2008).
- [`tb_rising_edge_detector.vhd`](tb_rising_edge_detector.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit rising-edge-detector
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_rising_edge_detector`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_rising_edge_detector`; a failure assertion or timeout is a failure.
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
entity rising_edge_detector is
    port (
        clk  : in  std_logic;
        d    : in  std_logic;
        rise : out std_logic
    );
end entity rising_edge_detector;
```

## Source traceability

- Book identikit: **22.1.1**.
- Book source: `components/rising-edge-detector.tex`.
- RTL SHA-256 (UTF-8, LF): `567a135b074fbaa6fb595ee6c803d965f0ccc7eabcda6e324bbf917478d5b499`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
