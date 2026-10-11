# 13.1.2 — Sequential restoring divider

Captures two unsigned operands and computes quotient and remainder in N cycles. Each step shifts in a dividend bit and tries a subtraction, keeping the difference only if the divisor fits.

Companion to *FPGA Identikits* by Andrea Fato, group **13.1 — Fixed scaling and iterative division**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Use the completion event.** Ignore intermediate `q` and `r`. Final values hold until the next accepted `start` or reset. A synchronous consumer samples `done` and the result at the following edge, even if a new request is accepted there.

**Define the request protocol.** Pulse `start` with coherent operands. Changes to `a` or `b` while `busy` have no effect. Holding `start` high requests another division at the next idle edge. There is no request queue.

**Treat zero as an error.** Check `b` before starting or track its zero status with the request. There is no error flag; `q` and `r` alone cannot identify zero division. Reset aborts any iteration, clears the outputs, and suppresses `done`.

**Constrain the inputs and timing.** Use synchronous, binary controls and operands; no invalid-input fallback is provided. Each shift/subtract step must meet one clock period. `N`-cycle latency does not justify a multi-cycle timing exception.

## Files

- [`sequential_restoring_divider.vhd`](sequential_restoring_divider.vhd): synthesizable reference template (VHDL-2008).
- [`tb_sequential_restoring_divider.vhd`](tb_sequential_restoring_divider.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit sequential-restoring-divider
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_sequential_restoring_divider`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_sequential_restoring_divider`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `1`
- `4`
- `8`

Checks include:
- Abort.
- Accept.
- Division result.
- Done width.
- Early completion.
- Latency.
- Zero divisor.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity sequential_restoring_divider is
    generic (N : positive := 8);
    port (
        clk, rst, start : in std_logic;
        a, b : in std_logic_vector(N-1 downto 0);
        q, r : out std_logic_vector(N-1 downto 0);
        busy, done : out std_logic
    );
end entity sequential_restoring_divider;
```

## Source traceability

- Book identikit: **13.1.2**.
- Book source: `components/sequential-restoring-divider.tex`.
- RTL SHA-256 (UTF-8, LF): `432920f467778088141dd24daf4ba1300a260162b48996ac04d6b6ead5a3a02e`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
