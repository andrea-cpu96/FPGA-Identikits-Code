# 9.1.1 — One-shot countdown timer

Accepts a start request with an N-bit delay, counts down once per rising edge, and emits a one-cycle done pulse when the interval completes.

Companion to *FPGA Identikits* by Andrea Fato, group **9.1 — Intervals & Timeouts**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**State the off-by-one convention.** Loading, first decrement, and pulse placement must be described relative to edges. The example and template use the start edge as time zero.

**Define retrigger behavior.** Start has priority over an active countdown and replaces it. A non-retriggerable timer should ignore or flag starts while busy.

**Keep completion registered.** Counter carry propagation cannot glitch `done`. Isolated events last one cycle; consecutive events can keep it high.

**Time requests coherently.** Meet setup/hold for `rst`, `start`, and the accepted `d`. Across domains, transfer `start` and `d` together with a handshake.

## Files

- [`one_shot_countdown_timer.vhd`](one_shot_countdown_timer.vhd): synthesizable reference template (VHDL-2008).
- [`tb_one_shot_countdown_timer.vhd`](tb_one_shot_countdown_timer.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit one-shot-countdown-timer
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_one_shot_countdown_timer`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_one_shot_countdown_timer`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `1`
- `4`
- `8`

Checks include:
- Countdown.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity one_shot_countdown_timer is
    generic (N : positive := 8);
    port (
        clk, rst : in  std_logic;
        start    : in  std_logic;
        d        : in  std_logic_vector(N-1 downto 0);
        busy     : out std_logic;
        done     : out std_logic
    );
end entity one_shot_countdown_timer;
```

## Source traceability

- Book identikit: **9.1.1**.
- Book source: `components/one-shot-countdown-timer.tex`.
- RTL SHA-256 (UTF-8, LF): `bcf6b072fbeda911e6464463f0deb9e1128cc0171db2f92229cf1fc6040fbe15`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
