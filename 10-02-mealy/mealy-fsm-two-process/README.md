# 10.2.1 — Mealy FSM -- two-process

Separates a clocked state register from one combinational process that computes the next state and the outputs. Both the stored state and the present inputs can affect an output before the next active clock edge.

Companion to *FPGA Identikits* by Andrea Fato, group **10.2 — Mealy**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Default every combinational result.** Assign `nstate` and `y` before the case statement, then override them in explicit branches. This defines hold and inactive behavior on every path and prevents latches. In `S1`, any `x` other than `'1'` returns to `IDLE` with `y` low; the three-process form uses the same simulation policy.

**Mealy outputs are not clock-aligned.** Here `y` responds to `x` during the cycle. A Moore form removes direct input dependence but its combinational state decoder can still glitch. When the receiver requires a clocked, glitch-resistant interface, register the output and account for the resulting timing.

**Synchronize external inputs first.** An asynchronous `x` can violate timing at the state register and can also propagate directly to `y`. Synchronize or handshake it before the FSM; synchronization does not by itself make the combinational output glitch-free.

**Define reset-time outputs.** Reset changes state only at an active edge; outputs remain combinational. Verify the reset-state decode for every input through reset entry and release.

**Constrain the sampled controls.** Synchronous `rst` and the transition input `x` must meet setup and hold requirements at `clk`.

## Files

- [`mealy_fsm_two_process.vhd`](mealy_fsm_two_process.vhd): synthesizable reference template (VHDL-2008).
- [`tb_mealy_fsm_two_process.vhd`](tb_mealy_fsm_two_process.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit mealy-fsm-two-process
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_mealy_fsm_two_process`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_mealy_fsm_two_process`; a failure assertion or timeout is a failure.
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
entity mealy_fsm_two_process is
    port (
        clk : in  std_logic;
        rst : in  std_logic;
        x   : in  std_logic;
        y   : out std_logic
    );
end entity mealy_fsm_two_process;
```

## Source traceability

- Book identikit: **10.2.1**.
- Book source: `components/mealy-fsm-two-process.tex`.
- RTL SHA-256 (UTF-8, LF): `bd2ba07d247eb547029a25f9aa4ae16423a35581eedaa2a0034df9745918d657`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
