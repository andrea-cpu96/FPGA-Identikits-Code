# 10.1.1 — Moore FSM -- two-process

Separates a clocked state register from one combinational process that computes the next state and decodes the outputs. Inputs steer transitions; outputs depend only on the current stored state.

Companion to *FPGA Identikits* by Andrea Fato, group **10.1 — Moore**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Default every combinational result.** Assign `nstate` and `y` before the case statement to define hold and inactive behavior on every path. Without such defaults or otherwise complete assignments, an uncovered path can infer a latch.

**Moore describes dependency, not registration.** A Moore output depends only on state, but here it is decoded by combinational logic. State bits can change at slightly different times after an edge, causing a brief output transient. Choose the registered-output style when the receiving interface requires a clocked, glitch-resistant signal.

**Synchronize external inputs first.** The FSM does not make asynchronous `x` safe. A setup/hold violation can make the transition decision unpredictable; synchronize or handshake at the destination domain.

**Constrain the sampled inputs.** `x` and synchronous `rst` must meet setup and hold at `clk`.

**Account for decode delay.** A synchronous reset changes the stored state only at an active edge. The combinational output then settles after state clock-to-Q and decode delay, so downstream timing must include both delays.

## Files

- [`moore_fsm_two_process.vhd`](moore_fsm_two_process.vhd): synthesizable reference template (VHDL-2008).
- [`tb_moore_fsm_two_process.vhd`](tb_moore_fsm_two_process.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit moore-fsm-two-process
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_moore_fsm_two_process`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_moore_fsm_two_process`; a failure assertion or timeout is a failure.
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
entity moore_fsm_two_process is
    port (
        clk : in  std_logic;
        rst : in  std_logic;
        x   : in  std_logic;
        y   : out std_logic
    );
end entity moore_fsm_two_process;
```

## Source traceability

- Book identikit: **10.1.1**.
- Book source: `components/moore-fsm-two-process.tex`.
- RTL SHA-256 (UTF-8, LF): `1a669aa982fd1ec6f214b8601e3f0753e9de2230eec3952b9a6d6f5c7246e518`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
