# 10.1.2 — Moore FSM -- three-process

Separates state storage, next-state decisions, and output decode into three processes. The output process reads only the current registered state, so the machine retains Moore behavior while each concern remains independently visible.

Companion to *FPGA Identikits* by Andrea Fato, group **10.1 — Moore**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Keep process responsibilities exclusive.** Only the state-register process writes `state`; only next-state logic writes `nstate`; only output logic writes `y`. Multiple drivers defeat the separation and can make the design unresolved or synthesis-dependent.

**Complete both combinational processes.** Give `nstate` a hold default and `y` an inactive default before their case statements. Without defaults or otherwise complete assignments, uncovered paths can infer latches.

**Derive outputs only from state.** The output must depend only on state to remain Moore. This decoder therefore reads only `state`, which is also its sensitivity list; using `process(all)` would not change that dependency. The decode still uses combinational logic, however, so separating it into a process does not register the output.

**Synchronize external inputs first.** Separating the processes does not protect the state decision from an asynchronous `x`. Synchronize or handshake external controls before they enter the FSM.

**Constrain the sampled inputs.** `x` and synchronous `rst` must meet setup and hold at `clk`.

## Files

- [`moore_fsm_three_process.vhd`](moore_fsm_three_process.vhd): synthesizable reference template (VHDL-2008).
- [`tb_moore_fsm_three_process.vhd`](tb_moore_fsm_three_process.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit moore-fsm-three-process
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_moore_fsm_three_process`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_moore_fsm_three_process`; a failure assertion or timeout is a failure.
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
entity moore_fsm_three_process is
    port (
        clk : in  std_logic;
        rst : in  std_logic;
        x   : in  std_logic;
        y   : out std_logic
    );
end entity moore_fsm_three_process;
```

## Source traceability

- Book identikit: **10.1.2**.
- Book source: `components/moore-fsm-three-process.tex`.
- RTL SHA-256 (UTF-8, LF): `0d41f7e9928f56df0beab819be0375ba8db44e2d016c04f9088c704b5d854b25`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
