# 9.1.3 — Watchdog timer

Once armed, counts down a fixed interval that each kick restarts. If the interval runs out first, it raises a registered, sticky expired flag that only reset clears.

Companion to *FPGA Identikits* by Andrea Fato, group **9.1 — Intervals & Timeouts**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Expiry beats a late kick.** A kick sampled on the expiry edge does not rescue the interval. Choose `TIMEOUT` above the slowest legitimate service interval with margin for worst-case latency.

**Keep arm and fault sticky.** Only reset disarms the timer or clears `expired`. Later kicks cannot hide a fault, and a glitch on `arm` cannot switch supervision off.

**Constrain the sampled controls.** Synchronous `rst`, `arm`, and `kick` must meet setup and hold requirements at `clk`.

**Kick from evidence of progress.** Pulse kick when supervised logic completes useful work. A stuck-high or free-running kick can hide a failure. Windowed or keyed variants add checks against early or stuck kicks.

**Plan the recovery path.** Resetting the watchdog also clears its reset request. Stretch that request as needed, record the cause, then re-arm after recovery. Transfer off-domain kicks through a pulse synchronizer.

## Files

- [`watchdog_timer.vhd`](watchdog_timer.vhd): synthesizable reference template (VHDL-2008).
- [`tb_watchdog_timer.vhd`](tb_watchdog_timer.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit watchdog-timer
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_watchdog_timer`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_watchdog_timer`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `2`
- `5`

Checks include:
- Watchdog.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity watchdog_timer is
    generic (
        TIMEOUT : integer range 2 to integer'high := 1000
    );
    port (
        clk, rst : in  std_logic;
        arm      : in  std_logic;
        kick     : in  std_logic;
        armed    : out std_logic;
        expired  : out std_logic
    );
end entity watchdog_timer;
```

## Source traceability

- Book identikit: **9.1.3**.
- Book source: `components/watchdog-timer.tex`.
- RTL SHA-256 (UTF-8, LF): `fc894996145e54442999001fcc62a52993ea7d843f82ea3d1ed6919b3f4ac804`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
