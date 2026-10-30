# 20.1.2 — Pulse synchronizer

Turns each accepted source-clock event into a change of a stored bit. The destination synchronizes that bit and compares it with its previous synchronized value. An isolated change produces a one-destination-cycle pulse.

Companion to *FPGA Identikits* by Andrea Fato, group **20.1 — Levels, events, and reset release**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Specify the event-spacing budget.** Base the minimum spacing on the destination-clock period and synchronization uncertainty, with margin. Allow several destination periods between source events; RTL alone supplies no universal lossless rate. Use a handshake or FIFO if spacing cannot be guaranteed, or if the destination clock can stop while events arrive.

**One high source edge means one event.** Each source edge with `pulse_in` high toggles the stored bit. A held-high input therefore represents repeated events rather than one rising transition. At the destination, events detected on adjacent cycles can keep the output high continuously, without a low gap between pulses.

**Use the pulse synchronously.** The output XOR is combinational. Transitions on its two inputs can produce physical glitches; do not use it as a clock or asynchronous control. Only stages 0 and 1 form the resolving chain; stage 2 stores the previous synchronized value for event detection.

**Preserve synchronizer timing and startup.** Apply synchronizer attributes, placement, and timing constraints in the destination domain. Keep its stage-to-stage path timed. Unmatched initialization or resetting one side alone can invent or lose an event. The template has no run-time recovery protocol and no diagnostic for invalid source controls.

## Files

- [`pulse_synchronizer.vhd`](pulse_synchronizer.vhd): synthesizable reference template (VHDL-2008).
- [`tb_pulse_synchronizer.vhd`](tb_pulse_synchronizer.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit pulse-synchronizer
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_pulse_synchronizer`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_pulse_synchronizer`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `no generics`

Checks include:
- Pulse transfer count.
- Pulse width.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity pulse_synchronizer is
    port (
        clk_src, clk_dst : in std_logic;
        pulse_in : in std_logic;
        pulse_out : out std_logic
    );
end entity pulse_synchronizer;
```

## Source traceability

- Book identikit: **20.1.2**.
- Book source: `components/pulse-synchronizer.tex`.
- RTL SHA-256 (UTF-8, LF): `ba1cde8adca295b547c24774b6d0871c26a0798bcc46167dbb86f57d63f374c1`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
