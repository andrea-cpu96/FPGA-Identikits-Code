# 10.2.2 — Mealy FSM -- three-process

Separates state storage, next-state decisions, and output decode into three processes. The output process reads both the current registered state and the present input, so the machine retains Mealy behavior and its immediate response.

Companion to *FPGA Identikits* by Andrea Fato, group **10.2 — Mealy**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Keep process responsibilities exclusive.** Only the state-register process writes `state`; only next-state logic writes `nstate`; only output logic writes `y`. The same input condition may appear in both combinational processes, so keep their intent visibly consistent. Here any `x` other than `'1'` returns `S1` to `IDLE` with `y` low, matching the two-process simulation policy.

**Complete both combinational processes.** Give `nstate` a hold default and `y` an inactive default. Without defaults or otherwise complete assignments, uncovered paths can infer latches.

**Include every read signal in the sensitivity list.** The output process must wake whenever state or any input it reads changes. If `x` is omitted from the sensitivity list, simulation may leave the old output unchanged even though the synthesized combinational circuit responds immediately.

**Synchronize external inputs first.** An asynchronous `x` can violate state-register timing and propagate directly to `y`. Use a synchronizer or handshake, and register the output when the receiver requires an edge-aligned, glitch-resistant control.

**Constrain the sampled controls.** Synchronous `rst` and the transition input `x` must meet setup and hold requirements at `clk`.

## Files

- [`mealy_fsm_three_process.vhd`](mealy_fsm_three_process.vhd): synthesizable reference template (VHDL-2008).
- [`tb_mealy_fsm_three_process.vhd`](tb_mealy_fsm_three_process.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit mealy-fsm-three-process
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_mealy_fsm_three_process`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_mealy_fsm_three_process`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `no generics`

Checks include:
- FSM after edge.
- FSM combinational output.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity mealy_fsm_three_process is
    port (
        clk : in  std_logic;
        rst : in  std_logic;
        x   : in  std_logic;
        y   : out std_logic
    );
end entity mealy_fsm_three_process;
```

## Source traceability

- Book identikit: **10.2.2**.
- Book source: `components/mealy-fsm-three-process.tex`.
- RTL SHA-256 (UTF-8, LF): `47a8203480fb1ded3147ab2ac1498994ace508fbf27ff577d3705db8bcf1b50b`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
