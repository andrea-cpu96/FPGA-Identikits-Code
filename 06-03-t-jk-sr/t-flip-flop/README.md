# 6.3.1 — T flip-flop

Toggles its output on every rising clock edge while t is high and holds it while t is low. A synchronous, active-high reset clears the bit.

Companion to *FPGA Identikits* by Andrea Fato, group **6.3 — T / JK / SR**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**A high toggle input acts on each rising edge.** A pulse on `t` that spans two rising edges produces two flips, so use a one-cycle enable when exactly one transition is required. Holding `t` high produces a divide-by-two state; treat that state as data or an enable unless it is routed through a dedicated clock resource.

**Constrain the toggle path.** `t` and synchronous `rst` must meet setup and hold at `clk`. The `q`-to-toggle feedback is inside the same register stage; still check the resulting clock-to-output and downstream setup path in static timing analysis.

**Feedback changes the next-state function.** Toggling is already implemented inside the template. Connecting `q` to `t` therefore changes the condition for the next toggle; it does not cause another toggle at the current edge. Like any registered feedback path, that connection must meet setup and hold.

## Files

- [`t_flip_flop.vhd`](t_flip_flop.vhd): synthesizable reference template (VHDL-2008).
- [`tb_t_flip_flop.vhd`](tb_t_flip_flop.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit t-flip-flop
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_t_flip_flop`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_t_flip_flop`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `no generics`

Checks include:
- Register control.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity t_flip_flop is
    port (
        clk : in  std_logic;
        t   : in  std_logic;
        rst : in  std_logic;
        q   : out std_logic
    );
end entity t_flip_flop;
```

## Source traceability

- Book identikit: **6.3.1**.
- Book source: `components/t-flip-flop.tex`.
- RTL SHA-256 (UTF-8, LF): `f1195917a282a7b627792fd5aaeaa0db493888bb6de88aa86ee7df36dd716be1`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
