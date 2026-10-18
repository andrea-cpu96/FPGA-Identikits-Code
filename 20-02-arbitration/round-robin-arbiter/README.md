# 21.2.2 — Round-robin arbiter

Grants a shared resource to one of N requesters. When idle, or when the current holder signals done, it searches from the requester after the last one served and registers a one-hot grant, or zero if none is active. Every active requester is served within N$-$1 other grants.

Companion to *FPGA Identikits* by Andrea Fato, group **20.2 — Arbitration**.
The RTL matches the printed VHDL template; see the book for its timing diagrams,
interface assumptions and design pitfalls.

## Usage requirements

**Fairness is counted in grants.** The bound requires a continuously pending request and every holder eventually raising `done`; one long service delays everyone. Limit service length when a bound in cycles is required.

**The pointer moves only on a grant.** A search that finds no request leaves `last` unchanged and the grant zero. A `done` while idle adds no completion action; pending requests can still win that edge.

**Consume grants synchronously.** Meet clock timing for `req` and `done`. A new request does not preempt a holder. Physical skew between registered grant bits is not a safe asynchronous driver handover; add dead-time logic where required.

**Rotation costs logic.** The search is a circular priority chain with a variable start. For wide N, use a masked double priority encoder or a tree, or split the arbiter into stages.

## Files

- [`round_robin_arbiter.vhd`](round_robin_arbiter.vhd): synthesizable reference template (VHDL-2008).
- [`tb_round_robin_arbiter.vhd`](tb_round_robin_arbiter.vhd): self-checking simulation testbench.

## Run this identikit

From the repository root, with Python 3 and ModelSim/Questa on PATH:

```text
python scripts/run_tests.py --identikit round-robin-arbiter
```

Alternatively compile the two files in a fresh simulator library, RTL first,
and run `tb_round_robin_arbiter`. VHDL-2008 and `std.env.finish` support are required.
The test ends with `PASS tb_round_robin_arbiter`; a failure assertion or timeout is a failure.
There are no dependencies on other identikit folders.

## Test scope

Generic configurations (positional, in the interface order below):
- `4`

Checks include:
- Arbitration.

These are functional RTL tests, not exhaustive verification of every generic
combination. Simulated CDC transfers cannot prove physical metastability safety;
target-specific synthesis, timing, reset and CDC constraints remain necessary.
Invalid-input tests may intentionally emit warnings; assertion failures are
never treated as passing tests.

## Interface

```vhdl
entity round_robin_arbiter is
    generic (N : positive := 4);
    port (
        clk, rst : in  std_logic;
        req      : in  std_logic_vector(N-1 downto 0);
        done     : in  std_logic;
        grant    : out std_logic_vector(N-1 downto 0)
    );
end entity round_robin_arbiter;
```

## Source traceability

- Book identikit: **21.2.2**.
- Book source: `components/round-robin-arbiter.tex`.
- RTL SHA-256 (UTF-8, LF): `6baf3b083f78c9b36393756c01a0f9ec7b602401b9ff3c1b12021cf13d5c42e9`.
- [Book manuscript](https://github.com/andrea-cpu96/FPGA-Digital-Blocks-Identikit).
